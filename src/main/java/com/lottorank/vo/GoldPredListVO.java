package com.lottorank.vo;

import java.util.Date;

/**
 * 골드번호 조합 - 고객 예측번호 목록 VO
 * MEM_PRED_NUM JOIN MEM_JOIN_INFO LEFT JOIN MEM_RANK_ALL
 */
public class GoldPredListVO {

    private Integer ranking;
    private String  nickname;
    private Integer predNum;
    private String  hitYn;
    private Date    submitAt;

    /* ── 순위 헬퍼 ── */
    public String getRankingLabel() {
        return (ranking != null) ? ranking + "위" : "NEW";
    }

    public String getRankingCss() {
        if (ranking == null) return "rank-new";
        if (ranking == 1)    return "rank-1";
        if (ranking == 2)    return "rank-2";
        if (ranking == 3)    return "rank-3";
        return "";
    }

    /* ── 볼 색상 헬퍼 ── */
    public String getPredBallClass() {
        if (predNum == null) return "";
        if (predNum <= 10) return "ball-y";
        if (predNum <= 20) return "ball-b";
        if (predNum <= 30) return "ball-r";
        if (predNum <= 40) return "ball-g";
        return "ball-gr";
    }

    /* ── 적중여부 헬퍼 ── */
    public String getHitLabel() {
        if (predNum == null)    return "미제출";
        if ("Y".equals(hitYn)) return "적중";
        if ("N".equals(hitYn)) return "미적중";
        return "대기중";
    }

    public String getHitCss() {
        if (predNum == null)    return "hit-none";
        if ("Y".equals(hitYn)) return "hit-yes";
        if ("N".equals(hitYn)) return "hit-no";
        return "hit-wait";
    }

    /* ── Getters / Setters ── */
    public Integer getRanking()          { return ranking; }
    public void setRanking(Integer v)    { this.ranking = v; }

    public String getNickname()          { return nickname; }
    public void setNickname(String v)    { this.nickname = v; }

    public Integer getPredNum()          { return predNum; }
    public void setPredNum(Integer v)    { this.predNum = v; }

    public String getHitYn()             { return hitYn; }
    public void setHitYn(String v)       { this.hitYn = v; }

    public Date getSubmitAt()            { return submitAt; }
    public void setSubmitAt(Date v)      { this.submitAt = v; }
}
