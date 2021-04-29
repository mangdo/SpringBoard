# SpringBoard
> Spring Framework를 사용한 게시판 웹 프로젝트입니다.   
> '코드로 배우는 스프링 웹프로젝트(구멍가게 코딩단 저)를 참고하여 제작하였습니다.

<br>

## 1. 제작 기간 & 참여 인원
+ 2020년 10월 14일 ~ 2020년 11월 20일
+ 개인 프로젝트

## 2. 사용기술

#### `Back-end`
+ Java 8
+ Spring Framework 5.0.7
+ Maven 2.5.1
+ Oracle 11g
+ Spring Security 5.0.6

#### `Front-end`
+ JQuery 3.5.1
+ Bootstrap 3.3.7
+ 부트 스트랩 탬플릿 [SB Admin2](https://startbootstrap.com/theme/sb-admin-2) 사용

#### `Test`
+ JUnit 4.12

## 3. ERD 설계
<img src="https://user-images.githubusercontent.com/70243735/116400783-6683a980-a865-11eb-97a6-3a8e0060417c.jpg">

## 4. 실행화면

<img src="https://user-images.githubusercontent.com/70243735/116489190-4c7eb100-a8cf-11eb-8efd-413448cc76bf.gif">

## 5. 핵심 기능

+ #### 로그인
  : Spring Security를 사용하여 로그인을 할 수 있습니다.

  <details>
  <summary> 로그인 설명 펼치기:pushpin: </summary>
  
  **[ 상세 구조 ]**
  <img src ="https://user-images.githubusercontent.com/70243735/116403050-122df900-a868-11eb-8d23-b885a78dcc12.png">

    + **AuthenticaionProvider**    
      : 실제 인증 작업을 진행합니다. 사용자가 인증 요청한 정보와 DB의 사용자 정보가 일치하는지를 확인합니다.  

    + **PasswordEncoder**   
      : 패스워드를 암호화합니다.  
      : 암호화되지 않은 실제 패스워드를 저장하는 일은 위험하기 때문에 암호화된 패스워드로 저장하고, 사용자가 패스워드를 입력하면 이를 암호화해서 저장된 패스워드와 비교합니다.

    + **BCyptPasswordEncoder**   
      : PasswordEncoder구현한 클래스중 하나입니다. 해시 함수로 특정 문자열을 암호화하기 때문에 암호화를 한 후에, 다시 원문으로 돌리지 못합니다.

    + **CustomUserDetailsService**    
      : [CustomUserDetailsService](./ex03/src/main/java/org/zerock/security/CustomUserDetailsService.java)은 UserDetailsService를 구현하여 DB의 사용자 정보를 조회합니다.    
      : 유일한 메소드인 loadUserByUsername()는 UserDetails를 상속받아 만든 CustomUser를 반환합니다.   

    + **CustomUser**   
      : [CustomUser](./ex03/src/main/java/org/zerock/security/domain/CustomUser.java)는 조회한 사용자 정보를 담고있습니다.   
      : Spring Security에서 제공하고 있는 UserDetails를 구현한 여러 클래스 중에서 User클래스를 상속받았습니다.

    + **security-context.xml**   
     : [security-context.xml](./ex03/src/main/webapp/WEB-INF/spring/security-context.xml)은 Spring Security와 관련된 설정을 담고 있습니다.

    + **MemberMapper**   
     : MemberMapper.java - [MemberMapper.xml](./ex03/src/main/resources/org/zerock/mapper/MemberMapper.xml)의 구조를 가집니다.
     
  </details>

+ #### 게시글의 CRUD   
  : 로그인한 사용자는 게시물을 등록할 수 있으며, 자신의 게시물만 수정, 삭제할 수 있습니다.

  <details>
   <summary> 게시글 CRUD 설명 펼치기:pushpin: </summary>

   **[ 상세 구조 ]**
   <img src = "https://user-images.githubusercontent.com/70243735/116401759-92ebf580-a866-11eb-9034-a7ed322c3fea.png">
   + **[BoardController](./ex03/src/main/java/org/zerock/controller/BoardController.java)**
   
   + **BoardService**   
    : BoardService.java - [BoardServiceImpl.java](./ex03/src/main/java/org/zerock/service/BoardServiceImpl.java)의 구조를 가집니다.
  
   + **BoardMapper**   
    : BoardMapper.java - [Boardmapper.xml](./ex03/src/main/resources/org/zerock/mapper/BoardMapper.xml)의 구조를 가집니다.
  </details>

+ #### 댓글의 CRUD
  : 로그인한 사용자는 게시물의 댓글을 달 수 있습니다.   
  : RestController과 AJAX를 사용하였습니다.   

  <details>
   <summary> 댓글 CRUD 설명 펼치기:pushpin: </summary>

    **[ 상세 구조 ]**
   <img src = "https://user-images.githubusercontent.com/70243735/116401931-c62e8480-a866-11eb-87b1-3289c7a968f8.png">
  
    + **ReplyController**    
     : 데이터를 반환하는 [ReplyController](./ex03/src/main/java/org/zerock/controller/ReplyController.java)를 사용하였고, View단에서 JQuery의 [AJAX](./ex03/src/main/webapp/resources/js/reply.js)로 데이터를 주고 받습니다.

    + **ReplyService**   
     : ReplyService.java - [ReplyServiceImpl.java](./ex03/src/main/java/org/zerock/service/ReplyServiceImpl.java)의 구조를 가집니다.
  
    + **ReplyMapper**   
     : ReplyMapper.java - [Replymapper.xml](./ex03/src/main/resources/org/zerock/mapper/ReplyMapper.xml)의 구조를 가집니다.

  </details>

+ #### 첨부파일의 CRUD
   : 게시물에 이미지 파일과 일반 파일을 첨부할 수 있습니다.   
   : RestController과 AJAX를 사용하였습니다.   

  <details>
   <summary> 첨부파일 CRUD 설명 펼치기:pushpin: </summary>

    **[ 상세 구조 ]**
     <img src = "https://user-images.githubusercontent.com/70243735/116402175-0db51080-a867-11eb-997e-a63966374fb0.png">
  
   + **[UploadController](./ex03/src/main/java/org/zerock/controller/UploadController.java)**    
    : 사용자가 **최종적으로 게시물을 등록하기 전**에 어떤 파일을 업로드 하는지 알 수 있도록 첨부파일을 **AJAX**를 이용하여 **서버에 업로드** 시킵니다.    
    (1) UploadController의 uploadFormPost()는 **첨부 파일의 정보**(이름, 업로드 경로, uuid값, 타입)을 반환합니다.   
    (2) iew에서는 받은 첨부 파일의 정보를 이용해서 **이미지 파일이라면 섬네일 이미지**를, 파일이라면 파일 아이콘을 보여줍니다.   
        이때 UploadController의 display()를 통해서 **이미지 파일 데이터**를 가져옵니다.   

    + **[BoardController](./ex03/src/main/java/org/zerock/controller/BoardController.java)**   
      (1) 게시물을 최종적으로 등록 할 때, 첨부 파일의 정보를 DB에 저장합니다.   
      (2) 게시물을 삭제할 때, 첨부 파일도 삭제합니다.   

   + **BoardService**   
     : tbl_board와 tbl_attach 테이블의 등록, 수정, 삭제는 함께 진행되어야하기 때문에 **트랜잭션**을 적용합니다.   
     : BoardService.java - [BoardServiceImpl.java](./ex03/src/main/java/org/zerock/service/BoardServiceImpl.java)의 구조를 가집니다.   

   + **BoardAttachMapper**   
     : BoardMapper.java - [Boardmapper.xml](./ex03/src/main/resources/org/zerock/mapper/BoardAttachMapper.xml)의 구조를 가집니다.   
  </details>

<br>

## 6. 회고 / 느낀점
