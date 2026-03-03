package com.lottorank.vo;

public class MemRankAllVO {

    private int     roundNo;
    private long    memberNo;
    private String  nickname;
    private int     ranking;
    private int     grade;
    private int     elpsCnt;       // 경과횟수
    private int     selNumCnt;     // 번호선택횟수
    private int     winCnt;        // 정답횟수
    private int     contLostCnt;   // 연속오답횟수
    private Integer prevRanking;
    private Integer prevGrade;
    private double  hitRate;       // ROUND(win_cnt * 100.0 / sel_num_cnt, 1)
    private Integer rankChange;    // prev_ranking - ranking (null이면 신규)
    private boolean hasPred;       // 다음 예측 회차 예측번호 제출 여부

    private static final String[] EMOJIS = {"🦁", "🎯", "🔮", "🌊", "🌙", "🍀"};

    /** 아바타 CSS 클래스 번호 (av-g1 ~ av-g6 순환) */
    public int getAvatarClass() {
        return ((ranking - 1) % 6) + 1;
    }

    /** 순위별 아바타 이모지 */
    public String getAvatarEmoji() {
        return EMOJIS[(ranking - 1) % 6];
    }

    /** 적중률 포매팅 예: "72.4%" */
    public String getHitRateStr() {
        return String.format("%.1f%%", hitRate);
    }

    /** 순위 표시 (천 단위 콤마) */
    public String getRankingStr() {
        return String.format("%,d", ranking);
    }

    /** 순위 변동 텍스트 예: "-", "▲2", "▼1,234", "NEW" */
    public String getRankChangeLabel() {
        if (rankChange == null) return "NEW";
        if (rankChange > 0)     return "▲" + String.format("%,d", rankChange);
        if (rankChange < 0)     return "▼" + String.format("%,d", Math.abs(rankChange));
        return "-";
    }

    /** 순위 변동 CSS 클래스 */
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

    public int getGrade()                 { return grade; }
    public void setGrade(int v)           { this.grade = v; }

    public int getElpsCnt()               { return elpsCnt; }
    public void setElpsCnt(int v)         { this.elpsCnt = v; }

    public int getSelNumCnt()             { return selNumCnt; }
    public void setSelNumCnt(int v)       { this.selNumCnt = v; }

    public int getWinCnt()                { return winCnt; }
    public void setWinCnt(int v)          { this.winCnt = v; }

    public int getContLostCnt()           { return contLostCnt; }
    public void setContLostCnt(int v)     { this.contLostCnt = v; }

    public Integer getPrevRanking()       { return prevRanking; }
    public void setPrevRanking(Integer v) { this.prevRanking = v; }

    public Integer getPrevGrade()         { return prevGrade; }
    public void setPrevGrade(Integer v)   { this.prevGrade = v; }

    public double getHitRate()            { return hitRate; }
    public void setHitRate(double v)      { this.hitRate = v; }

    public Integer getRankChange()        { return rankChange; }
    public void setRankChange(Integer v)  { this.rankChange = v; }

    public boolean isHasPred()            { return hasPred; }
    public void setHasPred(boolean v)     { this.hasPred = v; }
}
