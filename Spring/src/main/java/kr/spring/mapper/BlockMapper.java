package kr.spring.mapper;

import kr.spring.entity.ParentBlockInfo;
import kr.spring.entity.SelfBlockInfo;
import kr.spring.entity.UserInfo;

import java.util.List;

import org.apache.ibatis.annotations.*;


@Mapper
public interface BlockMapper {
	// 자신 차단 페이지 추가
	@Insert("INSERT INTO self_block_info (user_email, sb_url, created_at) VALUES (#{userEmail}, #{sbUrl},  now())")
	void insertSelf(SelfBlockInfo block);
	
	// 자신 차단 페이지 제거
	@Delete("DELETE FROM self_block_info WHERE user_email = #{userEmail} and sb_url =  #{sbUrl}")
	void DeleteSelf(SelfBlockInfo block);

	// 자신 차단 페이지 조회
	@Select("SELECT * FROM self_block_info WHERE user_email = #{userEmail}")
	@Results({
	    @Result(property = "sbIdx", column = "sb_idx"),
	    @Result(property = "userEmail", column = "user_email"),
	    @Result(property = "sbUrl", column = "sb_url"),
	    @Result(property = "createdAt", column = "created_at"),
	})
	List<SelfBlockInfo> SelectSelf(String userEmail);
	
	// 부모 차단 페이지 추가
	@Insert("INSERT INTO parent_block_info (user_email, pb_url, created_at) VALUES (#{userEmail}, #{pbUrl},  now())")
	void insertParent(ParentBlockInfo block);
	
	// 부모 차단 페이지 제거
	@Delete("DELETE FROM parent_block_info WHERE user_email = #{userEmail}  and pb_url =  #{pbUrl}")
	void DeleteParent(ParentBlockInfo block);
	
	// 부모 차단 페이지 조회
	@Select("SELECT * FROM parent_block_info WHERE user_email = #{userEmail}")
	@Results({
	    @Result(property = "pbIdx", column = "pb_idx"),
	    @Result(property = "userEmail", column = "user_email"),
	    @Result(property = "pbUrl", column = "pb_url"),
	    @Result(property = "createdAt", column = "created_at"),
	})
	List<ParentBlockInfo> SelectParent(String userEmail);
}
