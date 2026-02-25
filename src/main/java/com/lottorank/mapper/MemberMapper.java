package com.lottorank.mapper;

import com.lottorank.vo.LoginHistVO;
import com.lottorank.vo.MemberVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MemberMapper {

    int insertMember(MemberVO member);

    int countByUserId(@Param("userId") String userId);

    MemberVO findByUserId(@Param("userId") String userId);

    /** 소셜 ID로 기존 회원 조회 (소셜 중복 가입 체크) */
    MemberVO findBySocialId(@Param("socialId") String socialId);

    /** 로그인 성공 시 최종 로그인 시각 갱신 */
    void updateLastLoginAt(@Param("memberNo") long memberNo);

    /** 로그인 이력 저장 (성공/실패 공통) */
    void insertLoginHist(LoginHistVO hist);
}
