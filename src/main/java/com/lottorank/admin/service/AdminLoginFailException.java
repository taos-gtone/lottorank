package com.lottorank.admin.service;

public class AdminLoginFailException extends Exception {
    private final String failRsnCd;

    public AdminLoginFailException(String failRsnCd, String message) {
        super(message);
        this.failRsnCd = failRsnCd;
    }

    public String getFailRsnCd() { return failRsnCd; }
}
