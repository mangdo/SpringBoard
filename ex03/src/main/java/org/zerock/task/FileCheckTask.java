package org.zerock.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.domain.BoardAttachVO;
import org.zerock.mapper.BoardAttachMapper;

import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {
	
	private BoardAttachMapper attachMapper;
	
	private String getFolderYesterDay() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		String str = sdf.format(cal.getTime());
		return str.replace("-", File.separator);
	}
	
	// 매일 새벽 2시마다
	@Scheduled(cron="0 0 2 * * *")
	public void checkFiles() throws Exception{
		log.warn("file check task run==========");
		log.warn(new Date());
		
		// DB에서 어제 등록된 모든 첨부파일의 목록을 가져옴
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		// 해당 폴더의 파일 목록에서 DB에 없는 파일을 찾아낸다.
		// ready for check file in directory with DB file list
		// db에서 가져온 파일목록은 BoardAttachVO 타입의 객체이므로 나중의 비교를 위해서 javanio.paths의 항목으로 변환
		List<Path> fileListPaths = fileList.stream()
				.map(vo->Paths.get("c:\\java\\upload", vo.getUploadPath(),vo.getUuid()+"_"+vo.getFileName()))
				.collect(Collectors.toList());
		
		// image file은 섬네일 파일도
		fileList.stream().filter(vo->vo.isFileType() == true)
			.map(vo->Paths.get("C:\\java\\upload",vo.getUploadPath(),"s_"+vo.getUuid()+"_"+vo.getFileName()))
			.forEach(p->fileListPaths.add(p));
		
		log.warn("=======");
		
		fileListPaths.forEach(p->log.warn(p));
		// 즉, fileListPaths는 예상 파일목록이다.
		// DB에 있는 파일들이다.
		
		//files in yesterday directory
		// targetDir은 서버에 있는 파일들
		// 어제 날짜의 서버 폴더 확인
		File targetDir= Paths.get("C:\\java\\upload",getFolderYesterDay()).toFile();
		
		// DB에 없는 파일을 찾기
		// targetDir의 폴더 중에서 fileListPaths에 없으면 removeFiles에 넣는다.
		// removeFiles는 지워야할 폴더 목록
		File[] removeFiles = targetDir.listFiles(file->fileListPaths.contains(file.toPath())==false);
		log.warn("====");
		
		// DB에 없는 파일을 삭제
		for(File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			file.delete();
		}
	}
}
