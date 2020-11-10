<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Register</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

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
	width:200px;
}

.uploadResult ul li span{
	color : white;
}

</style>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Register</div>
			<!-- /.panel-heading -->
			<div class="panel-body">

				<form role="form" action="/board/register" method="post">
					<div class="form-group">
						<label>Title</label> <input class="form-control" name='title'>
					</div>

					<div class="form-group">
						<label>Text area</label>
						<textarea class="form-control" rows="3" name='content'></textarea>
					</div>

					<div class="form-group">
						<label>Writer</label> <input class="form-control" name='writer'></input>
					</div>

					<button type="submit" class="btn btn-default">submit button</button>
					<button type="reset" class="btn btn-default">Reset Button</button>
				</form>
			</div>
		</div>
	</div>
</div>

<!-- 첨부파일 -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">File Attach</div>
			<!-- /.pannel-heading -->
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name ='uploadFile' multiple>
				</div>
				
				<div class='uploadResult'>
				<ul></ul>
				</div>
			</div>
			<!--  end panel-body -->
		</div>
		<!-- end panel -->
	</div>
	<!-- end col -->
</div>
<!-- end row -->

<script>
$(document).ready(function(e){
	var formObj = $("form[role='form']");
	$("button[type='submit']").on("click",function(e){
		e.preventDefault();
		console.log("submit clicked");
		
		//BoardVO에서는 attachList라는 이름의 변수로 첨부파일의 정보를 수집하기 때문에
		//<input type="hidden">의 name은 'attachList[인덱스번호]'와 같은 이름을 사용하도록 한다
		var str = "";
		$(".uploadResult ul li").each(function(i,obj){
			var jobj = $(obj);
			console.dir(jobj); // 객체확인할때는 log보단 dir
			str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
			str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
			str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
			str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
		});
		formObj.append(str).submit();
	});//$("button") onclick
	
	//제출버튼 눌렀을때 첨부파일 처리도 같이한다.
	//파일확장자를 제한하는 자바스크립트의 정규 표현식
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
			type : 'POST',
			dataType : 'json', //서버에서 보내줄 데이터타입
			success : function(result){
				console.log(result);
				showUploadResult(result); //업로드 결과처리함수
			}
		}); // $.ajax
	});//"input[type='file']".change
	
	
	// 파일 삭제
	$(".uploadResult").on("click","button",function(e){
		console.log("delete file");
		
		var targetFile = $(this).data("file"); //data-file=fileCallPath
		var type = $(this).data("type"); // data-type='image'/'file'
		
		var targetLi = $(this).closest("li");
		
		$.ajax({
			url : '/deleteFile',
			data: {fileName : targetFile, type : type},
			dataType:'text',
			type:'POST',
			success : function(result){
				alert(result);
				targetLi.remove();
			}
		}); //$.ajax
	}); //$(".uploadResult").on("click")
	
});//doc.ready
</script>

<%@include file="../includes/footer.jsp" %>
