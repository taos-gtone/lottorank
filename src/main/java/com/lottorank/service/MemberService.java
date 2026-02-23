package com.lottorank.service;

import com.lottorank.vo.MemberVO;

public interface MemberService {

    void join(MemberVO member);

    boolean isUserIdAvailable(String userId);
}
