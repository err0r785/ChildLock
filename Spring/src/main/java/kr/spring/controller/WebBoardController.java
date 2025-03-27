package kr.spring.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller; // 변경됨
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody; // 추가됨
import org.springframework.web.client.RestTemplate;



@Controller
@RequestMapping
@CrossOrigin(origins = "*")
public class WebBoardController {
	
	private static final Logger logger = LoggerFactory.getLogger(WebBoardController.class);

    // Flask API URL (적절한 URL로 수정)
    private final String FLASK_API_URL = "http://localhost:5000/over/predict";

    @Autowired
    private RestTemplate restTemplate;

    // 링크에 마우스 오버할 때 실행
    @PostMapping("/analyze")
    @ResponseBody // JSON 반환을 위해 추가
    public Map<String, Object> analyzeURL(@RequestParam("url") String url, @RequestParam("domain") String domain) {
    	logger.info("오버 이벤트");
        Map<String, Object> response = new HashMap<>();
        
        if (url == null || url.isEmpty()) {
        	logger.info("result", "❌ URL을 입력하세요!");
            return response;
        }

        // Flask로 보낼 요청 데이터 구성
        Map<String, Object> requestData = new HashMap<>();
        requestData.put("url", url);
        requestData.put("domain", domain);
        
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(requestData, headers);

        try {
            ResponseEntity<Map> flaskResponse = restTemplate.exchange(
                    FLASK_API_URL, HttpMethod.POST, requestEntity, Map.class);
            if (flaskResponse.getStatusCode().is2xxSuccessful() && flaskResponse.getBody() != null) {
                @SuppressWarnings("unchecked")
                ArrayList<String> result = (ArrayList<String>) flaskResponse.getBody().get("aaa");
                Double score = (Double) flaskResponse.getBody().get("score");
                response.put("result", result);
                response.put("url", url);
                response.put("score", score);
            } else {
                response.put("result", "⚠️ 분석 실패: 응답 오류");
            }
        } catch (Exception e) {
            response.put("result", "🚨 서버 오류: " + e.getMessage());
        }

        return response;
    }
    
    @GetMapping("/analyze")
    @ResponseBody // JSON 대신 텍스트 응답
    public String analyzeURLGet(@RequestParam(value = "url", required = false) String url) {
        return "<a href='https://www.naver.com'>이 엔드포인트는 POST 요청만 지원합니다. POST 요청을 사용해 주세요.</a>";
    }
    
    @GetMapping("over-page")
    public String hover_benign(@RequestParam("result") String result, @RequestParam("url") String url, @RequestParam("score") Double score, Model model) {
        logger.info(result);
        logger.info(url);
        
    	model.addAttribute("result", result);
        model.addAttribute("url", url);
        model.addAttribute("score", score);
    	return "over";
    }
    
    @GetMapping("/test")
    public String test() {
    	return "history";
    }
    
    
}
