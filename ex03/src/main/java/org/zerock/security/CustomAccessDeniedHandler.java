package org.zerock.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler{

	// 단순히 접근제한 에러 페이지만 제공하는 것이아닌
	// 접근제한이 된 경우에 다양한 처리를 하고 싶다면 직접 AccessDeniedHandler 인터페이스를 구현하는 편이 좋다.
	
	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {
		log.error("Access Denied Handler");
		log.error("Redirect..");
		response.sendRedirect("/accessError");
		
	}
	
	
}
