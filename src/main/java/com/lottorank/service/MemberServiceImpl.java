package com.lottorank.service;

import com.lottorank.mapper.MemberMapper;
import com.lottorank.vo.LoginHistVO;
import com.lottorank.vo.MemberInfoChgHistVO;
import com.lottorank.vo.MemberVO;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

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
    public void joinBySocial(MemberVO member) {
        // 소셜 로그인 사용자는 비밀번호 직접 사용 안 함 → 랜덤 UUID를 해시하여 저장
        String randomPw = BCrypt.hashpw(UUID.randomUUID().toString(), BCrypt.gensalt());
        member.setUserPw(randomPw);
        memberMapper.insertMember(member);
    }

    @Override
    public MemberVO findBySocialId(String socialId) {
        return memberMapper.findBySocialId(socialId);
    }

    @Override
    public boolean isUserIdAvailable(String userId) {
        return memberMapper.countByUserId(userId) == 0;
    }

    @Override
    public boolean isNicknameBanned(String nickname) {
        return memberMapper.countBannedNicknameMatch(nickname) > 0;
    }

    @Override
    public boolean isNicknameAvailable(String nickname) {
        return memberMapper.countByNickname(nickname) == 0;
    }

    @Override
    public MemberVO login(String userId, String userPw) {
        MemberVO member = memberMapper.findByUserId(userId);
        if (member == null)                                            throw new LoginFailException("02"); // 없는 계정
        if (!BCrypt.checkpw(userPw, member.getUserPw()))               throw new LoginFailException("01"); // 비밀번호 불일치
        String sts = member.getAcctStsCd();
        if (!"01".equals(sts) && !"02".equals(sts))                    throw new LoginFailException("03"); // 계정 비활성
        return member;
    }

    @Override
    public MemberVO getMemberDetail(long memberNo) {
        return memberMapper.findMemberDetailByNo(memberNo);
    }

    @Override
    @Transactional
    public void updateMemberPw(long memberNo, String currentPw, String newPw, String chgIp) {
        MemberVO member = memberMapper.findMemberDetailByNo(memberNo);
        if (member == null) throw new IllegalArgumentException("존재하지 않는 회원입니다.");
        if (!BCrypt.checkpw(currentPw, member.getUserPw())) {
            throw new IllegalArgumentException("현재 비밀번호가 올바르지 않습니다.");
        }
        String newHashedPw = BCrypt.hashpw(newPw, BCrypt.gensalt());
        memberMapper.updateMemberPw(memberNo, newHashedPw);

        MemberInfoChgHistVO hist = new MemberInfoChgHistVO();
        hist.setMemberNo(memberNo);
        hist.setMemInfoChgFldCd("01");
        hist.setBeforeVal(member.getUserPw());
        hist.setAfterVal(newHashedPw);
        hist.setChgIp(chgIp);
        memberMapper.insertMemberInfoChgHist(hist);
    }

    @Override
    @Transactional
    public void updateMemberEmail(long memberNo, String emailId, String emailAddr, String chgIp) {
        MemberVO current = memberMapper.findMemberDetailByNo(memberNo);
        memberMapper.updateMemberEmail(memberNo, emailId, emailAddr);

        MemberInfoChgHistVO histId = new MemberInfoChgHistVO();
        histId.setMemberNo(memberNo);
        histId.setMemInfoChgFldCd("02");
        histId.setBeforeVal(current != null ? current.getEmailId() : null);
        histId.setAfterVal(emailId);
        histId.setChgIp(chgIp);
        memberMapper.insertMemberInfoChgHist(histId);

        MemberInfoChgHistVO histAddr = new MemberInfoChgHistVO();
        histAddr.setMemberNo(memberNo);
        histAddr.setMemInfoChgFldCd("03");
        histAddr.setBeforeVal(current != null ? current.getEmailAddr() : null);
        histAddr.setAfterVal(emailAddr);
        histAddr.setChgIp(chgIp);
        memberMapper.insertMemberInfoChgHist(histAddr);
    }

    @Override
    @Transactional
    public void updateMemberMobile(long memberNo, String mobileNo, String chgIp) {
        MemberVO current = memberMapper.findMemberDetailByNo(memberNo);
        memberMapper.updateMemberMobile(memberNo, mobileNo);

        MemberInfoChgHistVO hist = new MemberInfoChgHistVO();
        hist.setMemberNo(memberNo);
        hist.setMemInfoChgFldCd("04");
        hist.setBeforeVal(current != null ? current.getMobileNo() : null);
        hist.setAfterVal(mobileNo);
        hist.setChgIp(chgIp);
        memberMapper.insertMemberInfoChgHist(hist);
    }

    @Override
    public String findUserId(String userName, String email) {
        String[] parts = email != null ? email.split("@") : new String[]{};
        if (parts.length != 2) return null;
        return memberMapper.findUserIdByNameAndEmail(userName, parts[0], parts[1]);
    }

    @Override
    @Transactional
    public String resetPasswordTemp(String userId, String userName, String email, String chgIp) {
        String[] parts = email != null ? email.split("@") : new String[]{};
        if (parts.length != 2) return null;
        MemberVO member = memberMapper.findByUserIdAndNameAndEmail(userId, userName, parts[0], parts[1]);
        if (member == null) return null;

        String tempPw = generateTempPassword();
        String hashed = BCrypt.hashpw(tempPw, BCrypt.gensalt());

        // 1) 변경이력 INSERT (mem_info_chg_fld_cd = '05': 임시비밀번호 발급)
        MemberInfoChgHistVO hist = new MemberInfoChgHistVO();
        hist.setMemberNo(member.getMemberNo());
        hist.setMemInfoChgFldCd("05");
        hist.setBeforeVal(member.getUserPw());
        hist.setAfterVal(hashed);
        hist.setChgIp(chgIp);
        memberMapper.insertMemberInfoChgHist(hist);

        // 2) user_pw UPDATE + acct_sts_cd = '02' (임시비밀번호 발급 상태)
        memberMapper.updateMemberPwAndAcctSts(member.getMemberNo(), hashed, "02");

        return tempPw;
    }

    @Override
    @Transactional
    public void changeTempPassword(long memberNo, String newPw, String chgIp) {
        MemberVO member = memberMapper.findMemberDetailByNo(memberNo);
        if (member == null) throw new IllegalArgumentException("존재하지 않는 회원입니다.");

        String newHashed = BCrypt.hashpw(newPw, BCrypt.gensalt());

        // 1) 변경이력 INSERT (mem_info_chg_fld_cd = '01': 비밀번호 변경)
        MemberInfoChgHistVO hist = new MemberInfoChgHistVO();
        hist.setMemberNo(memberNo);
        hist.setMemInfoChgFldCd("01");
        hist.setBeforeVal(member.getUserPw());
        hist.setAfterVal(newHashed);
        hist.setChgIp(chgIp);
        memberMapper.insertMemberInfoChgHist(hist);

        // 2) user_pw UPDATE + acct_sts_cd = '01' (정상 상태 복구)
        memberMapper.updateMemberPwAndAcctSts(memberNo, newHashed, "01");
    }

    private String generateTempPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        java.security.SecureRandom rnd = new java.security.SecureRandom();
        StringBuilder sb = new StringBuilder(8);
        for (int i = 0; i < 8; i++) sb.append(chars.charAt(rnd.nextInt(chars.length())));
        return sb.toString();
    }

    /**
     * 로그인 결과를 하나의 트랜잭션으로 저장한다.
     * 성공: MEM_JOIN_INFO.last_login_at UPDATE + MEM_LOGIN_HIST INSERT
     * 실패: MEM_LOGIN_HIST INSERT 만 수행
     */
    @Override
    @Transactional
    public void saveLoginHistory(MemberVO member, String userId,
                                 String regLoginTypCd, String loginRsltCd, String failRsnCd,
                                 String loginIp, String sessionId, String userAgent) {
        // 1) 성공 시 최종 로그인 시각 UPDATE
        if ("S".equals(loginRsltCd) && member != null) {
            memberMapper.updateLastLoginAt(member.getMemberNo());
        }

        // 2) 로그인 이력 INSERT
        LoginHistVO hist = new LoginHistVO();
        hist.setMemberNo(member != null ? member.getMemberNo() : null);
        hist.setUserId(userId);
        hist.setRegLoginTypCd(regLoginTypCd);
        hist.setLoginRsltCd(loginRsltCd);
        hist.setFailRsnCd(failRsnCd);
        hist.setLoginIp(loginIp);
        hist.setSessionId(sessionId);
        hist.setUserAgent(userAgent);
        memberMapper.insertLoginHist(hist);
    }
}
