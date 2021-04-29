package org.zerock.service;

import java.util.List;


import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;


@Service
@RequiredArgsConstructor
@Log4j
public class BoardServiceImpl implements BoardService{

	// 생성자 주입
	private final BoardMapper mapper;
	private final BoardAttachMapper attachMapper;
	
	@Transactional // tbl_board와 tbl_attach테이블의 insert가 같이 진행되어야 한다.
	@Override
	public void register(BoardVO board) {
		log.info("register...");
		
		// 우선 tbl_board에저장
		mapper.insertSelectKey(board); // Mybatis의 selectkey를 이용해서 별도의 currval을 매번 호출할 필요가 없다.
		
		if(board.getAttachList()==null || board.getAttachList().size()<=0) return;
		
		// tbl_attach에도 저장
		board.getAttachList().forEach(attach->{
			attach.setBno(board.getBno()); //각 첨부파일에 게시물번호 세팅
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {
			log.info("get.."+bno);
		return mapper.read(bno);
	}

	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		log.info("modify.."+board);
		
		// mapper.update()가 정상수행을 했을시 true를 반환한다.
		boolean modifyResult = mapper.update(board)==1;
		
		// 기존 첨부파일은 우선 삭제
		attachMapper.deleteAll(board.getBno());
		// 다시 첨부파일 데이터를 추가한다.
		if(modifyResult&&board.getAttachList()!=null&&board.getAttachList().size()>0) {
			board.getAttachList().forEach(attach->{
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		return modifyResult; 
	}
	
	@Transactional
	@Override
	public boolean remove(Long bno) {
		log.info("remove.." +bno);
		
		attachMapper.deleteAll(bno); // 첨부파일 삭제
		return mapper.delete(bno)==1;
		
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("getlist with Criteria "+cri);
		
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("get attch list by bno"+bno);
		return attachMapper.findByBno(bno);
	}
	
}
