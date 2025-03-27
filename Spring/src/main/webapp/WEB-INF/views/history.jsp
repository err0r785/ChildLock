<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="kr.spring.entity.History"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.contextPath}/css/board.css"
	rel="stylesheet" type="text/css">
<style>
@charset "UTF-8";

.board {
	width: 100%;
	margin: 0 auto;
	padding: 20px;
	text-align: center;
	margin-bottom: 20px;
}

.post-list {
	border-collapse: collapse;
	width: 50%;
	border: 1px solid #ddd;
	margin: 100px auto 40px;
}

.post-list th, .post-list td {
	border: 1px solid #ddd;
	padding: 8px;
	text-align: center;
}

.post-list th {
	background-color: #f2f2f2;
}

.page-nav {
	text-align: center;
}

.page-nav a {
	display: inline-block;
	margin: 0 5px;
	padding: 5px 10px;
	text-decoration: none;
	border: 1px solid #ddd;
	border-radius: 5px;
	color: #333;
}

.title {
	position: absolute;
	left: 50%;
	transform: translateX(-50%);
}

</style>
</head>
<body>
	<%
	ArrayList<History> list = (ArrayList<History>) request.getAttribute("history");
	if (list == null) {
		list = new ArrayList<>(); // Null 방지
	}
	%>

	<div class="board" align="center">
		<h1 class="title">웹사이트 접속 기록</h1>
		<table class="post-list" align="center">
			<thead>
				<tr>
					<th width="150">접속 시간</th>
					<th width="400">URL 주소</th>
					<th width="50"></th>
				</tr>
			</thead>
			<tbody>
				<%
				for (History H : list) {
				%>
				<form action="/childlock/block/parentBlock" method="post">
					<tr>
						<td><%=H.getCreatedAt()%></td>
						<td><a href="<%=H.getHisUrl()%>" target="_blank"
							title="<%=H.getTitle()%>"> <%=H.getShortUrl()%>
						</a></td>						
						<input type="hidden" name="pbUrl" value="<%=H.getHisUrl()%>">
						<input type="hidden" name="userEmail"
							value="<%=request.getParameter("userEmail")%>">
						<td>
							<button>
								<strong>차단</strong>
							</button>
						</td>
					</tr>
				</form>
				<%
				}
				%>
			</tbody>
		</table>
		</div>
		<div class="page-nav">
			<a href="#" class="prev">이전</a> <a href="#" class="page">1</a> <a
				href="#" class="page">2</a> <a href="#" class="page">3</a> <a
				href="#" class="page">4</a> <a href="#" class="page">5</a> <a
				href="#" class="next">다음</a>
		</div>
	<script>
		function openBlockPopup(url) {
			window.open(
					'/차단팝업창/차단팝업창.html?blockUrl=' + encodeURIComponent(url),
					'_blank', 'width=500,height=400');
		}
	</script>
</body>
</html>