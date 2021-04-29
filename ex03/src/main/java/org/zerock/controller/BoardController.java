package org.zerock.controller;

import java.util.List;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.Files;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequiredArgsConstructor
@Controller
@Log4j
@RequestMapping("/board/*")
public class BoardController {
	
	private final BoardService service;
	
	// 게시물의 목록 조회
	@GetMapping("/list")
	public void list(Model model, Criteria cri) {
		
		log.info("list : "+cri);
		model.addAttribute("list", service.getList(cri));
		
		int total = service.getTotal(cri);
		log.info("total: "+total);
		
		model.addAttribute("pageMaker", new PageDTO(cri,total));
	}
	
	// 게시물의 등록페이지
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()") // 로그인한 사용자만 글작성
	public void register() {
		// 입력페이지를 보여주는 역할만 해서 별도의 처리가 필요하지 않는다.
		// 리턴이 void인 경우 해당 URL경로를 그대로 jsp파일의 이름으로 사용
	}
	
	// 게시물의 등록
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String register(BoardVO board, RedirectAttributes rttr) {
		
		log.info("regiter : "+board);
		
		// 첨부파일도 등록
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach->log.info(attach));
		}
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());
		
		// 새롭게 등록된 게시물의 번호를 같이 전달
		return "redirect:/board/list";
	}
	
	// 게시물의 조회페이지와 수정페이지
	@GetMapping({"/get","/modify"})
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		
		log.info("/get or modify");
		model.addAttribute("board",service.get(bno));
		
	}

	// 게시물 수정
	@PreAuthorize("principal.username == #board.writer") //컨트롤러에 전달되는 파라미터를 #로 접근가능.
	@PostMapping("/modify")
	public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify : "+board);
		
		if(service.modify(board)) {
			rttr.addFlashAttribute("result","succes");
		}

		return "redirect:/board/list"+cri.getListLink();

	}
	
	// 게시물 삭제
	@PreAuthorize("principal.username == #writer")
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr, String writer) {
		log.info("remove.."+writer);
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		if(service.remove(bno)) {
			// 첨부파일 삭제
			deleteFiles(attachList);
			rttr.addFlashAttribute("result","success");
		}
		return "redirect:/board/list"+cri.getListLink();

		
	}

	// 해당 게시물의 첨부파일 목록 조회
	@GetMapping(value="/getAttachList", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno){
		log.info("getAttachList " + bno);
		return new ResponseEntity<>(service.getAttachList(bno),HttpStatus.OK);
	}
	
	// 첨부파일 삭제
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		log.info("delete attach files..");
		log.info(attachList);
		
		attachList.forEach(attach->{
			try {
				Path file = Paths.get("C:\\java\\upload\\"+attach.getUploadPath()+"\\"+attach.getUuid()+"_"+attach.getFileName());
				Files.deleteIfExists(file);
				
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("C:\\java\\upload\\"+attach.getUploadPath()+"\\s_"+attach.getUuid()+"_"+attach.getFileName());
					Files.delete(thumbNail);
				}
			} catch(Exception e) {
			log.error("delete file error"+e.getMessage());
			}
		});
	}
}