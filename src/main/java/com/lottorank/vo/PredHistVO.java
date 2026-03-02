package com.lottorank.vo;

import java.util.Date;

/**
 * 마이페이지 내 예측번호 이력 VO
 * LTT_ROUND_RESULT LEFT JOIN MEM_PRED_NUM 결과
 */
public class PredHistVO {

    private int     roundNo;
    private String  roundDate;   // YYYYMMDD 형식 (VARCHAR)
    private int     num1, num2, num3, num4, num5, num6, bonusNum;
    private Integer predNum;     // null = 해당 회차 미제출
    private String  hitYn;       // Y/N/null
    private Date    submitAt;    // null = 미제출

    /* ── 볼 색상 헬퍼 ── */
    public String getBallClass(int n) {
        if (n <= 10) return "ball-y";
        if (n <= 20) return "ball-b";
        if (n <= 30) return "ball-r";
        if (n <= 40) return "ball-g";
        return "ball-gr";
    }

    /** 내 예측번호 볼 색상 */
    public String getPredBallClass() {
        return predNum != null ? getBallClass(predNum) : "";
    }

    /** 예측 여부 */
    public boolean isPredicted() {
        return predNum != null;
    }

    /** 결과 라벨 */
    public String getHitLabel() {
        if (predNum == null) return "미제출";
        if ("Y".equals(hitYn))  return "적중";
        if ("N".equals(hitYn))  return "미적중";
        return "대기중";
    }

    /** 결과 CSS 클래스 */
    public String getHitCss() {
        if (predNum == null)    return "hit-none";
        if ("Y".equals(hitYn)) return "hit-yes";
        if ("N".equals(hitYn)) return "hit-no";
        return "hit-wait";
    }

    /** 추첨일 표시 포맷: 20260214 → 2026.02.14 */
    public String getRoundDateDisp() {
        if (roundDate == null || roundDate.length() != 8) return roundDate != null ? roundDate : "";
        return roundDate.substring(0,4) + "." + roundDate.substring(4,6) + "." + roundDate.substring(6,8);
    }

    /* ── Getters / Setters ── */
    public int getRoundNo()              { return roundNo; }
    public void setRoundNo(int v)        { this.roundNo = v; }

    public String getRoundDate()         { return roundDate; }
    public void setRoundDate(String v)   { this.roundDate = v; }

    public int getNum1()                 { return num1; }
    public void setNum1(int v)           { this.num1 = v; }

    public int getNum2()                 { return num2; }
    public void setNum2(int v)           { this.num2 = v; }

    public int getNum3()                 { return num3; }
    public void setNum3(int v)           { this.num3 = v; }

    public int getNum4()                 { return num4; }
    public void setNum4(int v)           { this.num4 = v; }

    public int getNum5()                 { return num5; }
    public void setNum5(int v)           { this.num5 = v; }

    public int getNum6()                 { return num6; }
    public void setNum6(int v)           { this.num6 = v; }

    public int getBonusNum()             { return bonusNum; }
    public void setBonusNum(int v)       { this.bonusNum = v; }

    public Integer getPredNum()          { return predNum; }
    public void setPredNum(Integer v)    { this.predNum = v; }

    public String getHitYn()             { return hitYn; }
    public void setHitYn(String v)       { this.hitYn = v; }

    public Date getSubmitAt()            { return submitAt; }
    public void setSubmitAt(Date v)      { this.submitAt = v; }
}
