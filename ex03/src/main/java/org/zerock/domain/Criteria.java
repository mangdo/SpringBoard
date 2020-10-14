package org.zerock.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {
	//Criteria:검색의 기준
	private int pageNum;
	private int amount;
	
	private String type;
	private String keyword;
	
	public Criteria() {
		
		this(1,10);
	}
	
	public Criteria(int pageNum, int amount) {
		this.pageNum=pageNum;
		this.amount=amount;
	}
	
	public String[] getTypeArr() {
		return type==null? new String[] {} : type.split("");
		//검색조건이 각글자(T,W,C)로 구성되어있으므로 그 조건을 배열로 만들어서 한번에 처리하기 위함
		//BoardMapper.xml의 foreach구문으로 들어감. collection='typeArr'이다.
		//collectiond은 전달받은 인자, item은 전달받은 인자를 어떤 이름으로 대체할지
		
	}
	
	//여러개의 파라미터를 연결해서 URL형태로 만들어주는 기능을 가지고 있다.
	public String getListLink() {
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", this.pageNum)
				.queryParam("amount", this.getAmount())
				.queryParam("type", this.getType())
				.queryParam("keyword", this.getKeyword());
	
	return builder.toUriString();
	}
}
