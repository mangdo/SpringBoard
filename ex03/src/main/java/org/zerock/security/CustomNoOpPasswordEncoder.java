package org.zerock.security;

import org.springframework.security.crypto.password.PasswordEncoder;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomNoOpPasswordEncoder implements PasswordEncoder{
	/*
	 * 스프링 5버전이후로 패스워드 인코딩이 필수가 되었다.
	 * 근데 패스워드 인코딩처리를 하고나면 사용자 계정등을 입력할때부터 인코딩 작업이 추가되어야해서 할일이 많아진다
	 * 그래서 일단은 passwordEncoder인터페이스를 상속받아서 직접 custom하고 인코딩은 나중에 해보자.
	 * 
	 */
	@Override
	public String encode(CharSequence rawPassword) {
		log.warn("before encode : "+rawPassword);
		return rawPassword.toString();
	}

	@Override
	public boolean matches(CharSequence rawPassword, String encodedPassword) {
		log.warn("matches : "+rawPassword +" : "+encodedPassword);
		return rawPassword.toString().equals(encodedPassword);
	}

}
