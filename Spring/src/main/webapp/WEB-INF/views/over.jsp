<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
 <style>
/* From Uiverse.io by Yaya12085 */ 

/* 기본적으로 브라우저의 모든 여백 제거 */
html, body {
  margin: 0 !important;
  padding: 0 !important;
  width: 100% !important;
  height: 100% !important;
  overflow: hidden; /* 필요하면 추가 */
}

/* 모든 요소의 박스 크기 계산을 border-box로 변경 */
* {
  box-sizing: border-box;
}

/* 팝업창의 여백을 완전히 제거하고 화면 모서리에 붙이기 */
.card {
  overflow: hidden;
  position: fixed; /* ✅ 화면에 고정 */
  background-color: rgb(240, 240, 240); /* ✅ 배경색 유지 */  
  text-align: center;
  border-radius: 0; /* ✅ 둥근 모서리 제거 */
  max-width: 350px; /* ✅ 크기 유지 */
  box-shadow: none; /* ✅ 그림자 제거 */
  margin: 0px !important; /* ✅ 바깥 여백 제거 */
  padding: 0px !important; /* ✅ 내부 여백 제거 */
  width: 350px; /* ✅ 고정 너비 */
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%); /* 💡 정중앙으로 이동 */
}

.header {
  padding: 1.25rem 1rem 1rem 1rem;
  background-color: #ffffff;
}


/* 위험 페이지일 경우 --------------------------- */

.title1 {
  color: #eb0000;
  font-size: 1rem;
  font-weight: 600;
  line-height: 1.5rem;
}


.image1 {
  display: flex;
  margin-left: auto;
  margin-right: auto;
  background-color: #fee2e2;
  flex-shrink: 0;
  justify-content: center;
  align-items: center;
  width: 3rem;
  height: 3rem;
  border-radius: 9999px;
}

.image1 svg {
  color: #dc2626;
  width: 1.5rem;
  height: 1.5rem;
}


/* 안전한 페이지일 경우 --------------------------------- */

.title2 {
    color: #28a801;
    font-size: 1rem;
    font-weight: 600;
    line-height: 1.5rem;
}

.image2 {
display: flex;
margin-left: auto;
margin-right: auto;
background-color: #b0ecae;
flex-shrink: 0;
justify-content: center;
align-items: center;
width: 3rem;
height: 3rem;
border-radius: 9999px;
}

.image2 svg {
  color: #1d9100;
  width: 1.5rem;
  height: 1.5rem;
}

/* 주의가 필요할 경우 ------------------------------------ */

.title3 {
    color: #ff7b00;
    font-size: 1.2rem;
    font-weight: 600;
    line-height: 1.5rem;
}

.image3 {
display: flex;
margin-top: 5px;
margin-left: auto;
margin-right: auto;
background-color: #ffcc89;
flex-shrink: 0;
justify-content: center;
align-items: center;
width: 3rem;
height: 3rem;
border-radius: 50px;
}

.image3 svg {
  color: #e97100;
  width: 1.5rem;
  height: 1.5rem;
}

.content {
    margin-top: 1.3rem;
    text-align: center;
    }
        
.message {
  margin-top: 1.5rem;
  color: #3f3f3f;
  font-size: 0.875rem;
  line-height: 1.25rem;
}

.actions {
  margin: 0.75rem 1rem;
  display: flex;
  flex-direction: column; /* 세로로 정렬 */
  align-items: center;    /* 수평 가운데 정렬 */
  text-align: center;
}

.desactivate {
  display: inline-flex;
  padding: 0.5rem 1rem;
  background-color: #dc2626;
  color: #ffffff;
  font-size: 1rem;
  line-height: 1.5rem;
  font-weight: 500;
  justify-content: center;
  width: 100%;
  border-radius: 0.375rem;
  border-width: 1px;
  border-color: transparent;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
}

.cancel {
  display: inline-flex;
  margin-top: 1.5rem;
  padding: 0.5rem 1rem;
  background-color: #292929;
  color: #ffffff;
  font-size: 0.8rem;
  line-height: 1.5rem;
  font-weight: 500;
  justify-content: center;
  width: 100%;
  border-radius: 0.375rem;
  border: 1px solid #d1d5db;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
}

button {
  cursor: pointer;
}

.url{
    color: blue;
    margin-bottom: 10px;
  	font-size: 0.85rem;
 	word-break: break-all;
}


    </style>
</head>
<body>
<% 
String url = (String)request.getAttribute("url");
String result = (String) request.getAttribute("result");
Double score = (Double) request.getAttribute("score");

