package com.lottorank.vo;

public class MemRank5RoundVO {

    private int     roundNo;
    private long    memberNo;
    private String  nickname;
    private int     ranking;
    private int     lastSelCnt;    // 최근5회내 번호선택횟수
    private int     winCnt;        // 정답횟수
    private int     lostCnt;       // 오답횟수
    private Integer prevRanking;
    private double  hitRate;       // ROUND(win_cnt * 100.0 / last_sel_cnt, 1)
    private Integer rankChange;    // prev_ranking - ranking (null이면 신규)
    private String  predNum;       // 해당 회차 예측번호 (null=미제출)
    private String  hitYn;         // 적중여부 (Y/N/null=대기중)
    private Integer allRanking;    // 같은 회차 전체기간 순위 (관리자 교차표시용, null=미집계)

    private static final String[] EMOJIS = {"🦁", "🎯", "🔮", "🌊", "🌙", "🍀"};

    public int getAvatarClass() {
        return ((ranking - 1) % 6) + 1;
    }

    public String getAvatarEmoji() {
        return EMOJIS[(ranking - 1) % 6];
    }

    public String getHitRateStr() {
        return String.format("%.1f%%", hitRate);
    }

    /** 순위 표시 (천 단위 콤마) */
    public String getRankingStr() {
        return String.format("%,d", ranking);
    }

    public String getRankChangeLabel() {
        if (rankChange == null) return "NEW";
        if (rankChange > 0)     return "▲" + String.format("%,d", rankChange);
        if (rankChange < 0)     return "▼" + String.format("%,d", Math.abs(rankChange));
        return "-";
    }

    public String getRankChangeCss() {
        if (rankChange == null) return "change-new";
        if (rankChange > 0)     return "change-up";
        if (rankChange < 0)     return "change-down";
        return "change-same";
    }

    /* ── Getters / Setters ── */
    public int getRoundNo()               { return roundNo; }
    public void setRoundNo(int v)         { this.roundNo = v; }

    public long getMemberNo()             { return memberNo; }
    public void setMemberNo(long v)       { this.memberNo = v; }

    public String getNickname()           { return nickname; }
    public void setNickname(String v)     { this.nickname = v; }

    public int getRanking()               { return ranking; }
    public void setRanking(int v)         { this.ranking = v; }

    public int getLastSelCnt()            { return lastSelCnt; }
    public void setLastSelCnt(int v)      { this.lastSelCnt = v; }

    public int getWinCnt()                { return winCnt; }
    public void setWinCnt(int v)          { this.winCnt = v; }

    public int getLostCnt()               { return lostCnt; }
    public void setLostCnt(int v)         { this.lostCnt = v; }

    public Integer getPrevRanking()       { return prevRanking; }
    public void setPrevRanking(Integer v) { this.prevRanking = v; }

    public double getHitRate()            { return hitRate; }
    public void setHitRate(double v)      { this.hitRate = v; }

    public Integer getRankChange()        { return rankChange; }
    public void setRankChange(Integer v)  { this.rankChange = v; }

    public String getPredNum()            { return predNum; }
    public void setPredNum(String v)      { this.predNum = v; }

    public String getHitYn()                { return hitYn; }
    public void setHitYn(String v)          { this.hitYn = v; }

    public Integer getAllRanking()           { return allRanking; }
    public void setAllRanking(Integer v)    { this.allRanking = v; }

    /** 예측번호 볼 색상 CSS 클래스 */
    public String getPredBallClass() {
        if (predNum == null) return "";
        int n = Integer.parseInt(predNum);
        if (n <= 10) return "ball-y";
        if (n <= 20) return "ball-b";
        if (n <= 30) return "ball-r";
        if (n <= 40) return "ball-g";
        return "ball-gr";
    }

    /** 적중여부 라벨 */
    public String getHitLabel() {
        if (predNum == null) return "미제출";
        if ("Y".equals(hitYn)) return "적중";
        if ("N".equals(hitYn)) return "미적중";
        return "대기중";
    }

    /** 적중여부 CSS 클래스 */
    public String getHitCss() {
        if (predNum == null) return "hit-none";
        if ("Y".equals(hitYn)) return "hit-yes";
        if ("N".equals(hitYn)) return "hit-no";
        return "hit-wait";
    }
}
