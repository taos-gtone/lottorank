package com.lottorank.mapper;

import com.lottorank.vo.LoginHistVO;
import com.lottorank.vo.MemberInfoChgHistVO;
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

    /** 마이페이지: 회원 상세 정보 조회 */
    MemberVO findMemberDetailByNo(@Param("memberNo") long memberNo);

    /** 마이페이지: 비밀번호 변경 */
    void updateMemberPw(@Param("memberNo") long memberNo, @Param("userPw") String userPw);

    /** 마이페이지: 이메일 변경 */
    void updateMemberEmail(@Param("memberNo") long memberNo,
                           @Param("emailId") String emailId,
                           @Param("emailAddr") String emailAddr);

    /** 마이페이지: 휴대전화번호 변경 */
    void updateMemberMobile(@Param("memberNo") long memberNo, @Param("mobileNo") String mobileNo);

    /** 회원정보 변경이력 저장 */
    void insertMemberInfoChgHist(MemberInfoChgHistVO hist);

    /** 아이디 찾기: 이름 + 이메일로 userId 조회 */
    String findUserIdByNameAndEmail(@Param("userName")  String userName,
                                    @Param("emailId")   String emailId,
                                    @Param("emailAddr") String emailAddr);

    /** 비밀번호 찾기: userId + 이름 + 이메일로 회원 조회 */
    MemberVO findByUserIdAndNameAndEmail(@Param("userId")    String userId,
                                         @Param("userName")  String userName,
                                         @Param("emailId")   String emailId,
                                         @Param("emailAddr") String emailAddr);

    /** 비밀번호 찾기: 임시 비밀번호 업데이트 + 계정상태 변경 */
    void updateMemberPwAndAcctSts(@Param("memberNo")   long   memberNo,
                                   @Param("userPw")    String userPw,
                                   @Param("acctStsCd") String acctStsCd);

    /** 회원 등급명 조회 (COM_CODE_DTL C012 코드 JOIN) */
    String findGradeNmByMemberNo(@Param("memberNo") long memberNo);
}
