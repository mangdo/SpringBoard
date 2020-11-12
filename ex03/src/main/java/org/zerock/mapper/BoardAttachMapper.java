package org.zerock.mapper;
import java.util.List;
import org.zerock.domain.BoardAttachVO;

public interface BoardAttachMapper {
	public void insert(BoardAttachVO vo);
	
	//첨부파일의 수정이라는 개념이 존재하지않아서 삽입,삭제만 이건 하나의 첨부파일만.
	public void delete(String uuid);
	
	//특정 게시물의 번호로 첨부파일을 찾는 작업이 필요해서 findbyBno	
	public List<BoardAttachVO> findByBno(Long bno);
	
	// 하나의 bno에 연결된 모든 첨부파일을 삭제	
	public void deleteAll(Long bno);
	
	// 데이터베이스에서 어제 등록된 모든 첨부파일의 목록을 가져옴(for 쿼츠)
	public List<BoardAttachVO> getOldFiles();
	
}
