package com.lottorank.vo;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class LottoRoundResult {

    private int      roundNo;
    private LocalDate drawDate;
    private int      num1, num2, num3, num4, num5, num6;
    private int      bonusNum;
    private long     prize1stAmount;
    private int      prize1stCount;

    /* ── 볼 색상 (번호 범위별) ── */
    private static String ballColor(int n) {
        if (n <= 10) return "y";
        if (n <= 20) return "b";
        if (n <= 30) return "r";
        if (n <= 40) return "g";
        return "gr";
    }

    public String getBallColor1() { return ballColor(num1); }
    public String getBallColor2() { return ballColor(num2); }
    public String getBallColor3() { return ballColor(num3); }
    public String getBallColor4() { return ballColor(num4); }
    public String getBallColor5() { return ballColor(num5); }
    public String getBallColor6() { return ballColor(num6); }
    public String getBonusColor()  { return ballColor(bonusNum); }

    /* ── 날짜 포매팅 (yyyy.MM.dd) ── */
    public String getFormattedDate() {
        return drawDate.format(DateTimeFormatter.ofPattern("yyyy.MM.dd"));
    }

    /* ── 당첨금 포매팅 (N억 M만원) ── */
    public String getFormattedPrize() {
        long eok = prize1stAmount / 100_000_000L;
        long man = (prize1stAmount % 100_000_000L) / 10_000L;
        if (eok > 0 && man > 0) {
            return String.format(Locale.US, "%d억 %,d만원", eok, man);
        } else if (eok > 0) {
            return String.format("%d억원", eok);
        }
        return String.format(Locale.US, "%,d만원", man);
    }

    /* ── Getters / Setters ── */
    public int getRoundNo()                        { return roundNo; }
    public void setRoundNo(int roundNo)            { this.roundNo = roundNo; }

    public LocalDate getDrawDate()                 { return drawDate; }
    public void setDrawDate(LocalDate drawDate)    { this.drawDate = drawDate; }

    public int getNum1()                           { return num1; }
    public void setNum1(int num1)                  { this.num1 = num1; }

    public int getNum2()                           { return num2; }
    public void setNum2(int num2)                  { this.num2 = num2; }

    public int getNum3()                           { return num3; }
    public void setNum3(int num3)                  { this.num3 = num3; }

    public int getNum4()                           { return num4; }
    public void setNum4(int num4)                  { this.num4 = num4; }

    public int getNum5()                           { return num5; }
    public void setNum5(int num5)                  { this.num5 = num5; }

    public int getNum6()                           { return num6; }
    public void setNum6(int num6)                  { this.num6 = num6; }

    public int getBonusNum()                       { return bonusNum; }
    public void setBonusNum(int bonusNum)          { this.bonusNum = bonusNum; }

    public long getPrize1stAmount()                { return prize1stAmount; }
    public void setPrize1stAmount(long v)          { this.prize1stAmount = v; }

    public int getPrize1stCount()                  { return prize1stCount; }
    public void setPrize1stCount(int v)            { this.prize1stCount = v; }
}
