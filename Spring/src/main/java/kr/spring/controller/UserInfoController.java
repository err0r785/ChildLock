package kr.spring.controller;

import kr.spring.entity.FeedbackInfo;
import kr.spring.entity.History;
import kr.spring.entity.UserInfo;
import kr.spring.service.UserInfoService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;

@Controller  // ✅ @Controller → @RestController 변경 (JSON 응답 가능)
@RequestMapping("/userinfo") // ✅ URL 기본 경로 지정
@CrossOrigin(origins = "*")
public class UserInfoController {

    @Autowired
    private UserInfoService userInfoService;

    private static final Logger logger = LoggerFactory.getLogger(WebBoardController.class);

    // 로그인 회원정보가 없을때 자동 회원가입
    @PostMapping("/save")
    public void saveUser(@RequestBody UserInfo userInfo) {
    	logger.info("로그인 성공");
        userInfoService.saveUserInfo(userInfo);
    }
    
    @PostMapping("/update")
    public ResponseEntity<String> updateUser(@RequestBody UserInfo userInfo) {
        logger.info("업데이트 요청: {}", userInfo);
        userInfoService.updateUser(userInfo);  // parentEmail 포함된 userInfo
        return ResponseEntity.ok("업데이트 완료");
    }

    
    // 피드백 추가
    @PostMapping("/feedback")
    public ResponseEntity<Map<String, Object>> feedback(@RequestBody FeedbackInfo feedback) {
        logger.info("응답 성공");
    	userInfoService.saveFeedback(feedback);
        Map<String, Object> result = new HashMap<>();
        result.put("status", "success");
        return ResponseEntity.ok(result);
    }
    
    // 페이지 이동기록 추가
    @PostMapping("/history")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void history(@RequestBody History history) {
    	logger.info("history 호출");
        userInfoService.saveHistory(history);
    }

    // 자식 페이지 이동기록 출력
    @GetMapping("/history")
    public String selectHistory(@RequestParam String userEmail, Model model) {
    	List<History> list = userInfoService.selectHistory(userEmail);
    	model.addAttribute("history", list);
    	return "history";
    }
}
