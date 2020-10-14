package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {

	private int startPage;
	private int endPage;
	private boolean prev, next;
	
	private int total;
	private Criteria cri;
	
	public PageDTO(Criteria cri, int total) {
	this.cri = cri;
	this.total=total;
	
	this.endPage=(int)(Math.ceil(cri.getPageNum()/10.0))*10;
	//Math.ceil은 올림
	
	this.startPage=this.endPage-9;
	
	int realEnd=(int) (Math.ceil((total*1.0)/cri.getAmount()));
	
	if(realEnd<this.endPage) {
		this.endPage=realEnd;
		//전체데이터수가 보여줘야하는 끝번호보다 작을 경우 바꿔준다.
	}
	
	this.prev = this.startPage > 1;
	//1만 아니라면 prev가 있음
	this.next = this.endPage < realEnd;
	}
}
