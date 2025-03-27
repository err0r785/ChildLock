chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === "analyzeLink") {
    const linkUrl = message.url;
    const params = new URLSearchParams();
    params.append("url", linkUrl);
    params.append("domain", extractDomain(linkUrl))

    fetch('http://localhost:8081/childlock/analyze', {
      method: 'POST',
      mode: 'cors',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: params.toString()
    })
      .then(response => response.text())
      .then(text => {
        console.log('Server response:', text);
        let data;
        try {
          data = JSON.parse(text);
        } catch (e) {
          console.error('JSON 파싱 실패:', e);
          sendResponse({ result: null });
          return;
        }
        sendResponse({ result: data.result,
          url: data.url,
          score: data.score,
          domain: extractDomain(data.url)
        });
      })
      .catch(error => {
        console.error('Fetch 에러:', error);
        sendResponse({ result: null });
      });
    // 비동기 응답을 위해 true를 반환
    return true;
  }

  if(message.action === "click"){
    chrome.storage.local.get("userEmail", (data) => {
      const payload = {
        url: message.url,
        domain: extractDomain(message.url),
        userEmail: data.userEmail || ""
      };

      fetch("http://localhost:5000/click/predict", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload)
      })
        .then((res) => res.json())
        .then((data) => {
          if (data.aaa && data.aaa[0] === "benign") {
            sendResponse({ action: "redirect", targetUrl: message.url });
          } else if (data.aaa && data.aaa[0] === "block") {
            sendResponse({ action: "block" });
          } else {
            sendResponse({ action: "warning" });
          }
        })
        .catch((error) => {
          console.error("Error in URL classification:", error);
          sendResponse({ action: "redirect", targetUrl: message.url });
        });
    });
    return true;
  }
});


// 🔹 새 탭에서 열리는 경우 감지하여 차단
chrome.webNavigation.onCreatedNavigationTarget.addListener((details) => {
  chrome.storage.local.get("userEmail", (data) => {
    if (!data.userEmail) return;

    const payload = {
      url: details.url,
      domain: extractDomain(details.url),
      userEmail: data.userEmail
    };

    fetch("http://localhost:5000/click/predict", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    })
      .then((res) => res.json())
      .then((data) => {
        if (data.aaa && data.aaa[0] === "block") {
          console.log("🚨 차단된 사이트:", details.url);
          chrome.tabs.update(details.tabId, { url: chrome.runtime.getURL("block.html") });
        } else if (data.aaa && data.aaa[0] === "warning") {
          console.log("⚠️ 경고 사이트:", details.url);
          chrome.tabs.update(details.tabId, { url: chrome.runtime.getURL("warning.html") + "?targetUrl=" + encodeURIComponent(details.url) });
        }
      })
      .catch((error) => {
        console.error("🚨 URL 분석 오류:", error);
      });
  });
});




// Google 로그인 요청 처리
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === "login") {
      chrome.identity.getAuthToken({ interactive: true }, function(token) {
          if (chrome.runtime.lastError) {
              console.error("🚨 인증 오류:", chrome.runtime.lastError);
              sendResponse({ success: false, error: chrome.runtime.lastError.message });
              return;
          }

          // ✅ Google API에서 사용자 정보 가져오기
          fetch('https://www.googleapis.com/oauth2/v2/userinfo', {
              headers: { Authorization: `Bearer ${token}` }
          })
          .then(response => response.json())
          .then(user => {
              console.log("✅ 로그인 성공:", user);

              // ✅ 사용자 정보를 Chrome Local Storage에 저장
              chrome.storage.local.set({ userEmail: user.email, userName: user.name }, () => {
                  console.log("📌 사용자 이메일 저장:", user.email);

                  // ✅ Spring Boot 서버로 사용자 정보 전송 (POST 요청)
                  fetch("http://localhost:8081/childlock/userinfo/save", {
                      method: "POST",
                      headers: { "Content-Type": "application/json" },
                      body: JSON.stringify({
                          userEmail: user.email,
                          userName: user.name,
                          parentEmail: null // 기본값 null 설정
                      })
                  })
                  .then(res => res.json())
                  .then(data => {
                      console.log("✅ 서버 응답:", data);
                      sendResponse({ success: true, email: user.email });
                  })
                  .catch(error => {
                      console.error("🚨 서버 전송 오류:", error);
                      sendResponse({ success: false, error: error.message });
                  });
              });
          })
          .catch(error => {
              console.error("🚨 로그인 오류:", error);
              sendResponse({ success: false, error: error.message });
          });

          return true; // 비동기 응답을 위해 true 반환
      });

      return true; // 비동기 응답을 위해 true 반환
  }
});


