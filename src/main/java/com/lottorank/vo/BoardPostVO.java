package com.lottorank.vo;

import java.sql.Timestamp;

public class BoardPostVO {

    private long      postNo;
    private String    boardGbnCd;
    private long      memberNo;
    private String    title;
    private String    content;
    private int       viewCnt;
    private int       likeCnt;
    private int       dislikeCnt;
    private int       commentCnt;
    private String    regIp;
    private String    approvalYn;
    private String    delYn;
    private Timestamp createTs;
    private Timestamp updateTs;

    // 조인 필드
    private String nickname;
    private int    unapprovedCommentCnt;

    public long getPostNo() { return postNo; }
    public void setPostNo(long postNo) { this.postNo = postNo; }

    public String getBoardGbnCd() { return boardGbnCd; }
    public void setBoardGbnCd(String boardGbnCd) { this.boardGbnCd = boardGbnCd; }

    public long getMemberNo() { return memberNo; }
    public void setMemberNo(long memberNo) { this.memberNo = memberNo; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getViewCnt() { return viewCnt; }
    public void setViewCnt(int viewCnt) { this.viewCnt = viewCnt; }

    public int getLikeCnt() { return likeCnt; }
    public void setLikeCnt(int likeCnt) { this.likeCnt = likeCnt; }

    public int getDislikeCnt() { return dislikeCnt; }
    public void setDislikeCnt(int dislikeCnt) { this.dislikeCnt = dislikeCnt; }

    public int getCommentCnt() { return commentCnt; }
    public void setCommentCnt(int commentCnt) { this.commentCnt = commentCnt; }

    public String getRegIp() { return regIp; }
    public void setRegIp(String regIp) { this.regIp = regIp; }

    public String getApprovalYn() { return approvalYn; }
    public void setApprovalYn(String approvalYn) { this.approvalYn = approvalYn; }

    public String getDelYn() { return delYn; }
    public void setDelYn(String delYn) { this.delYn = delYn; }

    public Timestamp getCreateTs() { return createTs; }
    public void setCreateTs(Timestamp createTs) { this.createTs = createTs; }

    public Timestamp getUpdateTs() { return updateTs; }
    public void setUpdateTs(Timestamp updateTs) { this.updateTs = updateTs; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public int getUnapprovedCommentCnt() { return unapprovedCommentCnt; }
    public void setUnapprovedCommentCnt(int unapprovedCommentCnt) { this.unapprovedCommentCnt = unapprovedCommentCnt; }

    /** 등록일 yyyy.MM.dd 형식 반환 */
    public String getFormattedDate() {
        if (createTs == null) return "";
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy.MM.dd");
        return sdf.format(createTs);
    }
}
