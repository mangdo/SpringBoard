package org.zerock.mapper;
import java.util.List;
import org.zerock.domain.BoardAttachVO;

public interface BoardAttachMapper {
	public void insert(BoardAttachVO vo);
	public void delete(String uuid);
	//첨부파일의 수정이라는 개념이 존재하지않아서 삽입,삭제만
	
	public List<BoardAttachVO> findByBno(Long bno);
	//특정 게시물의 번호로 첨부파일을 찾는 작업이 필요해서 findbyBno
}
