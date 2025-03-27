document.addEventListener("DOMContentLoaded", () => {
    const loginBtn = document.getElementById("loginBtn");
    const userEmail = document.getElementById("userEmail");
    const username = document.getElementById("username");
    const profileImage = document.getElementById("profileImage");
  
    if (loginBtn) {
      loginBtn.addEventListener("click", () => {
        chrome.storage.local.get("userEmail", (data) => {
          if (data.userEmail) {
            // 로그아웃
            chrome.identity.getAuthToken({ interactive: false }, (token) => {
              if (token) {
                chrome.identity.removeCachedAuthToken({ token }, () => {
                  console.log("✅ 토큰 삭제 완료");
                });
              }
  
              chrome.storage.local.remove(["userEmail", "userName", "userImage"], () => {
                userEmail.textContent = "로그아웃됨";
                username.textContent = "";
                profileImage.src = "https://www.w3schools.com/w3images/avatar2.png";
                loginBtn.textContent = "로그인";
              });
            });
          } else {
            // 로그인
            chrome.identity.getAuthToken({ interactive: true }, (token) => {
              if (chrome.runtime.lastError) {
                console.error("🚨 인증 오류:", chrome.runtime.lastError);
                return;
              }
  
              fetch("https://www.googleapis.com/oauth2/v2/userinfo", {
                headers: { Authorization: `Bearer ${token}` },
              })
                .then((res) => res.json())
                .then((user) => {
                  chrome.storage.local.set({
                    userEmail: user.email,
                    userName: user.name,
                    userImage: user.picture
                  }, () => {
                    userEmail.textContent = `로그인됨: ${user.email}`;
                    username.textContent = user.name;
                    profileImage.src = user.picture || "https://www.w3schools.com/w3images/avatar2.png";
                    loginBtn.textContent = "로그아웃";
  
                    // 서버 저장
                    fetch("http://localhost:8081/childlock/userinfo/save", {
                      method: "POST",
                      headers: { "Content-Type": "application/json" },
                      body: JSON.stringify({
                        userEmail: user.email,
                        userName: user.name,
                        parentEmail: null,
                      }),
                    });
                  });
                });
            });
          }
        });
      });
    }
  
    // 페이지 로드시 상태 복구
    chrome.storage.local.get(["userEmail", "userName", "userImage"], (data) => {
      if (data.userEmail) {
        userEmail.textContent = `로그인됨: ${data.userEmail}`;
        username.textContent = data.userName || "";
        profileImage.src = data.userImage || "https://www.w3schools.com/w3images/avatar2.png";
        loginBtn.textContent = "로그아웃";
      } else {
        loginBtn.textContent = "로그인";
      }
    });
  
    // 페이지 이동들
    document.getElementById("feedLink").addEventListener("click", () => {
      window.location.href = chrome.runtime.getURL("feedback.html");
    });
  
    document.getElementById("account_add").addEventListener("click", () => {
      window.location.href = "account.html";
    });
  
    document.getElementById("blockList").addEventListener("click", () => {
      chrome.storage.local.get("userEmail", (data) => {
        if (!data.userEmail) return;
        const url = `http://localhost:8081/childlock/block/blocklist?userEmail=${encodeURIComponent(data.userEmail)}`;
        chrome.tabs.update({ url });
      });
    });
  
    document.getElementById("history").addEventListener("click", () => {
      chrome.storage.local.get("userEmail", (data) => {
        if (!data.userEmail) return;
        const url = `http://localhost:8081/childlock/userinfo/history?userEmail=${encodeURIComponent(data.userEmail)}`;
        chrome.tabs.update({ url });
      });
    });
  });
  