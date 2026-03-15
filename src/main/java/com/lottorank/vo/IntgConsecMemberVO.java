package com.lottorank.vo;

/**
 * 골드 예측통합 - 연속 적중/미적중 회원별 조회 VO
 * 조건(최근 N회차 연속 적중/미적중)을 만족하는 회원이 다음 회차에 선택한 번호, 횟수, 닉네임, 순위, 미제출 횟수
 */
public class IntgConsecMemberVO {

    private int     predNum;
    private int     hitCnt;      // 적중횟수 또는 미적중횟수
    private String  nickname;
    private Integer ranking;     // NULL = 순위 없음(NEW)
    private int     noSubmitCnt; // 해당 기간 미제출 횟수

    public int     getPredNum()              { return predNum; }
    public void    setPredNum(int v)         { this.predNum = v; }

    public int     getHitCnt()               { return hitCnt; }
    public void    setHitCnt(int v)          { this.hitCnt = v; }

    public String  getNickname()             { return nickname; }
    public void    setNickname(String v)     { this.nickname = v; }

    public Integer getRanking()              { return ranking; }
    public void    setRanking(Integer v)     { this.ranking = v; }

    public int     getNoSubmitCnt()          { return noSubmitCnt; }
    public void    setNoSubmitCnt(int v)     { this.noSubmitCnt = v; }
}
