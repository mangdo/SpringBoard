package org.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {
	private Long bno;
	private String title;
	private String content;
	private String writer;
	private Date regdate;
	private Date updateDate;
	
	private int replyCnt; //댓글 갯수
	
	private List<BoardAttachVO> attachList;
	//등록시에 한번에 BoardAttachVO를 처리할 수  있도록(첨부파일들을 한번에 처리할 수 있도록)
}
