// content.js

// 링크에 마우스 오버 이벤트
document.addEventListener("mouseover", (event) => {
  let target = event.target;
  // 타겟 또는 부모 요소 중 <a> 태그 찾기
  while (target && target !== document.body) {
    if (target.tagName && target.tagName.toLowerCase() === "a") {
      break;
    }
    target = target.parentElement;
  }
  
  if (target && target.tagName && target.tagName.toLowerCase() === "a") {
    const linkUrl = target.href;
    if (!linkUrl) return;
    
    // 이미 타이머가 설정되어 있다면 재설정하지 않음
    if (target.dataset.hoverTimer) return;
    
    // 현재 마우스 좌표를 기록
    const pos = { x: event.pageX, y: event.pageY };
    
    // 3초 후에 분석 요청을 실행하는 타이머 설정
    const timerId = setTimeout(() => {
      chrome.runtime.sendMessage({ action: "analyzeLink", url: linkUrl }, (response) => {
        if (chrome.runtime.lastError) {
          console.error(chrome.runtime.lastError.message);
          return;
        }
        if (response && response.result) {
          showOverlay(pos, response.result, response.url, response.score);
        }
      });
      // 타이머 실행 후 데이터 삭제
      delete target.dataset.hoverTimer;
    }, 200);
    
    // 타이머 ID를 저장
    target.dataset.hoverTimer = timerId;
    
    // 마우스가 링크를 벗어나면 타이머 취소
    target.addEventListener("mouseout", function clearTimer() {
      if (target.dataset.hoverTimer) {
        clearTimeout(target.dataset.hoverTimer);
        delete target.dataset.hoverTimer;
      }
      target.removeEventListener("mouseout", clearTimer);
    });
  }
});

// 마우스 오버할 때 출력할 화면 호출
// 오버레이를 생성 및 표시하는 함수
function showOverlay(pos, result, url, score) {
  let overlay = document.getElementById("custom-overlay");
  if (!overlay) {
    overlay = document.createElement("div");
    overlay.id = "custom-overlay";
    overlay.style.position = "absolute";
    overlay.style.zIndex = "10000";
    overlay.style.width = "350px";    // 필요에 따라 조정
    overlay.style.height = "330px";   // 필요에 따라 조정
    overlay.style.border = "1px solid #ccc";
    overlay.style.backgroundColor = "#fff";
    overlay.style.boxShadow = "0 2px 8px rgba(0,0,0,0.2)";
    document.body.appendChild(overlay);
  }
  
  overlay.style.left = pos.x + "px";
  overlay.style.top = pos.y + "px";
  overlay.innerHTML = ""; // 기존 내용 초기화
  
  const iframe = document.createElement("iframe");
  iframe.style.width = "100%";
  iframe.style.height = "100%";
  iframe.style.border = "none";

  // 페이지 호출
  // JSP 페이지(test.jsp)를 로드하며, 분석 결과를 쿼리 파라미터로 전달
  iframe.src = "http://localhost:8081/childlock/over-page?result=" 
    + encodeURIComponent(result) + "&url=" + encodeURIComponent(url)+ "&score=" + encodeURIComponent(score);

  overlay.appendChild(iframe);
  
  overlay.style.display = "block";
  
  // 오버레이 영역에서 마우스가 벗어나면 숨김 처리
  overlay.addEventListener("mouseleave", function hide() {
    overlay.style.display = "none";
    overlay.removeEventListener("mouseleave", hide);
  });
}

document.addEventListener("click", (e) => {
  const anchor = e.target.closest("a");
  if (!anchor || !anchor.href) return;

  const isNewTab = anchor.target === "_blank" || e.ctrlKey || e.metaKey;

  e.preventDefault(); // 기본 이동 방지

  chrome.runtime.sendMessage({ action: "click", url: anchor.href }, (response) => {
    if (chrome.runtime.lastError) {
      console.error(chrome.runtime.lastError.message);
      if (isNewTab) {
        window.open(anchor.href, "_blank");
      } else {
        window.location.href = anchor.href;
      }
      return;
    }

    if (response && response.action === "redirect") {
      if (isNewTab) {
        window.open(response.targetUrl, "_blank");
      } else {
        window.location.href = response.targetUrl;
      }
    } else if (response && response.action === "warning") {
      const warningUrl = chrome.runtime.getURL("warning.html") + "?targetUrl=" + encodeURIComponent(anchor.href);
      if (isNewTab) {
        window.open(warningUrl, "_blank");
      } else {
        window.location.href = warningUrl;
      }
    } else if (response && response.action === "block") {
      const blockUrl = chrome.runtime.getURL("block.html");
      if (isNewTab) {
        window.open(blockUrl, "_blank");
      } else {
        window.location.href = blockUrl;
      }
    } else {
      if (isNewTab) {
        window.open(anchor.href, "_blank");
      } else {
        window.location.href = anchor.href;
      }
    }
  });
}, true);