// 🔥 로그아웃 처리
function handleLogout() {
  console.log("✅ 로그아웃 진행 중...");
  chrome.storage.local.set({ isLoggedIn: false }, () => {
    console.log("✅ 로그아웃 완료 (이메일 & 이름 유지)");
  });
}

// 🔥 아이콘 변경 함수
function updateIcon(state) {
  let iconPath = {
      "16": chrome.runtime.getURL(`${state}.png`),
      "48": chrome.runtime.getURL(`${state}.png`),
      "128": chrome.runtime.getURL(`${state}.png`)
  };

  chrome.action.setIcon({ path: iconPath }, () => {
      if (chrome.runtime.lastError) {
          console.error("🚨 아이콘 변경 오류:", chrome.runtime.lastError.message);
      } else {
          console.log(`✅ 아이콘 변경 완료: ${state}.png`);
      }
  });
}

chrome.webNavigation.onCommitted.addListener((details) => {
  if (details.frameId === 0) {  // 메인 프레임만 감지
    chrome.tabs.get(details.tabId, (tab) => {
      if (!tab || !tab.url) return;

      console.log("🔎 현재 열린 URL:", tab.url);
      let blockUrl = chrome.runtime.getURL("block.html");
      let warningUrl = chrome.runtime.getURL("warning.html");

      if (tab.url === blockUrl) {
        console.log("🚨 차단 페이지 감지! 아이콘을 qqq3.png로 변경");
        updateIcon("qqq3"); // 🚨 block.html 입장 → 빨간색 아이콘 변경
        chrome.notifications.create({
          type: "basic",
          iconUrl: chrome.runtime.getURL("red.png"),
          title: "차단된 페이지",
          message: "접속하려는 사이트는 차단되었습니다.",
          priority: 2
        });
      } else if (tab.url.includes("warning.html")) {
        // 🔥 정확한 일치 대신 '포함'으로 수정
        console.log("⚠️ 경고 페이지 감지! 아이콘을 qqq4.png로 변경");
        updateIcon("qqq4");
        chrome.notifications.create({
          type: "basic",
          iconUrl: chrome.runtime.getURL("yel.png"),
          title: "위험한 페이지",
          message: "이 사이트는 보안상 위험할 수 있습니다.",
          priority: 1
        });
      } else {
        console.log("✅ 일반 사이트 감지! 아이콘을 qqq1.png로 변경");
        updateIcon("qqq1"); // ✅ 정상 사이트 → 기본 아이콘 변경
      }
    });
  }
});

function extractDomain(url) {
  try {
    const parsedUrl = new URL(url);
    return parsedUrl.hostname;
  } catch (e) {
    console.error("유효하지 않은 URL:", url);
    return null;
  }
}

chrome.webNavigation.onCommitted.addListener((details) => {
  if (details.frameId === 0) {  // 메인 프레임만 감지
      chrome.tabs.get(details.tabId, (tab) => {
          if (tab) {
              chrome.storage.local.get("userEmail", (data) => {
                  if (!data.userEmail) return; // 로그인하지 않았다면 저장 X

                  const historyData = {
                      userEmail: data.userEmail,  // 🔹 로그인한 사용자 이메일 추가
                      hisUrl: tab.url,
                      title: tab.title || tab.url,
                      timestamp: new Date().toISOString()
                  };

                  fetch('http://localhost:8081/childlock/userinfo/history', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(historyData)
                  })
                  .then(async (response) => {
                    const text = await response.text();
                    try {
                      const json = JSON.parse(text);
                      console.log("✅ 검색 기록 저장 성공:", json);
                    } catch (e) {
                      console.warn("⚠️ 응답이 JSON이 아님 또는 비어 있음:", text);
                    }
                  })
                  .catch(error => console.error("🚨 검색 기록 저장 오류:", error));
                  
              });
          }
      });
  }
}, { url: [{ schemes: ["http", "https"] }] });
