package com.lottorank.service;

import com.lottorank.vo.MemberVO;

public interface MemberService {

    void join(MemberVO member);

    boolean isUserIdAvailable(String userId);

    MemberVO login(String userId, String userPw);

    /**
     * 로그인 결과를 트랜잭션으로 저장한다.
     * - 성공(loginRsltCd="S") : last_login_at UPDATE + MEM_LOGIN_HIST INSERT (1 transaction)
     * - 실패(loginRsltCd="F") : MEM_LOGIN_HIST INSERT 만 수행
     */
    void saveLoginHistory(MemberVO member, String userId,
                          String loginTypCd, String loginRsltCd, String failRsnCd,
                          String loginIp, String sessionId, String userAgent);
}
