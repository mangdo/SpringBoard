<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@include file="../includes/header.jsp"%>

<style>
.uploadResult {
	width:100%;
	background-color:gray;	
}

.uploadResult ul{
	display:flex;
	flex-flow : row;
	justify-content :center;
	align-items:center;
}

.uploadResult ul li {
	list-style:none;
	padding:10px;
	align-context :center;
	text-align : center;
}

.uploadResult ul li img{
	width:300px;
}

.uploadResult ul li span{
	color : white;
}

.bigPictureWrapper{
	position : absolute;
	display : none;
	jsutify-content:center;
	align-items:center;
	top:0%;
	width:100%;
	height:100%;
	background-color:gray;
	z-index:100;
	background:rgba(255,255,255,0.5);
}
.bigPicture{
	position:relative;
	display:flex;
	
	justify-content:center;
	align-items:center;
}

.bigPicture img{
	width:600px;
}
</style>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Tables</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
		
			<div class="panel-heading">Board Read Page</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				
				<div class= "form group">
				<label>Bno</label> <input class="form-control" name='bno'
				value = '<c:out value="${board.bno}"/>' readonly="readonly">
				</div>
				
				<div class= "form group">
				<label>Title</label> <input class="form-control" name='title'
				value = '<c:out value="${board.title}"/>' readonly="readonly">
				</div>
				
				<div class= "form group">
					<label>Text area</label> 
					<textarea class="form-control" rows="3" name='content' readonly="readonly"><c:out value="${board.content}"/>
					</textarea>
				</div>
				
				<div class= "form group">
				<label>Writer</label> <input class="form-control" name='writer'
				value = '<c:out value="${board.writer}"/>' readonly="readonly">
				</div>
				<!-- sec:authentication태그를 매번 이용하는것이 불편하기 대문에 로그인과 관련된 정보인 principal은 아예 pinfo라는 변수로 사용! -->
				<sec:authentication property="principal" var="pinfo"/>
				<sec:authorize access="isAuthenticated()">
					
					<c:if test="${pinfo.username eq board.writer}">
						<button data-oper='modify' class="btn btn-default">Modify</button>
					</c:if>
				</sec:authorize>
				<button data-oper='list' class="btn btn-info">List</button>
			
				<form id ='operForm' action="/board/modify" method ="get">
					<input type='hidden' id='bno' name='bno' value ='<c:out value="${board.bno }"/>'>
					<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum }"/>'>
					<input type='hidden' name='amount' value='<c:out value="${cri.amount }"/>'>				
				  	<input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>				
					<input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>				
				
				</form>
			
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<!-- 첨부파일 -->
<div class='bigPictureWrapper'>
	<div class='bigPicture'></div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Files</div>
			<div class="panel-body">
				<div class="uploadResult">
					<ul></ul>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- 댓글처리 -->
<div class= 'row'>
	<div class="col-lg-12">
	<!-- /.panel -->
	<div class = "panel panel-default">
		<div class ="panel-heading">
			<i class ="fa fa-comments fa-fw"></i>Reply~
			<sec:authorize access="isAuthenticated()">
			<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
			</sec:authorize>
		</div>
		
	<!-- /.panel-heading -->
	<div class ="panel-body">
		<ul class ="chat">
			<!-- start reply -->
			<li class ="left clarfix" data-rno='12'>
				<div>
				<div class="header">
					<strong class ="primary-font">user00</strong>
					<small class="pull-right text-muted">2018-01-01 13:13</small>
				</div>
				<p>Good!</p>
				</div>
			</li>	
		</ul>
	</div>
	
	<div class="pannel-footer">
	
	</div>
	
	</div>
	</div>
</div>



<%@include file="../includes/footer.jsp"%>

<!-- 댓글 추가는 모달창을 통해 진행한다. 모달창은 별도로 화면 중앙에 위치하기때문에 태그 위치는 중요하지xx script전이면됨 -->
<div class="modal fade" id ="myModal" tabindex="-1" role="dialog"
aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
		
			<div class="modal-header">
				<button type ="button" class="close" data-dismiss="modal"
				aria-hidden="true">&times;</button>
				<h4 class="modal-title" id ="myModalLabel"> REPLY MODAL</h4>
			
			</div>
			
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label>
					<input class="form-control" name='reply' value='newReply!!'>
				</div>
				
				<div class="form-group">
					<label>Replyer</label>
					<input class ="form-control" name='replyer' value='replyer'>
				</div>
				
				<div class="form-group">
					<label>Reply Date</label>
					<input class ="form-control" name='replyDate' value=''>
				</div>
			
			
			</div>
			<div class="modal-footer">
			<button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
			<button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
			<button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
			<button id='modalCloseBtn' type="button" class="btn btn-default">Close</button>
			</div>
		</div>
	</div> 
