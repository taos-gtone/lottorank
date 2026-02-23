package com.lottorank.mapper;

import com.lottorank.vo.MemberVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MemberMapper {

    int insertMember(MemberVO member);

    int countByUserId(@Param("userId") String userId);
}
