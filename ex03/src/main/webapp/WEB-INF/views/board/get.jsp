<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp"%>

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
				
				<button data-oper='modify' class="btn btn-default" >
				Modify</button>
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

<!-- 댓글처리 -->
<div class= 'row'>
	<div class="col-lg-12">
	<!-- /.panel -->
	<div class = "panel panel-default">
		<div class ="panel-heading">
			<i class ="fa fa-comments fa-fw"></i>Reply~
			<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
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
	console.log("--------");
	console.log("JS TEST");

	var bnoValue='<c:out value="${board.bno}"/>';

	/*for replyService add test
	replyService.add(
	{reply:"JS TEST", replyer : "tester", bno:bnoValue}
	,function(result){
		alert("RESULT : " +result);	
	}
	);
	*/
	
	//reply List test
	replyService.getList({bno:bnoValue, page :1}, function(list){
		for(var i =0, len = list.length||0; i<len ; i++){
			console.log(list[i]);
		}
		
	});
	
	/*32번 댓글 삭제 테스트
	replyService.remove(32, function(count){
		console.log(count);
		
		if(count==="success"){
			alert("REMOVED");
		}}, function(err){ alert("ERROR");}
		
	);
	*/
	
	//35번 댓글 수정
	replyService.update({
		rno : 35,
		bno : bnoValue,
		reply : "Modify reply~~~~"
	}, function(result){
		alert("수정완료");
	})
	
	//특정 번호의 댓글조회 GET방식으로 처리함
	replyService.get(10, function(data){
		console.log(data);
	})

</script>

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
	
	$("#addReplyBtn").on("click", function(e){
	
		modal.find("input").val("");
		modalInputReplyDate.closest("div").hide();
		modal.find("button[id != 'modalCloseBtn']").hide();
		
		modalRegisterBtn.show();
		
		$(".modal").modal("show");
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
		var reply = {
				rno:modal.data("rno"),
				reply:modalInputReply.val()
		};
		
		replyService.update(reply, function(result){
			alert(result);
			modal.modal("hide");
			showList(pageNum);//목록 갱신
		});
	});
	
	modalRemoveBtn.on("click",function(e){
		var rno = 
				modal.data("rno");
		
		replyService.remove(rno, function(result){
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

<script type= "text/javascript">
$(document).ready(function(){

	
	var operForm = $("#operForm");

	$("button[data-oper='modify']").on("click",function(e){
		operForm.attr("action","/board/modify").submit();
		<%System.out.println("왜");%>
		
	});
	
	$("button[data-oper = 'list']").on("click",function(e){
		operForm.find("#bno").remove();

		operForm.attr("action","/board/list");
		operForm.submit();
	});
	
});

</script>