package com.lottorank.service;

import com.lottorank.mapper.MemberMapper;
import com.lottorank.vo.LoginHistVO;
import com.lottorank.vo.MemberVO;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberMapper memberMapper;

    @Override
    public void join(MemberVO member) {
        String hashedPw = BCrypt.hashpw(member.getUserPw(), BCrypt.gensalt());
        member.setUserPw(hashedPw);
        memberMapper.insertMember(member);
    }

    @Override
    public boolean isUserIdAvailable(String userId) {
        return memberMapper.countByUserId(userId) == 0;
    }

    @Override
    public MemberVO login(String userId, String userPw) {
        MemberVO member = memberMapper.findByUserId(userId);
        if (member == null)                              throw new LoginFailException("02"); // 없는 계정
        if (!BCrypt.checkpw(userPw, member.getUserPw())) throw new LoginFailException("01"); // 비밀번호 불일치
        if (member.getAcctStsCd() != 1)                  throw new LoginFailException("03"); // 계정 비활성
        return member;
    }

    /**
     * 로그인 결과를 하나의 트랜잭션으로 저장한다.
     * 성공: MEM_JOIN_INFO.last_login_at UPDATE + MEM_LOGIN_HIST INSERT
     * 실패: MEM_LOGIN_HIST INSERT 만 수행
     */
    @Override
    @Transactional
    public void saveLoginHistory(MemberVO member, String userId,
                                 String loginTypCd, String loginRsltCd, String failRsnCd,
                                 String loginIp, String sessionId, String userAgent) {
        // 1) 성공 시 최종 로그인 시각 UPDATE
        if ("S".equals(loginRsltCd) && member != null) {
            memberMapper.updateLastLoginAt(member.getMemberNo());
        }

        // 2) 로그인 이력 INSERT
        LoginHistVO hist = new LoginHistVO();
        hist.setMemberNo(member != null ? member.getMemberNo() : null);
        hist.setUserId(userId);
        hist.setLoginTypCd(loginTypCd);
        hist.setLoginRsltCd(loginRsltCd);
        hist.setFailRsnCd(failRsnCd);
        hist.setLoginIp(loginIp);
        hist.setSessionId(sessionId);
        hist.setUserAgent(userAgent);
        memberMapper.insertLoginHist(hist);
    }
}
