package com.lottorank.vo;

/**
 * 당첨번호 탭 - 번호별 출현/미출현 통계 VO
 */
public class WinNumStatVO {

    private int     lottoNum;           // 로또 번호 (1~45)
    private Integer appearCnt;          // 출현 횟수 (most 모드)
    private String  roundList;          // 출현 회차 목록 comma-sep, desc (most 모드)
    private Integer consecutiveAbsent;  // 연속 미출현 횟수 (least 모드)

    public int     getLottoNum()                    { return lottoNum; }
    public void    setLottoNum(int v)               { this.lottoNum = v; }

    public Integer getAppearCnt()                   { return appearCnt; }
    public void    setAppearCnt(Integer v)          { this.appearCnt = v; }

    public String  getRoundList()                   { return roundList; }
    public void    setRoundList(String v)           { this.roundList = v; }

    public Integer getConsecutiveAbsent()           { return consecutiveAbsent; }
    public void    setConsecutiveAbsent(Integer v)  { this.consecutiveAbsent = v; }
}
