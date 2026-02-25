package com.lottorank.service;

/**
 * 로그인 실패 시 발생하는 예외.
 * failRsnCd 로 실패 사유를 구분한다.
 *   01 : 비밀번호 불일치
 *   02 : 없는 계정
 *   03 : 계정 비활성
 */
public class LoginFailException extends RuntimeException {

    private final String failRsnCd;

    public LoginFailException(String failRsnCd) {
        super(failRsnCd);
        this.failRsnCd = failRsnCd;
    }

    public String getFailRsnCd() {
        return failRsnCd;
    }
}
