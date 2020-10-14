package org.zerock.aop;

import java.util.Arrays;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Aspect
@Log4j
@Component
public class LogAdvice {
	
	@Before("execution(* org.zerock.service.SampleService*.*(..))")
	public void logBefore() {
		log.info("---------------");
	//excution은 aspectJ의 표현식임 	
	}
	
	//해당메서드에 전달되는 파라미터가 무엇인지 기록
	@Before("execution(* org.zerock.service.SampleService*.doAdd(String,String))&&args(str1,str2)")
	public void logBeforeWithParam(String str1, String str2) {
		log.info("str1 : "+str1);
		log.info("str2 : "+str2);
	}
	
	//예외발생시 동작하는 어노테이션 변수이름을 exception으로 지정
	//"execution(* org.zerock.service.SampleService*.*(..))"
	@AfterThrowing(pointcut = "execution(* org.zerock.service.SampleService*.*(..))", throwing="exception")
	public void logException(Exception exception) {
		log.info("Exception ... ");
		log.info("exception : "+exception);
	}
	
	//around는 직접 대상 메서드를 실행할 수 있고 메서드의 실행전후 처리가 가능하다
	//proceedingjoinpoint는 around와 같이 결합하여 파라미터나 예외등을 처리가능하다
	//성능측정
	@Around("execution(* org.zerock.service.SampleService*.*(..))")
	public Object logTime( ProceedingJoinPoint pjp) {
		long start = System.currentTimeMillis();
		
		log.info("Target : "+pjp.getTarget());
		log.info("Param : "+Arrays.toString(pjp.getArgs()));
		
		//invoke method
		Object result= null;
		
		try {
			result= pjp.proceed();
			
		}catch(Throwable e) {
			e.printStackTrace();
		}
		long end = System.currentTimeMillis();
		log.info("Time : "+(end-start));
		
		return result;
	}
}
