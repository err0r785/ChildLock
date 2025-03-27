package kr.spring.service;


import kr.spring.entity.FeedbackInfo;
import kr.spring.entity.History;
import kr.spring.entity.UserInfo;
import kr.spring.mapper.UserInfoMapper;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserInfoService {

    @Autowired
    private UserInfoMapper userInfoMapper;

    // ✅ 사용자 정보 저장 (중복 체크 후 UPDATE or INSERT)
    public String saveUserInfo(UserInfo userInfo) {
        UserInfo existingUser = userInfoMapper.findByUserEmail(userInfo.getUserEmail());

        if (existingUser != null) {
            // ✅ 기존 데이터가 있으면 업데이트
            userInfoMapper.updateUser(userInfo);
            return "✅ 기존 사용자 정보 업데이트 완료: " + userInfo.getUserEmail();
        } else {
            // ✅ 새로운 사용자면 삽입
            userInfoMapper.insertUser(userInfo);
            return "✅ 새 사용자 정보 저장 완료: " + userInfo.getUserEmail();
        }
    }
    
    public void updateUser(UserInfo userInfo) {
    	userInfoMapper.updateUser(userInfo);
    }
    
    public void saveFeedback(FeedbackInfo feedback) {
    	userInfoMapper.saveFeedback(feedback);
    }

	public void saveHistory(History history) {
		userInfoMapper.saveHistory(history);
	}
	
	public List<History> selectHistory(String userEmail) {
		List<History> list = (List<History>) userInfoMapper.selectHistory(userEmail);
		return list;
	}
}