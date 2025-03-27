document.addEventListener("DOMContentLoaded", () => {
    const loginBtn = document.getElementById("loginBtn");
    const userInfo = document.getElementById("userInfo");
    const logoutBtn = document.getElementById("logoutBtn");
    const load = document.getElementById("load");

    
    // ✅ 로그인 버튼 클릭 이벤트
    if (loginBtn) {
        loginBtn.addEventListener("click", () => {
            chrome.identity.getAuthToken({ interactive: true }, function (token) {
                if (chrome.runtime.lastError) {
                    console.error("🚨 인증 오류:", chrome.runtime.lastError);
                    return;
                }

                fetch('https://www.googleapis.com/oauth2/v2/userinfo', {
                    headers: { Authorization: `Bearer ${token}` }
                })
                .then(response => response.json())
                .then(user => {
                    console.log("✅ 로그인 성공:", user);
                    chrome.storage.local.set({ userEmail: user.email, userName: user.name }, () => {
                        console.log("📌 사용자 이메일 저장:", user.email);
                        userInfo.textContent = `로그인됨: ${user.email}`;
                        loginBtn.style.display = "none";  // 로그인 버튼 숨기기
                        logoutBtn.style.display = "block"; // 로그아웃 버튼 보이기
                        chrome.storage.local.get("userEmail", (data) => {
                            if (data.userEmail) {
                                console.log(`ㄴㄴㄴㄴㄴ: ${data.userEmail}`);
                            } else {
                                console.log("안됨");
                            }
                        });
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
                        .then(() => console.log("✅ 사용자 정보 서버 저장 완료"))
                        .catch(error => console.error("🚨 서버 저장 오류:", error));
                    });
                })
                .catch(error => console.error("🚨 로그인 오류:", error));
            });
        });
    }

    // ✅ 로그아웃 버튼 클릭 이벤트 (수정된 부분)
    if (logoutBtn) {
        logoutBtn.addEventListener("click", () => {
            chrome.identity.getAuthToken({ interactive: false }, function (token) {
                if (!chrome.runtime.lastError && token) {
                    // ✅ Google OAuth 토큰 삭제
                    chrome.identity.removeCachedAuthToken({ token: token }, function () {
                        console.log("✅ Google OAuth 토큰 삭제 완료!");
                    });
                }

                // ✅ Chrome 저장소에서 사용자 정보 삭제
                chrome.storage.local.remove(["userEmail", "userName"], () => {
                    // chrome.storage.local.remove("usreName",()=>{});
                    console.log("✅ userEmail 삭제 완료!");
                    userInfo.textContent = "로그아웃됨";
                    loginBtn.style.display = "block";  // 로그인 버튼 다시 표시
                    logoutBtn.style.display = "none"; // 로그아웃 버튼 숨기기
                });
            });
        });
    }

    // ✅ 기존 로그인 정보 불러오기
    chrome.storage.local.get("userEmail", (data) => {
        if (data.userEmail) {
            console.log(`dddd: ${data.userEmail}`);
            userInfo.textContent = `로그인됨: ${data.userEmail}`;
            loginBtn.style.display = "none";   // 로그인 버튼 숨기기
            logoutBtn.style.display = "block"; // 로그아웃 버튼 보이기
        } else {
            logoutBtn.style.display = "none";  // 로그인 정보가 없으면 로그아웃 버튼 숨기기
        }
    });

    // 개인 차단 페이지 저장
    if(load){
        load.addEventListener("click", () => {
        chrome.storage.local.get("userEmail", (data) => {
            fetch("http://localhost:8081/childlock/userinfo/save", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    userEmail: user.email,
                    userName: user.name,
                    parentEmail: null // 기본값 null 설정
                })
            })
    })})};

    // 페이지 로딩 시 저장된 userEmail 값을 숨겨진 input에 넣기
    chrome.storage.local.get("userEmail", (data) => {
        if (data.userEmail) {
        document.getElementById("userEmailInput").value = data.userEmail;
        }
    });
    
    // spring boot에 self_block insert
    document.getElementById("blockForm").addEventListener("submit", (e) => {
        e.preventDefault();
        // 폼 데이터를 JSON 객체로 변환
        const formData = new FormData(e.target);
        const jsonData = {};
        formData.forEach((value, key) => {
            jsonData[key] = value;
        });
        
        // sbUrl에서 도메인만 추출하여 업데이트
        try {
            const parsedUrl = new URL(jsonData["sbUrl"]);
            jsonData["sbUrl"] = parsedUrl.hostname;
        } catch (error) {
            console.error("유효하지 않은 URL입니다:", error);
            // 필요한 경우, 여기서 에러 처리 (예: 사용자에게 경고)
            return;
        }
        
        fetch("http://localhost:8081/childlock/block/saveBlock", {
            method: "POST",
            headers: {
            "Content-Type": "application/json"
            },
            body: JSON.stringify(jsonData)
        })
        .then(response => {
            if (!response.ok) {
            throw new Error("네트워크 응답이 정상이 아닙니다.");
            }
            return response.json();
        })
        .then(data => {
            console.log("서버 응답:", data);
        })
        .catch(error => {
            console.error("POST 요청 에러:", error);
        });
    });
    

});
