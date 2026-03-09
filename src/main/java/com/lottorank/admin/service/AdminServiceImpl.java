package com.lottorank.admin.service;

import com.lottorank.mapper.AdminMapper;
import com.lottorank.vo.AdminLoginHistVO;
import com.lottorank.vo.AdminLoginInfoVO;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminMapper adminMapper;

    @Override
    public AdminLoginInfoVO login(String adminId, String adminPw,
                                  String loginIp, String userAgent)
            throws AdminLoginFailException {

        AdminLoginInfoVO admin = adminMapper.selectAdminById(adminId);

        // 없는 계정
        if (admin == null) {
            saveHist(adminId, "F", "02", loginIp, userAgent); // 실패, 없는계정
            throw new AdminLoginFailException("02", "존재하지 않는 관리자 계정입니다.");
        }

        // 비밀번호 불일치
        if (!BCrypt.checkpw(adminPw, admin.getAdminPw())) {
            saveHist(adminId, "F", "01", loginIp, userAgent); // 실패, 비밀번호불일치
            throw new AdminLoginFailException("01", "비밀번호가 올바르지 않습니다.");
        }

        // 로그인 성공
        saveHist(adminId, "S", null, loginIp, userAgent);
        adminMapper.updateLastLoginAt(adminId);
        return admin;
    }

    @Override
    public void changePassword(String adminId, String currentPw, String newPw) {
        AdminLoginInfoVO admin = adminMapper.selectAdminById(adminId);
        if (admin == null || !BCrypt.checkpw(currentPw, admin.getAdminPw())) {
            throw new IllegalArgumentException("현재 비밀번호가 올바르지 않습니다.");
        }
        String hashed = BCrypt.hashpw(newPw, BCrypt.gensalt());
        adminMapper.updateAdminPassword(adminId, hashed);
    }

    private void saveHist(String adminId, String rsltCd, String failRsnCd,
                          String loginIp, String userAgent) {
        AdminLoginHistVO hist = new AdminLoginHistVO();
        hist.setAdminId(adminId);
        hist.setLoginRsltCd(rsltCd);
        hist.setFailRsnCd(failRsnCd);
        hist.setLoginIp(loginIp);
        hist.setUserAgent(userAgent);
        adminMapper.insertLoginHist(hist);
    }
}
