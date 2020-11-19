<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
</head>
<body>
<h1>
	Hello world!  
</h1>

<P>  The time on the server is ${serverTime}. </P>
<!-- 로그인후에 /board/list로 가게한다. -->
<script type="text/javascript">
	self.location="/board/list";
</script>
</body>
</html>
