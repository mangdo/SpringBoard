package org.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;


@Service
@AllArgsConstructor
@Log4j
public class BoardServiceImpl implements BoardService{

	
	//spring 4.3 이상에서 자동처리 @Setter(onMethod_=@Autowired)
	private BoardMapper mapper;
	
	@Override
	public void register(BoardVO board) {
		log.info("register...");
		mapper.insertSelectKey(board);
	}

	@Override
	public BoardVO get(Long bno) {
			log.info("get.."+bno);
		return mapper.read(bno);
	}

	@Override
	public boolean modify(BoardVO board) {
		log.info("modify.."+board);
		//mapper.update()가 정상수행을 했을시 1, 아니면0을 리턴한다
		return mapper.update(board)==1;
		//1이면 true가 리턴
	}

	@Override
	public boolean remove(Long bno) {
		log.info("remove.." +bno);
		return mapper.delete(bno)==1;
	}
/*
	@Override
	public List<BoardVO> getList() {
		log.info("getlist...");
		
		return mapper.getList();
	}
*/
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
	
}
