package com.lottorank.service;

import com.lottorank.mapper.SampleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SampleService {

    @Autowired
    private SampleMapper sampleMapper;

    public String getCurrentTime() {
        return sampleMapper.selectCurrentTime();
    }
}
