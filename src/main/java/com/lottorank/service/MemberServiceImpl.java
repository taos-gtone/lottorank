package com.lottorank.service;

import com.lottorank.mapper.MemberMapper;
import com.lottorank.vo.MemberVO;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}
