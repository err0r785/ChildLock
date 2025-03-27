package kr.spring.entity;

import java.util.List;

public class BlockResponse {
    private List<SelfBlockInfo> selfList;
    private List<ParentBlockInfo> parentList;

    public BlockResponse(List<SelfBlockInfo> selfList, List<ParentBlockInfo> parentList) {
        this.selfList = selfList;
        this.parentList = parentList;
    }

    // 게터와 세터
    public List<SelfBlockInfo> getSelfList() {
        return selfList;
    }

    public void setSelfList(List<SelfBlockInfo> selfList) {
        this.selfList = selfList;
    }

    public List<ParentBlockInfo> getParentList() {
        return parentList;
    }

    public void setParentList(List<ParentBlockInfo> parentList) {
        this.parentList = parentList;
    }
}
