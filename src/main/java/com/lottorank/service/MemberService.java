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

    /** 아이디 찾기: 이름 + 이메일(전체)로 마스킹된 userId 반환, 없으면 null */
    String findUserId(String userName, String email);

    /** 비밀번호 찾기: userId + 이름 + 이메일 검증 후 임시 비밀번호 반환, 없으면 null */
    String resetPasswordTemp(String userId, String userName, String email, String chgIp);

    /** 임시 비밀번호 상태(acct_sts_cd='02') 회원의 비밀번호 변경 → acct_sts_cd '01' 복구 */
    void changeTempPassword(long memberNo, String newPw, String chgIp);

    /**
     * 로그인 결과를 트랜잭션으로 저장한다.
     * - 성공(loginRsltCd="S") : last_login_at UPDATE + MEM_LOGIN_HIST INSERT (1 transaction)
     * - 실패(loginRsltCd="F") : MEM_LOGIN_HIST INSERT 만 수행
     */
    void saveLoginHistory(MemberVO member, String userId,
                          String regLoginTypCd, String loginRsltCd, String failRsnCd,
                          String loginIp, String sessionId, String userAgent);
}
