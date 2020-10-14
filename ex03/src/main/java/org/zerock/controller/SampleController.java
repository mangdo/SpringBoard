package org.zerock.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.SampleVO;
import org.zerock.domain.Ticket;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/sample")
@Log4j
public class SampleController {
	//단순 문자열 반환
	@GetMapping(value= "/getText", produces = "text/plain; charset=UTF-8")
	public String getText() {
		log.info("MIME TYPE : "+MediaType.TEXT_PLAIN_VALUE);
		return "안녕하세요";
		
	}
	
	//객체 반환은 JSON이나 XML을 이용한다
	@GetMapping(value="/getSample", 
			produces= { MediaType.APPLICATION_JSON_UTF8_VALUE,
					MediaType.APPLICATION_XML_VALUE })
	public SampleVO getSample() {
		
		return new SampleVO(112,"스타","로드");
		
	}

	//컬렉션타입의 객체반환
	@GetMapping(value="/getList")
	public List<SampleVO> getList(){
		return IntStream.range(1,10).mapToObj(i->new SampleVO(i,i+" First",i+" Last"))
				.collect(Collectors.toList());
		
	}
	//map
	@GetMapping(value="/getMap")
	public Map<String, SampleVO> getMap(){
		Map<String, SampleVO> map = new HashMap<>();
		map.put("First", new SampleVO(11,"그루트","주니어"));
		
		return map;
	}
	
	@GetMapping(value="/check", params= {"height", "weight"})
	public ResponseEntity<SampleVO> check(Double height, Double weight){
		//ResponseEntity는 데이터와 함께 HTTP헤더의 상태 메시지등을 같이 전달하는 용도
		//http의 상태코드와 에러메시지등을 데이터와 함께 전달가능해서 받는 입장에서는 결과를 확실히 알 수 있다.
		
		SampleVO vo = new SampleVO(0,""+height,""+weight);
		
		ResponseEntity<SampleVO> result= null;
		
		if(height<150)
			result=ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(vo);
		else
			result=ResponseEntity.status(HttpStatus.OK).body(vo);

		return result;
	}
	
	@GetMapping("/product/{cat}/{pid}")
	public String[] getPath(@PathVariable("cat") String cat, @PathVariable("pid")Integer pid) {
		
		return new String[] {"category : "+cat, "productid : "+pid};
		
		
	}

	@PostMapping("/ticket")
	public Ticket convert(@RequestBody Ticket ticket) {
		
		log.info("convert ticket : ");
		
		return ticket;
	}
	
}
