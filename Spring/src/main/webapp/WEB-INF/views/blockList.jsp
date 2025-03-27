<%@page import="kr.spring.entity.ParentBlockInfo"%>
<%@page import="kr.spring.entity.SelfBlockInfo"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.board {
	width: 100%;
	margin: 0 auto;
	padding: 20px;
	text-align: center;
	margin-bottom: 20px;
	margin-left: -20px;
}

.post-list {
	margin-top: 40px;
	border-collapse: collapse;
	width: 60%;
	border: 1px solid #ddd;
	margin-bottom: 40px;
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

.container {
	display: flex;
	justify-content: center; /* ✅ 가로 방향 가운데 정렬 */
	align-items: center; /* ✅ 세로 방향 가운데 정렬 */
	background-color: #dadada;
	height: 100px;
	width: 80%;
	margin: 0 auto;
}

.input {
	width: 30%;
	max-width: 1500px;
	padding: 15px;
	font-size: 17px;
	color: black;
	border-top-left-radius: .5em;
	border-bottom-left-radius: .5em;
	border: 2px solid #dddddd;
	margin-right: -10px;
	height: 10px;
}

.button {
	border: 1px solid #dddddd;
	background-color: #206ee4;
	text-decoration: none;
	padding: 11px;
	padding-bottom: 30px;
	font-size: 17px;
	color: #fff;
	border-radius: .5em;
	cursor: pointer;
	height: 44px;
}

.button:hover {
	background-color: #0026ff;
}

.title {
	margin-left: -850px;
}

/* ✅ 탭 스타일 */
.tab-container {
	display: flex;
	justify-content: center;
	border-bottom: 2px solid #ddd;
	margin-bottom: 20px;
	margin-top: 100px;
}

.tab {
	padding: 10px 20px;
	cursor: pointer;
	font-size: 16px;
	font-weight: bold;
	border: 1px solid #ddd;
	border-bottom: none;
	background: #f5f5f5;
	transition: background 0.3s ease;
}

.tab.active {
	background: white;
	color: #002ab3; /* 활성화된 탭 강조 */
	border-top: 5px solid #000000;
}

/* ✅ 콘텐츠 스타일 */
.tab-content {
	display: none;
	padding: 20px;
	border: 1px solid #ddd;
	background: white;
}

.tab-content.active {
	display: block;
}
</style>
</head>
<body>

<%
	ArrayList<SelfBlockInfo> selfList = (ArrayList<SelfBlockInfo>) request.getAttribute("selfList");
    ArrayList<ParentBlockInfo> parentList = (ArrayList<ParentBlockInfo>) request.getAttribute("parentList");
    if (selfList == null) {
    	selfList = new ArrayList<>(); // Null 방지
    }
    if (parentList == null) {
    	parentList = new ArrayList<>(); // Null 방지
    }
%>

	<!-- ✅ 탭 버튼 -->
	<div class="tab-container">
		<div class="tab active" onclick="openTab('board')">자녀의 차단 리스트</div>
		<div class="tab" onclick="openTab('board1')">나의 차단 리스트</div>
	</div>

	<!-- ✅ 탭 내용 -->
	<div id="board" class="tab-content active">

	<form action="parentBlock" method="post">
		<div class="container">
			<input placeholder="차단하려는 URL을 입력하세요." class="input" name="pbUrl"
				type="text">
			<input type="hidden" value="<%= request.getParameter("userEmail") %>" name="userEmail">
			<button class="button">Search</button>
		</div>
	</form>

		<div class="board" align="center">
			<h1 class="title">차단 리스트 목록</h1>
			<table class="post-list" align="center">
				<thead>
					<tr>
						<th width="50">차단 시간</th>
						<th width="200">URL 주소</th>						
						<th width="20"></th>
					</tr>
				</thead>
				<tbody>
					<%for(ParentBlockInfo p : parentList){ %>
					<form action="deleteparentBlock" method="post">
						<tr>
							<td><%= p.getCreatedAt() %></td>
							<td><%= p.getPbUrl() %></td>
							<input type="hidden" name="pbUrl" value="<%= p.getPbUrl() %>">
							<input type="hidden" name="userEmail" value="<%= request.getParameter("userEmail") %>">
							<td><button onclick="location.href='/해제팝업창/차단팝업창.html'">
									<strong>해제</strong>
								</button></td>
						</tr>
					</form>
					<%} %>
				</tbody>
			</table>
			<div class="page-nav">
				<a href="#" class="prev">이전</a> <a href="#" class="page">1</a> <a
					href="#" class="page">2</a> <a href="#" class="page">3</a> <a
					href="#" class="page">4</a> <a href="#" class="page">5</a> <a
					href="#" class="next">다음</a>
			</div>
		</div>
	</div>

	<div id="board1" class="tab-content">

	<form action="selfBlock" method="post">
		<div class="container">
			<input placeholder="차단하려는 URL을 입력하세요." class="input" name="sbUrl"
				type="text">
			<input type="hidden" value="<%= request.getParameter("userEmail") %>" name="userEmail">
			<button class="button">Search</button>
		</div>
	</form>
		<div class="board" align="center">
			<h1 class="title">차단 리스트 목록</h1>
			<table class="post-list" align="center">
				<thead>
					<tr>
						<th width="50">접속 시간</th>
						<th width="200">URL 주소</th>
						<th width="20"></th>
					</tr>
				</thead>
				<tbody>
					<%for(SelfBlockInfo s : selfList){ %>
					<form action="deleteselfBlock" method="post">
						<tr>
							<td><%= s.getCreatedAt() %></td>
							<td><%= s.getSbUrl() %></td>
							<input type="hidden" name="sbUrl" value="<%= s.getSbUrl() %>">
							<input type="hidden" name="userEmail" value="<%= request.getParameter("userEmail") %>">
							<td><button onclick="location.href='/해제팝업창/차단팝업창.html'">
									<strong>해제</strong>
								</button></td>
						</tr>
					</form>
					<%} %>
				</tbody>
			</table>
			<div class="page-nav">
				<a href="#" class="prev">이전</a> <a href="#" class="page">1</a> <a
					href="#" class="page">2</a> <a href="#" class="page">3</a> <a
					href="#" class="page">4</a> <a href="#" class="page">5</a> <a
					href="#" class="next">다음</a>
			</div>
		</div>
	</div>

	<script>
		function openTab(tabId) {
			// 모든 탭 콘텐츠 숨기기
			var contents = document.querySelectorAll(".tab-content");
			contents.forEach(function(content) {
				content.classList.remove("active");
			});

			// 모든 탭 버튼 비활성화
			var tabs = document.querySelectorAll(".tab");
			tabs.forEach(function(tab) {
				tab.classList.remove("active");
			});

			// 선택한 탭 콘텐츠 보이기
			document.getElementById(tabId).classList.add("active");

			// 선택한 탭 버튼 활성화
			event.currentTarget.classList.add("active");
		}
	</script>

</body>
</html>

