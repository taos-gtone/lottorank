package com.lottorank.service;

public interface EmailService {
    /**
     * 간단한 텍스트 이메일 발송.
     * @param to      수신자 이메일 주소
     * @param subject 제목
     * @param text    본문
     */
    void sendSimple(String to, String subject, String text);
}
