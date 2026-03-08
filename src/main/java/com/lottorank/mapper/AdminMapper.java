package com.lottorank.mapper;

import com.lottorank.vo.AdminLoginHistVO;
import com.lottorank.vo.AdminLoginInfoVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface AdminMapper {

    /** admin_id로 관리자 정보 조회 */
    AdminLoginInfoVO selectAdminById(@Param("adminId") String adminId);

    /** 로그인 이력 등록 */
    void insertLoginHist(AdminLoginHistVO hist);

    /** 최종 로그인 시각 갱신 */
    void updateLastLoginAt(@Param("adminId") String adminId);

    /** 관리자 전용 댓글 삭제 (member_no 무관) */
    void deleteCommentByAdmin(@Param("commentNo") long commentNo);

    /** 게시글 댓글 수 동기화 */
    void syncCommentCnt(@Param("postNo") long postNo);
}
