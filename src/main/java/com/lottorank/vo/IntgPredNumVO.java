package com.lottorank.vo;

/**
 * 골드 예측통합 - 번호별 예측 집계 VO
 * 조건 내 회원들이 선택한 번호, 인원수, 순위 목록
 */
public class IntgPredNumVO {

    private int    predNum;
    private int    memberCnt;
    private String rankings; // comma-separated, e.g. "1,3,5,NEW"

    /* ── 볼 색상 헬퍼 ── */
    public String getBallClass() {
        if (predNum <= 10) return "ball-y";
        if (predNum <= 20) return "ball-b";
        if (predNum <= 30) return "ball-r";
        if (predNum <= 40) return "ball-g";
        return "ball-gr";
    }

    public int    getPredNum()           { return predNum; }
    public void   setPredNum(int v)      { this.predNum = v; }

    public int    getMemberCnt()         { return memberCnt; }
    public void   setMemberCnt(int v)    { this.memberCnt = v; }

    public String getRankings()          { return rankings; }
    public void   setRankings(String v)  { this.rankings = v; }
}
