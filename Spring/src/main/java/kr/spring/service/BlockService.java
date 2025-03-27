package kr.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.spring.entity.SelfBlockInfo;
import kr.spring.entity.ParentBlockInfo;
import kr.spring.mapper.BlockMapper;

@Service
public class BlockService {

    @Autowired
    private BlockMapper blockMapper;
    
	// 자신 차단 페이지 추가
    public void insertSelfBlock(SelfBlockInfo selfBlock) {
        // ✅ 새로운 사용자면 삽입
    	blockMapper.insertSelf(selfBlock);
    }
	// 자신 차단 페이지 제거
    public void deleteSelfBlock(SelfBlockInfo selfBlock) {
    	blockMapper.DeleteSelf(selfBlock);
    }
    // 자신 차단 페이지 조회
    public List<SelfBlockInfo> selectSelfBlock(String userEmail){
    	List<SelfBlockInfo> list = (List<SelfBlockInfo>) blockMapper.SelectSelf(userEmail);
    	return list;
    }
    
	// 부모 차단 페이지 추가
    public void insertParentBlock(ParentBlockInfo parentBlock) {
        // ✅ 새로운 사용자면 삽입
    	blockMapper.insertParent(parentBlock);
    }
    
	// 부모 차단 페이지 제거
    public void deleteParentBlock(ParentBlockInfo parentBlock) {
    	blockMapper.DeleteParent(parentBlock);
    }
    
 // 부모 차단 페이지 조회
    public List<ParentBlockInfo> selectParentBlock(String userEmail){
    	List<ParentBlockInfo> list = (List<ParentBlockInfo>) blockMapper.SelectParent(userEmail);
    	return list;
    }
}
