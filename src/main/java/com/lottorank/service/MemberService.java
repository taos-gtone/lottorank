package com.lottorank.service;

import com.lottorank.vo.MemberVO;

public interface MemberService {

    void join(MemberVO member);

    /** 소셜 회원가입 (비밀번호 자동 생성) */
    void joinBySocial(MemberVO member);

    boolean isUserIdAvailable(String userId);

    /** 소셜 ID로 기존 회원 조회 */
    MemberVO findBySocialId(String socialId);

    MemberVO login(String userId, String userPw);

    /**
     * 로그인 결과를 트랜잭션으로 저장한다.
     * - 성공(loginRsltCd="S") : last_login_at UPDATE + MEM_LOGIN_HIST INSERT (1 transaction)
     * - 실패(loginRsltCd="F") : MEM_LOGIN_HIST INSERT 만 수행
     */
    void saveLoginHistory(MemberVO member, String userId,
                          String regLoginTypCd, String loginRsltCd, String failRsnCd,
                          String loginIp, String sessionId, String userAgent);
}
