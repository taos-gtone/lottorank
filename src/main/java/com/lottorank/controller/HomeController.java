package com.lottorank.controller;

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

    @GetMapping("/")
    public String index(Model model, HttpServletRequest request) {
        LottoRoundResult latestResult = lottoService.getLatestResult();
        int predictionRoundNo = (latestResult != null) ? latestResult.getRoundNo() + 1 : 1;
        model.addAttribute("serverTime", sampleService.getCurrentTime());
        model.addAttribute("message", "LottoRank - Spring MVC + MyBatis 환경 구성 완료!");
        model.addAttribute("latestResult", latestResult);
        model.addAttribute("predictionRoundNo", predictionRoundNo);
        model.addAttribute("allRankingList", rankingService.getAllRanking());
        model.addAttribute("recent5RankingList", rankingService.getRecent5Ranking());

        // 로그인 회원 히어로 미니 통계용 최신 랭킹 조회
        HttpSession session = request.getSession(false);
        if (session != null) {
            Long memberNo = (Long) session.getAttribute("loginMemberNo");
            if (memberNo != null) {
                model.addAttribute("myHeroRanking", rankingService.getMyLatestAllRanking(memberNo));
            }
        }
        return "index";
    }
}
