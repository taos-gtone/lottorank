package com.lottorank.mapper;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SampleMapper {
    String selectCurrentTime();
}
