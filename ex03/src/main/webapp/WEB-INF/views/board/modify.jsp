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
				<form role="form" action="/board/modify" method="post">
					<!-- pagination추가 -->
					<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum }"/>'>
					<input type='hidden' name='amount' value='<c:out value="${cri.amount }"/>'>		
				  	<input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>				
					<input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>					
					<!-- csrf토큰추가 -->
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				
				<div class= "form group">
				<label>Bno</label> <input class="form-control" name='bno'
				value = '<c:out value="${board.bno}"/>' readonly="readonly">
				</div>
				
				<div class= "form group">
				<label>Title</label> <input class="form-control" name='title'
				value = '<c:out value="${board.title}"/>' >
				</div>
				
				<div class= "form group">
					<label>Text area</label> 
					<textarea class="form-control" rows="3" name='content' ><c:out value="${board.content}"/>
					</textarea>
				</div>
				
				<div class= "form group">
				<label>Writer</label> <input class="form-control" name='writer'
				value = '<c:out value="${board.writer}"/>' readonly="readonly">
				</div>
				
				<div class= "form group">
				<label>Regdate Date</label>
				<input class="form-control" name='regDate'
				value='<fmt:formatDate pattern = "yyyy/MM/dd" value="${board.regdate }" />' readonly="readonly">
				</div>
				
				<div class= "form group">
				<label>Update Date</label>
				<input class="form-control" name='updateDate'
				value='<fmt:formatDate pattern = "yyyy/MM/dd" value="${board.updateDate }" />' readonly="readonly">
				</div>
				
				<sec:authentication property="principal" var="pinfo"/>
					<sec:authorize access="isAuthenticated()">
					<!-- 작성자와 현재 로그인한 사용자가 동일하다면 -->
					<c:if test="${pinfo.username eq board.writer}">
						
						<button type = "submit" data-oper='modify' class="btn btn-default" >Modify</button>
						<button type = "submit" data-oper='remove' class="btn btn-danger">Remove</button>
					</c:if>
				</sec:authorize>
				<button type = "submit" data-oper='list' class="btn btn-info">List</button>
			</form>
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Files</div>
			<div class="panel-body">
			<div class = "form-group uploadDiv">
				<input type="file" name='uploadFile' multiple="multiple">
			</div>
				<div class="uploadResult">
					<ul></ul>
				</div>
			</div>
		</div>
	</div>
</div>
<%@include file="../includes/footer.jsp"%>

<script type="text/javascript">
$(document).ready( function(){
	var formObj = $("form");
	
	$('button').on("click", function(e){
		e.preventDefault();
		
		var operation = $(this).data("oper");
		
		console.log(operation);
		
		if(operation==='remove'){
			formObj.attr("action","/board/remove");
		} else if(operation ==='list'){
			//move to list
			//self.location="/board/list";
			formObj.attr("action","/board/list").attr("method","get");
			
			var pageNumTag = $("input[name='pageNum']").clone();
			var amountTag = $("input[name='amount']").clone();
			var keywordTag = $("input[name='keyword']").clone();
			var typeTag = $("input[name='type']").clone();
			//form태그에서 필요한 내용 잠시 복사(clone)해서 보관해두고 모든 내용은 지운후 필요한 부분만추가
			
			formObj.empty();
			formObj.append(pageNumTag);
			formObj.append(amountTag);
			formObj.append(keywordTag);
			formObj.append(typeTag);			
		}else if(operation === 'modify'){
			console.log("submit clicked");
			var str="";
			$(".uploadResult ul li").each(function(i,obj){
				var jobj = $(obj);
				console.dir(jobj); // 객체확인할때는 log보단 dir
				str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
			});
			formObj.append(str).submit();
		}
		formObj.submit();
	});
});
</script>

<!-- 첨부파일 보여주기 -->

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
					str += "<div><span>"+attach.fileName+"</span>";
					// 삭제버튼
					str += "<button type ='button' data-file=\'"+fileCallPath+"\' data-type='image' ";
					str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button></br>";
					str += "<img src='/display?fileName="+fileCallPath+"'>";
					str += "</div></li>";
				}else{// 파일타입
					str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'> </div>";
					str += "<span> "+attach.fileName+"</span><br/>"
					// 삭제버튼
					str += "<button type ='button' data-file=\'"+fileCallPath+"\' data-type='file' ";
					str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button></br>";
					str += "<img src='/resources/img/attach.png'>";
					str += "</div></li>";
				}
			});
			
			$(".uploadResult ul").html(str);
		});//end getjson
		
	})();//end function(즉시실행 함수)
	
	//첨부파일 클릭시 삭제
	$(".uploadResult").on("click","button",function(e){
		console.log("delete file");
		
		if(confirm("Remove this file? ")){
			var targetLi = $(this).closest("li");
			targetLi.remove();
		}

	});
	
	// 제출버튼 눌렀을때 첨부파일 처리도 같이한다.
	// 파일확장자를 제한하는 자바스크립트의 정규 표현식
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880;
	function checkExtension(fileName, fileSize){
		if(fileSize >= maxSize){
			alert("파일사이즈 초과");
			return false;
		}
		
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드할 수 없습니다");
			return false;
		}
		return true;
	}
	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	// 첨부파일 업로드는 <input type='file'>의 내용이 변경되는 것을 감지하여 처리
	$("input[type='file']").change(function(e){
		var formData = new FormData();
		var inputFile = $("input[name='uploadFile']");
		console.log(inputFile);//S.fn.init [input, prevObject: S.fn.init(1)]
		
		var files = inputFile[0].files;
		
		for(var i =0; i < files.length; i++){
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			formData.append("uploadFile",files[i]);
		}
		
		$.ajax({
			url : '/uploadAjaxAction', //Http요청 보낼 곳
			processData : false,
			contentType : false,
			data : formData,
			beforeSend : function(xhr){
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			type : 'POST',
			dataType : 'json', //서버에서 보내줄 데이터타입
			success : function(result){
				console.log(result);
				showUploadResult(result); //업로드 결과처리함수
			}
		}); // $.ajax
	});//"input[type='file']".change
	
	//업로드 결과처리함수
	function showUploadResult(uploadResultArr){
		if(!uploadResultArr || uploadResultArr.length == 0) return;
		
		var uploadUL = $(".uploadResult ul");
		
		var str="";
		$(uploadResultArr).each(function(i, obj){
			//image type
			if(obj.image){
				var fileCallPath = encodeURIComponent( obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
				//첨부파일의 데이터베이스 처리를 위해서 data-uuid, data-filename, data-type을 추가
				str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'data-filename='"+obj.fileName+"'data-type='"+obj.image+"' >";
				str += "<div><span>"+obj.fileName+"</span>";
				//삭제
				str += "<button type ='button' data-file=\'"+fileCallPath+"\' data-type='image' ";
				str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button></br>";
				str += "<img src='/display?fileName="+fileCallPath+"'> </div></li>";
			}else{
				var fileCallPath = encodeURIComponent( obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
				//생성된 문자열이 '\'때문에 일반 문자열과 다르게 처리되므로 '/'로변환
				var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
				str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'data-filename='"+obj.fileName+"'data-type='"+obj.image+"' >";
				str += "<div><span> "+obj.fileName+"</span>";
				
				// 삭제
				str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' ";
				str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				
				str += "<img src='/resources/img/attach.png'></a>";
				str += "</div></li>";
			}
		});
		uploadUL.append(str);
	} 
	
});

</script>