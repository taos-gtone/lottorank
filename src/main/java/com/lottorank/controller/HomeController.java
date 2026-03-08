package com.lottorank.controller;

import com.lottorank.mapper.MemberMapper;
import com.lottorank.mapper.PredictMapper;
import com.lottorank.service.LottoService;
import com.lottorank.service.RankingService;
import com.lottorank.service.SampleService;
import com.lottorank.vo.LottoRoundResult;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @Autowired
    private SampleService sampleService;

    @Autowired
    private LottoService lottoService;

    @Autowired
    private RankingService rankingService;

    @Autowired
    private MemberMapper memberMapper;

    @Autowired
    private PredictMapper predictMapper;

    @GetMapping("/")
    public String index(Model model, HttpServletRequest request) {
        LottoRoundResult latestResult = lottoService.getLatestResult();
        int latestRoundNo     = (latestResult != null) ? latestResult.getRoundNo() : 0;
        int predictionRoundNo = latestRoundNo + 1;
        model.addAttribute("serverTime", sampleService.getCurrentTime());
        model.addAttribute("message", "LottoRank - Spring MVC + MyBatis 환경 구성 완료!");
        model.addAttribute("latestResult", latestResult);
        model.addAttribute("predictionRoundNo", predictionRoundNo);
        model.addAttribute("allRankingList", rankingService.getAllRanking());
        model.addAttribute("recent5RankingList", rankingService.getRecent5Ranking());
        // 이번 회차(max+1)와 지난 회차(max) 예측 참여 수
        model.addAttribute("currentRoundPredCount", predictMapper.countByRound(predictionRoundNo));
        model.addAttribute("lastRoundPredCount",    latestRoundNo > 0 ? predictMapper.countByRound(latestRoundNo) : 0);
        // 지난 회차(max) 전체 적중률
        Double hitRate = predictMapper.getLastRoundHitRate();
        model.addAttribute("lastRoundHitRate", hitRate != null ? hitRate : 0.0);

        // 로그인 회원 히어로 미니 통계용 최신 랭킹 조회
        HttpSession session = request.getSession(false);
        if (session != null) {
            Long memberNo = (Long) session.getAttribute("loginMemberNo");
            if (memberNo != null) {
                model.addAttribute("myHeroRanking", rankingService.getMyLatestAllRanking(memberNo));
                model.addAttribute("myGradeNm", memberMapper.findGradeNmByMemberNo(memberNo));
            }
        }
        return "index";
    }

    @GetMapping("/sitemap")
    public String sitemap() {
        return "common/sitemap";
    }
}
