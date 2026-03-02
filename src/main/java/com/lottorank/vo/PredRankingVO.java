package com.lottorank.vo;

import java.util.Date;

/**
 * 회원번호 조회 페이지용 VO
 * - 예측 회차의 MEM_PRED_NUM + 최신 MEM_RANK_ALL + MEM_JOIN_INFO 조인 결과
 */
public class PredRankingVO {

    private Integer ranking;    // MEM_RANK_ALL.ranking (없으면 null → 신규)
    private long    memberNo;
    private String  nickname;
    private int     predNum;    // MEM_PRED_NUM.pred_num
    private Date    submitAt;   // MEM_PRED_NUM.submit_at

    /** 예측 번호 볼 색상 CSS 클래스 */
    public String getBallClass() {
        if (predNum <= 10) return "ball-y";
        if (predNum <= 20) return "ball-b";
        if (predNum <= 30) return "ball-r";
        if (predNum <= 40) return "ball-g";
        return "ball-gr";
    }

    /** 순위 표시 문자열 (없으면 NEW) */
    public String getRankingLabel() {
        return (ranking != null) ? ranking + "위" : "NEW";
    }

    /** 순위 CSS 클래스 */
    public String getRankingCss() {
        if (ranking == null) return "rank-new";
        if (ranking == 1)    return "rank-1";
        if (ranking == 2)    return "rank-2";
        if (ranking == 3)    return "rank-3";
        return "";
    }

    /** 제출일시 표시 (yyyy.MM.dd HH:mm:ss) */
    public String getSubmitAtDisp() {
        if (submitAt == null) return "-";
        return new java.text.SimpleDateFormat("yyyy.MM.dd HH:mm:ss").format(submitAt);
    }

    /* ── Getters / Setters ── */
    public Integer getRanking()           { return ranking; }
    public void setRanking(Integer v)     { this.ranking = v; }

    public long getMemberNo()             { return memberNo; }
    public void setMemberNo(long v)       { this.memberNo = v; }

    public String getNickname()           { return nickname; }
    public void setNickname(String v)     { this.nickname = v; }

    public int getPredNum()               { return predNum; }
    public void setPredNum(int v)         { this.predNum = v; }

    public Date getSubmitAt()             { return submitAt; }
    public void setSubmitAt(Date v)       { this.submitAt = v; }
}
