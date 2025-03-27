package kr.spring.mapper;

import kr.spring.entity.FeedbackInfo;
import kr.spring.entity.History;
import kr.spring.entity.UserInfo;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface UserInfoMapper {

	// 🔹 사용자 정보 저장 (INSERT)
	@Insert("INSERT INTO user_info (user_email, user_name, parent_email)"
			+ " VALUES (#{userEmail}, #{userName}, #{parentEmail})"
			+ " ON DUPLICATE KEY UPDATE"
			+ " user_name = VALUES(user_name),"
			+ " parent_email = VALUES(parent_email)")
	void insertUser(UserInfo userInfo);

	// 🔹 사용자 정보 조회 (SELECT)
	@Select("SELECT * FROM user_info WHERE user_email = #{userEmail}")
	UserInfo findByUserEmail(String userEmail);

	// ✅ 사용자 정보 업데이트 (UPDATE)
	@Update("UPDATE user_info SET  parent_email = #{parentEmail} WHERE user_email = #{userEmail}")
	void updateUser(UserInfo userInfo);

	// 피드백 추가
	@Insert("INSERT INTO feedback_info (user_email, fb_url, fb_type, fb_explanation, created_at) VALUES (#{userEmail}, #{fbUrl}, #{fbType}, #{fbExplanation}, now())")
	void saveFeedback(FeedbackInfo feedback);

	// 방문 기록 추가
	@Insert("INSERT INTO history (his_url, title, user_email, created_at) VALUES (#{hisUrl}, #{title}, #{userEmail}, now())")
	void saveHistory(History history);
	
	// 방문 기록 출력 
	@Select("SELECT h.* FROM history h join user_info u on h.user_email = u.user_email where u.parent_email = #{userEmail} order by created_at DESC")
	@Results({
	    @Result(property = "hisIdx", column = "his_idx"),
	    @Result(property = "userEmail", column = "user_email"),
	    @Result(property = "hisUrl", column = "his_url"),
	    @Result(property = "createdAt", column = "created_at"),
	    @Result(property = "title", column = "title")
	})
	List<History> selectHistory(String userEmail);
	
}
