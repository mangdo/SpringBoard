package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@RestController
@Log4j
public class UploadController {
	
	// 한 폴더에 너무 많은 파일이 들어가지 않도록 '년/월/일' 폴더 생성
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date date = new Date();
		
		String str= sdf.format(date);
		
		return str.replace("-",File.separator);
	}
	
	// 첨부파일 업로드
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		
		List<AttachFileDTO> list = new ArrayList<>();
		String uploadFolder= "C:\\java\\upload";
		
		String uploadFolderPath = getFolder();
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		
		if(uploadPath.exists()==false) {
			
			uploadPath.mkdirs();
		}
		
		for(MultipartFile multipartFile : uploadFile) {
			log.info("-----------------");
			log.info("upload file name : "+multipartFile.getOriginalFilename());
			log.info("upload file size : "+multipartFile.getSize());
			
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			// IE의 file path을 다르게 처리
			// chrome은 test3.jpg라면 IE는 c:\\Users\\사진\\test3.jpg
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\")+1);
			log.info("only file name : "+uploadFileName);
			attachDTO.setFileName(uploadFileName);
			
			// 중복된 이름의 파일이 저장 가능하도록 UUID 생성
			UUID uuid= UUID.randomUUID();
			uploadFileName = uuid.toString()+"_"+uploadFileName;
			
			
			try {
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				// 이미지 파일인지 체크
				if(checkImageType(saveFile)) {
					attachDTO.setImage(true);
					
					FileOutputStream thumnail = new FileOutputStream(new File(uploadPath,"s_"+uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumnail,200,200);
					
					thumnail.close();
				}
				// add to list
				list.add(attachDTO);
			}catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		return new ResponseEntity<>(list, HttpStatus.OK);
		
	}
	
	// 이미지 파일인지 체크
	private boolean checkImageType(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath());
			
			return contentType.startsWith("image");
		}catch(IOException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	// 이미지 데이터 전송
	@GetMapping("/display")
	public ResponseEntity<byte[]> getFile(String fileName){
		log.info("file Name : "+fileName);
		File file = new File("c:\\java\\upload\\"+fileName);
		ResponseEntity<byte[]> result = null;
		try {
			HttpHeaders header =new HttpHeaders();
			
			// 파일 확장자에 따라서 MIME타입이 다르게 처리될 수 있어 Content-Type 헤더에  MIME타입을 지정해준다.
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
			
		}catch(IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	// 첨부파일 다운로드
	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent")String userAgent, String fileName){
		Resource resource = new FileSystemResource("C:\\java\\upload\\"+fileName);
		log.info("resource "+resource);
		if(resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		String resourceName = resource.getFilename();
		// UUID를 잘라서 다운로드되는 순수한 파일이름으로 저장되게
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_")+1);
		
		HttpHeaders headers= new HttpHeaders();
		try {
			String downloadName = null;
			if(userAgent.contains("Trident")) {
				log.info("IE");
				// IE 브라우저의 엔진이름 Trident
				// IE시험할때 IE의 주소창에서는 한글이 직접 처리되지않음으로 URL Encoding작업을 따로 URLEncode website에서 해준다음 호출해야한다.
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+"," ");
			}else if(userAgent.contains("Edge")) {
				log.info("endge");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
			}else {
				log.info("chrome");
				//chrome
				downloadName= new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
				
			}
			
			
			headers.add("Content-Disposition", "attachment; filename="+ downloadName);
			// 다운로드시 저장되는 이름은 Content-Disposition을 이용해서 지정
			// 파일이름이 한글인 경우 깨지는 문제를 처리하기위해서 String처리
			// IE의 경우 크롬과 달리 Content-Disposition 값을 처리하는 인코딩방식이 다르다.
			// 그래서 디바이스의 정보를 알수 있는 헤더인 'User-Agent'값을 이용한다.
			// 이를 이용해서 브라우저의 종류나 모바일/pc 구분
			
		}catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);

	}
	
	// 첨부파일 삭제
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/deleteFile")
	public ResponseEntity<String> deleteFile(String fileName, String type){
		log.info("deleteFile : "+fileName);
		
		File file;
		
		try {
			file = new File("c:\\java\\upload\\"+URLDecoder.decode(fileName,"UTF-8"));
			
			file.delete();
			
			if(type.equals("image")) {
				// 이미지의 경우에는 원본이미지 뿐만아니라 썸네일도 같이 지워야한다.
				// 썸네일은 이름에 s_가 있었음.
				String largeFileName = file.getAbsolutePath().replace("s_","");
				
				log.info("largefile name"+largeFileName);
				
				file=new File(largeFileName);
				file.delete();
			}
		}catch(UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
}
