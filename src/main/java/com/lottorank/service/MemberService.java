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

    /** 마이페이지: 회원 상세 정보 조회 */
    MemberVO getMemberDetail(long memberNo);

    /** 마이페이지: 비밀번호 변경 (현재 비밀번호 검증 후 변경) */
    void updateMemberPw(long memberNo, String currentPw, String newPw, String chgIp);

    /** 마이페이지: 이메일 변경 */
    void updateMemberEmail(long memberNo, String emailId, String emailAddr, String chgIp);

    /** 마이페이지: 휴대전화번호 변경 */
    void updateMemberMobile(long memberNo, String mobileNo, String chgIp);

    /**
     * 로그인 결과를 트랜잭션으로 저장한다.
     * - 성공(loginRsltCd="S") : last_login_at UPDATE + MEM_LOGIN_HIST INSERT (1 transaction)
     * - 실패(loginRsltCd="F") : MEM_LOGIN_HIST INSERT 만 수행
     */
    void saveLoginHistory(MemberVO member, String userId,
                          String regLoginTypCd, String loginRsltCd, String failRsnCd,
                          String loginIp, String sessionId, String userAgent);
}
