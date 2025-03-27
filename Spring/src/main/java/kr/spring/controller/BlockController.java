package kr.spring.controller;

import kr.spring.entity.ParentBlockInfo;
import kr.spring.entity.SelfBlockInfo;
import kr.spring.service.BlockService;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.google.common.net.InternetDomainName;
import java.net.URI;

@Controller  // ✅ @Controller → @RestController 변경 (JSON 응답 가능)
@RequestMapping("/block") // ✅ URL 기본 경로 지정
@CrossOrigin(origins = "*")
public class BlockController {
	 @Autowired
	    private BlockService blockService;

	    private static final Logger logger = LoggerFactory.getLogger(WebBoardController.class);
	    // 🔹 사용자 정보 저장 API (POST)
	    
	    // 자신 차단 페이지 추가
	    @PostMapping("/selfBlock")
	    public String saveUser(SelfBlockInfo selfBlock, Model model) {
	    	

	        // ✅ URL에서 도메인 추출
	        String domain = UrlUtils.extractDomain(selfBlock.getSbUrl());
	        if (domain == null) {
	            model.addAttribute("error", "올바른 URL을 입력하세요.");
	            return "blockList"; // 에러 처리
	        }
	        
	        // ✅ 추출된 도메인으로 URL 업데이트
	        selfBlock.setSbUrl(domain);
	        
	        
	    	blockService.insertSelfBlock(selfBlock);
	    	List<SelfBlockInfo> selfList = blockService.selectSelfBlock(selfBlock.getUserEmail());
	    	model.addAttribute("selfList", selfList);
	    	List<ParentBlockInfo> parentList = blockService.selectParentBlock(selfBlock.getUserEmail());
	    	model.addAttribute("parentList", parentList);
	    	return "blockList";
	    }
	    
	    // 자신 차단 페이지 삭제
	    @PostMapping("/deleteselfBlock")
	    public String deleteSelfBlock(SelfBlockInfo selfBlock, Model model) {
	        blockService.deleteSelfBlock(selfBlock);
	        // 삭제 후, 사용자의 자식 차단 목록을 다시 조회해서 모델에 담습니다.
	    	List<SelfBlockInfo> selfList = blockService.selectSelfBlock(selfBlock.getUserEmail());
	    	model.addAttribute("selfList", selfList);
	    	List<ParentBlockInfo> parentList = blockService.selectParentBlock(selfBlock.getUserEmail());
	    	model.addAttribute("parentList", parentList);
	    	return "blockList";
	    }
	    
	    // 자식 차단페이지 추가
	    @PostMapping("/parentBlock")
	    public String saveParent(ParentBlockInfo parentBlock, Model model) {
	        logger.info("자식 차단 호출");

	        // ✅ URL에서 도메인 추출
	        String domain = UrlUtils.extractDomain(parentBlock.getPbUrl());
	        if (domain == null) {
	            model.addAttribute("error", "올바른 URL을 입력하세요.");
	            return "blockList"; // 에러 처리
	        }
	        
	        // ✅ 추출된 도메인으로 URL 업데이트
	        parentBlock.setPbUrl(domain);
	        
	        // ✅ DB 저장
	        blockService.insertParentBlock(parentBlock);

	        // ✅ 차단 리스트 갱신
	    	List<SelfBlockInfo> selfList = blockService.selectSelfBlock(parentBlock.getUserEmail());
	    	model.addAttribute("selfList", selfList);
	        List<ParentBlockInfo> parentList = blockService.selectParentBlock(parentBlock.getUserEmail());
	        model.addAttribute("parentList", parentList);
	        
	        return "blockList";
	    }

	    // 자식 차단 페이지 삭제
	    @PostMapping("/deleteparentBlock")
	    public String deleteParentBlock(ParentBlockInfo parentBlock, Model model) {
	        blockService.deleteParentBlock(parentBlock);
	        
	    	List<SelfBlockInfo> selfList = blockService.selectSelfBlock(parentBlock.getUserEmail());
	    	model.addAttribute("selfList", selfList);
	        List<ParentBlockInfo> parentList = blockService.selectParentBlock(parentBlock.getUserEmail());
	    	model.addAttribute("parentList", parentList);
	    	return "blockList";
	    }
	    
	    // 차단 페이지 출력 (자신=selfList, 자식=parentList)
	    @GetMapping("/blocklist")
	    public String selectParent(@RequestParam String userEmail, Model model) {
	    	logger.info("blockList 호출");
	    	List<SelfBlockInfo> selfList = blockService.selectSelfBlock(userEmail);
	    	model.addAttribute("selfList", selfList);
	    	List<ParentBlockInfo> parentList = blockService.selectParentBlock(userEmail);
	    	model.addAttribute("parentList", parentList);
	    	return "blockList";
	    }
	    
	    public class UrlUtils {
	        public static String extractDomain(String url) {
	        	try {
	                URI uri = new URI(url);
	                String host = uri.getHost();

	                if (host == null) return null;

	                InternetDomainName domainName = InternetDomainName.from(host);
	                if (domainName.isUnderPublicSuffix()) {
	                    return domainName.topPrivateDomain().toString(); // ex: "naver.com"
	                } else {
	                    return host;
	                }
	            } catch (Exception e) {
	                e.printStackTrace();
	                return null;
	            }
	        }
	    }


}
