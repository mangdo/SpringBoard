package org.zerock.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class CommonController {
	
	@GetMapping("/accessError")
	public void accessDenied(Authentication auth, Model model) {
		log.info("acces Denied : "+auth);
		model.addAttribute("msg","Access Denied");
	}
	
	@GetMapping("/customLogin")
	public void loginInput(String error, String logout, Model model) {
		log.info("error: "+error);
		log.info("logout: "+logout);
		
		if(error != null) {
			model.addAttribute("error","Login Error Check Your Account");
		}
		if(logout!=null) {
			model.addAttribute("logout","logout!!");
		}
	}
	
	@GetMapping("/customLogout")
	public void logoutGET() {
		log.info("custom logout");
	}
	
	//post방식으로 로그아웃을 하게되면 자동으로 로그인 페이지를 호출한다. 
	//이부분은 시큐리티의 기본설정이므로 필요하다면 logout-success-url속성을 이용해서 변경가능하다.
	@PostMapping("/customLogout")
	public void logoutPost() {
		log.info("post custom logout");
	}
}
