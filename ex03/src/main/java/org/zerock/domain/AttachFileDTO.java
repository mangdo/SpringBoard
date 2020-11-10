package org.zerock.domain;

import lombok.Data;

//첨부파일을 저장한다.
@Data
public class AttachFileDTO {

	private String fileName; //원본 파일의 이름
	private String uploadPath; //업로드 경로
	private String uuid; 
	private boolean image; //이미지 여부
}
