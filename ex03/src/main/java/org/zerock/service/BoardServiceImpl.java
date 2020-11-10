package org.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;


@Service
@AllArgsConstructor
@Log4j
public class BoardServiceImpl implements BoardService{

	
	//spring 4.3 이상에서 자동주입 @Setter(onMethod_=@Autowired)대신
	
	private BoardMapper mapper;
	
	private BoardAttachMapper attachMapper;
	
	@Transactional //tbl_board와 tbl_attach테이블의 insert가 같이 진행디ㅗ어야해서
	@Override
	public void register(BoardVO board) {
		log.info("register...");
		
		//우선 tbl_board에저장
		mapper.insertSelectKey(board); //Mybatis의 selectkey를 이용해서 별도의 currval을 매번 호출할 필요가 없다.
		
		if(board.getAttachList()==null || board.getAttachList().size()<=0) return;
		
		// tbl_attach에도 저장
		board.getAttachList().forEach(attach->{
			attach.setBno(board.getBno()); //각 첨부파일은 게시물번호 세팅
			attachMapper.insert(attach);
		});
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