//도메인 + 경로 일부 추출
String shortUrl = "";
try {
 java.net.URL parsedUrl = new java.net.URL(url);
 shortUrl = parsedUrl.getHost() + parsedUrl.getPath();
 if (parsedUrl.getQuery() != null) {
     shortUrl += "?" + parsedUrl.getQuery();
 }
 if (shortUrl.length() > 30) {
     shortUrl = shortUrl.substring(0, 30) + "...";
 }
} catch (Exception e) {
 shortUrl = url.length() > 30 ? url.substring(0, 30) + "..." : url;
}
%>
<% if(result.equals("benign")){ %>
<!-- 안전한 페이지 일때 --------------------- -->
	<div class="card">
    <div class="header">
      <div class="image2">
        <svg
          aria-hidden="true"
          stroke="currentColor"
          stroke-width="1.5"
          viewBox="0 0 24 24"
          fill="none"
        >
          <path
            d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"
            stroke-linejoin="round"
            stroke-linecap="round"
          ></path>
        </svg>
      </div>
      <div class="content">
        <span class="title2">안전한 페이지로 확인됩니다.</span>
        <p class="message">
          이 사이트는 안전한 사이트로 확인 되었습니다.<br>안심하고 이용하셔도 괜찮습니다.
        </p>
      </div>
      <div class="actions">
  
          <span class="url" title="<%= url %>"><%= shortUrl %></span>

        <a href="<%= url%>" onclick="parent.location.href=this.href; return false;"><button class="cancel" type="button"> 접속하려는 페이지 이동</button></a>
      </div>
    </div>
  </div>
  
  <%} else if(score<=0.8){ %>
  
  <!-- 주의가 필요한 경우 ----------------------------- -->

	<div class="card">
    <div class="header">
      <div class="image3">
        <svg
          aria-hidden="true"
          stroke="currentColor"
          stroke-width="1.5"
          viewBox="0 0 24 24"
          fill="none"
        >
          <path
            d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"
            stroke-linejoin="round"
            stroke-linecap="round"
          ></path>
        </svg>
      </div>
      <div class="content">
        <span class="title3">주의가 필요한 페이지입니다.</span>
        <p class="message">
          의심스러운 요소가 포함될 가능성이 있습니다.<br>주의해서 이용해주세요.
        </p>
      </div>
      <div class="actions">
  
          <span class="url" title="<%= url %>"><%= shortUrl %></span>

        <a href="<%= url%>" onclick="parent.location.href=this.href; return false;"><button class="cancel" type="button">무시하고 페이지 이동</button></a>
      </div>
    </div>
  </div>
  <%} else if(score>0.8) { %>
    <!-- 위험한 페이지 일때 --------------------------- -->
	    <div class="card">
	  <div class="header">
	    <div class="image1">
	      <svg
	        aria-hidden="true"
	        stroke="currentColor"
	        stroke-width="1.5"
	        viewBox="0 0 24 24"
	        fill="none"
	      >
	        <path
	          d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"
	          stroke-linejoin="round"
	          stroke-linecap="round"
	        ></path>
	      </svg>
	    </div>
	    <div class="content">
	      <span class="title1">위험이 의심되는 페이지입니다.</span>
	      <p class="message">
	        컴퓨터에 해를 끼치거나 개인 데이터를 악용할 수 있으므로 이 웹사이트를 열지 않는 것이 좋습니다.
	      </p>
	    </div>
	    <div class="actions">
	
	        <span class="url" title="<%= url %>"><%= shortUrl %></span>

	      <a href="<%= url%>" onclick="parent.location.href=this.href; return false;"><button class="cancel" type="button">무시하고 페이지 이동</button></a>
	    </div>
	  </div>
	</div>
	<%} else{%>
		<div class="card">
    <div class="header">
      <div class="image2">
        <svg
          aria-hidden="true"
          stroke="currentColor"
          stroke-width="1.5"
          viewBox="0 0 24 24"
          fill="none"
        >
          <path
            d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"
            stroke-linejoin="round"
            stroke-linecap="round"
          ></path>
        </svg>
      </div>
      <div class="content">
        <span class="title2">안전한 페이지로 확인됩니다.</span>
        <p class="message">
          이 사이트는 안전한 사이트로 확인 되었습니다.<br>안심하고 이용하셔도 괜찮습니다.
        </p>
      </div>
      <div class="actions">
  
          <span class="url" title="<%= url %>"><%= shortUrl %></span>

        <a href="<%= url%>" onclick="parent.location.href=this.href; return false;"><button class="cancel" type="button"> 접속하려는 페이지 이동</button></a>
      </div>
    </div>
  </div>
  
	<%} %>

</body>
</html>