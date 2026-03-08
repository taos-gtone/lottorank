package com.lottorank.admin.service;

import com.lottorank.vo.AdminLoginInfoVO;
import com.lottorank.vo.AdminLoginHistVO;

public interface AdminService {

    /**
     * ADM_LOGIN_INFO 기반 관리자 로그인.
     * 성공 시 AdminLoginInfoVO 반환, 실패 시 AdminLoginFailException 발생.
     * 로그인 이력은 내부에서 자동 기록.
     */
    AdminLoginInfoVO login(String adminId, String adminPw,
                           String loginIp, String userAgent) throws AdminLoginFailException;
}