</div>

<script type="text/javascript" src="/resources/js/reply.js?ver=1"></script>

<script>
$(document).ready(function(){
	var bnoValue = '<c:out value="${board.bno}"/>';
	var replyUL = $(".chat");
	
	showList(1);//게시판의 조회페이지가 열리면 자동으로 댓글목록을 가져온다.
	
	function showList(page){
		replyService.getList({ bno:bnoValue, page : page||1 }, function(replyCnt, list){
			
			//마지막 페이지를 찾아서 다시 호출
			//새 댓글작성시 마지막 댓글 페이지로 가서 새댓글 보여주기
			if(page==-1){
				pageNum = Math.ceil(replyCnt/10.0);
				showList(pageNum);
				return;
			}
			
			var str="";

			// 댓글이 없다.
			if(page == -1){ 
				replyUL.html("");
				
				return;
			}
			
			for(var i =0, len = list.length ||0; i<len; i++){
				str += "<li class = 'left clearfix' data-rno='"+list[i].rno+"'>";
				str += " <div> <div class='header'><strong class='primary-font'>" + list[i].replyer+"</strong>";
				str += " <small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
				str += " <p>"+list[i].reply+"</p</div></li>";
			}
			replyUL.html(str);
			//chat(댓글)의 innerHTML로 추가
			
			showReplyPage(replyCnt);//댓글 페이지번호출력
		});
	}
	
	var modal = $(".modal");
	var modalInputReply = modal.find("input[name='reply']");
	var modalInputReplyer = modal.find("input[name='replyer']");
	var modalInputReplyDate = modal.find("input[name='replyDate']");
	
	var modalModBtn = $("#modalModBtn");
	var modalRemoveBtn = $("#modalRemoveBtn");
	var modalRegisterBtn = $("#modalRegisterBtn");
	
	var replyer = null;
	<sec:authorize access="isAuthenticated()"> // 코드가 에러날 수 있지만 실제론 정상동작하는 코드다.
	replyer = '<sec:authentication property="principal.username"/>';
	</sec:authorize>
	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	$("#modalCloseBtn").on("click", function(e){
    	modal.modal('hide');
    });
    
	$("#addReplyBtn").on("click", function(e){
	
		modal.find("input").val("");
		modal.find("input[name='replyer']").val(replyer);
		modalInputReplyDate.closest("div").hide();
		modal.find("button[id != 'modalCloseBtn']").hide();
		
		modalRegisterBtn.show();
		
		$(".modal").modal("show");
	});
	
	//ajax spring security header..
	//ajaxSend를 이용한 코드는 모든 ajax전송시에 csrf토큰을 같이 전송하도록 세팅
	$(document).ajaxSend(function(e,xhr,options){
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
	
	modalRegisterBtn.on("click", function(e){
		
		var reply ={
				reply : modalInputReply.val(),
				replyer : modalInputReplyer.val(),
				bno:bnoValue
		};
		replyService.add(reply, function(result){
			alert(result);
			modal.find("input").val("");
			modal.modal("hide");
			
			showList(-1); // 댓글 추가후 목록업뎃
			
			
		});
	});
	
	//특정댓글의 클릭이벤트시 수정/삭제
	//<ul>클래스 chat을 이용해서 이벤트를 걸고(이벤트 위임)
	//실제이벤트의 대상은 <li>가되도록
	$(".chat").on("click","li", function(e){
		var rno = $(this).data("rno");
		
		replyService.get(rno, function(reply){
			modalInputReply.val(reply.reply); //가져오고
			modalInputReplyer.val(reply.replyer);
			modalInputReplyDate.val(replyService.displayTime( reply.replyDate )).attr("readonly","readonly");
			modal.data("rno", reply.rno); //rno는 필요하니까 data-rno속성을 만들어서 추가한다
			
			modal.find("button[id!='modalCloseBtn']").hide();
			modalModBtn.show();
			modalRemoveBtn.show();
			
			$(".modal").modal("show");
			
		});
	});
	
	modalModBtn.on("click",function(e){
		
		var originalReplyer = modalInputReplyer.val();
		
		var reply = {
				rno:modal.data("rno"),
				reply:modalInputReply.val(),
				replyer:originalReplyer
		};
		
		//원래 댓글작성자일때만 삭제가능
		if(!replyer){
			alert("로그인 후 삭제가 가능하다");
			modal.modal("hide");
			return;
		}
				
		if(replyer != originalReplyer){
			alert("자신이 작성한 댓글만 삭제가 가능하다");
			modal.modal("hide");
			return;
		}
		
		
		replyService.update(reply, function(result){
			alert(result);
			modal.modal("hide");
			showList(pageNum);//목록 갱신
		});
	});
	
	modalRemoveBtn.on("click",function(e){
		var rno = modal.data("rno");
		//원래 댓글작성자일때만 삭제가능
		if(!replyer){
			alert("로그인 후 삭제가 가능하다");
			modal.modal("hide");
			return;
		}
		
		var originalReplyer = modalInputReplyer.val();
		
		if(replyer != originalReplyer){
			alert("자신이 작성한 댓글만 삭제가 가능하다");
			modal.modal("hide");
			return;
		}
		
		replyService.remove(rno, originalReplyer, function(result){
			alert(result);
			modal.modal("hide");
			showList(pageNum);//목록 갱신
		});
	});
	
	//pannel-footer에 댓글 페이지 번호를 출력한다.
	var pageNum=1;
	var replyPageFooter = $(".pannel-footer");
	
	function showReplyPage(replyCnt){
		var endNum = Math.ceil(pageNum/10.0) * 10;
		var startNum = endNum-9;
		
		var prev = (startNum!=1);
		var next = false;
		console.log(endNum);
		
		if(endNum*10 >= replyCnt){
			endNum = Math.ceil(replyCnt/10.0);
		}
		
		if(endNum*10 < replyCnt){ next = true;}
		
		var str= "<ul class ='pagination pull-right'>";
		
		if(prev){
			str +="<li class = 'page-item'> <a class='page-link' href ='"
				+ (startNum-1)+"'> Previous</a></li>";
		}
		
		for(var i = startNum; i<=endNum; i++){
			var active =(pageNum ==i? "active":"");
			str += "<li class ='page-item "+active+" '><a class ='page-link' href ='"
				+i+"'>"+i+"</a></li>";
		}
		
		if(next){
			str += "<li class='page-item'><a class='page-link' href ='"
				+(endNum+1)+"'>next</a></li>";
		}
		
		str+="</ul></div>";
		
		console.log(str);
		replyPageFooter.html(str);
	}
	
	replyPageFooter.on("click","li a", function(e){
		e.preventDefault();
		console.log("page click");
		var targetPageNum = $(this).attr("href");
		
		pageNum = targetPageNum;
		console.log("targetPage : "+targetPageNum);
		showList(pageNum);
		
	})
	
	
});

</script>
<!--버튼 클릭 시 -->
<script type= "text/javascript">
$(document).ready(function(){

	
	var operForm = $("#operForm");

	$("button[data-oper='modify']").on("click",function(e){
		operForm.attr("action","/board/modify").submit();
		
	});
	
	$("button[data-oper = 'list']").on("click",function(e){
		operForm.find("#bno").remove();

		operForm.attr("action","/board/list");
		operForm.submit();
	});
	
});
</script>


<!-- 첨부파일 -->
<script>
$(document).ready(function(){
	(function(){
		var bno = '<c:out value="${board.bno}"/>';
		$.getJSON("/board/getAttachList", {bno:bno}, function(arr){
			console.log(arr);
			var str = "";
			$(arr).each(function(i, attach){
				// image타입
				if(attach.fileType){
					var fileCallPath = encodeURIComponent( attach.uploadPath + "/s_"+attach.uuid+"_"+attach.fileName);
					str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'> </div>";
					str += "<img src='/display?fileName="+fileCallPath+"'>";
					str += "</div></li>";
				}else{// 파일타입
					str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'> </div>";
					str += "<span> "+attach.fileName+"</span><br/>"
					str += "<img src='/resources/img/attach.png'>";
					str += "</div></li>";
				}
			});
			
			$(".uploadResult ul").html(str);
		});//end getjson
		
	})();//end function(즉시실행 함수)
	
	//첨부파일 클릭시 이벤트 처리
	$(".uploadResult").on("click","li",function(e){
		console.log("view image");
		var liObj = $(this);
		
		var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
		if(liObj.data("type")){//이미지의 경우 크게 보여줌
			showImage(path.replace(new RegExp(/\\/g),"/"));
		}else{
			//파일인 경우엔 다운로드
			self.location="/download?fileName="+path;
		}
	});
	
	//원본이미지 보여주기
	function showImage(fileCallPath){
		alert(fileCallPath);
		$(".bigPictureWrapper").css("display","flex").show();
		
		$(".bigPicture")
		.html("<img src= '/display?fileName="+fileCallPath+"'>")
		.animate({width:'100%', height:'100%'},1000); //배경이 흐려진 상태에서 원본 이미지가 점차 크게보여지게함.
	}
	
	//원본 이미지 클릭시 창닫기
	$(".bigPictureWrapper").on("click", function(e){
		$(".bigPicture").animate({width:'0%',height:'0%'},1000);
		setTimeout(function(){
			$('.bigPictureWrapper').hide();
			
		},1000);
		
	});
});

</script>