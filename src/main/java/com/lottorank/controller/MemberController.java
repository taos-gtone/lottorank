package com.lottorank.controller;

import com.lottorank.service.KakaoOAuthService;
import com.lottorank.service.LoginFailException;
import com.lottorank.service.MemberService;
import com.lottorank.service.NaverOAuthService;
import com.lottorank.service.PredictService;
import com.lottorank.service.RankingService;
import com.lottorank.vo.MemberVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private NaverOAuthService naverOAuthService;

    @Autowired
    private KakaoOAuthService kakaoOAuthService;

    @Autowired
    private RankingService rankingService;

    @Autowired
    private PredictService predictService;

    @GetMapping("/join")
    public String joinForm() {
        return "member/join";
    }

    @GetMapping("/login")
    public String loginForm(HttpServletRequest request) {
        // 이미 로그인된 경우 메인으로 리다이렉트
        HttpSession existing = request.getSession(false);
        if (existing != null && existing.getAttribute("loginUser") != null) {
            return "redirect:/";
        }
        return "member/login";
    }

    @PostMapping("/login")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> login(
            @RequestParam String userId,
            @RequestParam String userPw,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        String loginIp       = resolveIpv4(request);
        String userAgent     = request.getHeader("User-Agent");
        String regLoginTypCd = "I"; // 아이디 로그인

        MemberVO member;
        try {
            member = memberService.login(userId, userPw);
        } catch (LoginFailException e) {
            // 로그인 실패 이력 저장 (실패사유코드 포함)
            memberService.saveLoginHistory(null, userId, regLoginTypCd,
                    "F", e.getFailRsnCd(), loginIp, null, userAgent);
            result.put("success", false);
            result.put("message", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return ResponseEntity.ok(result);
        }

        // 세션 생성
        HttpSession session = request.getSession(true);
        session.setMaxInactiveInterval(600); // 10분
        long expiry = System.currentTimeMillis() + 600_000L;
        session.setAttribute("loginUser", member.getUserId());
        session.setAttribute("loginNickname", member.getNickname());
        session.setAttribute("loginMemberNo", member.getMemberNo());
        session.setAttribute("sessionExpiry", expiry);

        // 로그인 성공 이력 저장 (트랜잭션: last_login_at UPDATE + 이력 INSERT)
        memberService.saveLoginHistory(member, userId, regLoginTypCd,
                "S", null, loginIp, session.getId(), userAgent);

        result.put("success", true);
        result.put("message", "로그인 성공!");
        result.put("sessionExpiry", expiry);
        result.put("nickname", member.getNickname());
        return ResponseEntity.ok(result);
    }

    @GetMapping("/mypage")
    public String mypage(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            return "redirect:/member/login?redirect=/member/mypage";
        }
        Long memberNo = (Long) session.getAttribute("loginMemberNo");
        int nextRoundNo = rankingService.getNextPredRoundNo();
        model.addAttribute("memberInfo", memberService.getMemberDetail(memberNo));
        model.addAttribute("myAllRankingList", rankingService.getMyAllRankingHistory(memberNo));
        model.addAttribute("myRecent5RankingList", rankingService.getMyRecent5RankingHistory(memberNo));
        model.addAttribute("myPredHistory", predictService.getMyPredHistory(memberNo));
        model.addAttribute("nextRoundNo", nextRoundNo);
        model.addAttribute("nextRoundPred", predictService.getPrediction(nextRoundNo, memberNo));
        return "member/mypage";
    }

    @PostMapping("/mypage/updatePw")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updatePw(
            @RequestParam String currentPw,
            @RequestParam String newPw,
            @RequestParam String newPwConfirm,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }
        if (!newPw.equals(newPwConfirm)) {
            result.put("success", false);
            result.put("message", "새 비밀번호와 확인 비밀번호가 일치하지 않습니다.");
            return ResponseEntity.ok(result);
        }
        try {
            Long memberNo = (Long) session.getAttribute("loginMemberNo");
            memberService.updateMemberPw(memberNo, currentPw, newPw, resolveIpv4(request));
            result.put("success", true);
            result.put("message", "비밀번호가 변경되었습니다.");
        } catch (IllegalArgumentException e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return ResponseEntity.ok(result);
    }

    @PostMapping("/mypage/updateEmail")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateEmail(
            @RequestParam String emailId,
            @RequestParam String emailAddr,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }
        try {
            Long memberNo = (Long) session.getAttribute("loginMemberNo");
            memberService.updateMemberEmail(memberNo, emailId, emailAddr, resolveIpv4(request));
            result.put("success", true);
            result.put("message", "이메일이 변경되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "이메일 변경 중 오류가 발생했습니다.");
        }
        return ResponseEntity.ok(result);
    }

    @PostMapping("/mypage/updateMobile")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateMobile(
            @RequestParam String mobileNo,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }
        try {
            Long memberNo = (Long) session.getAttribute("loginMemberNo");
            memberService.updateMemberMobile(memberNo, mobileNo, resolveIpv4(request));
            result.put("success", true);
            result.put("message", "휴대전화번호가 변경되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "휴대전화번호 변경 중 오류가 발생했습니다.");
        }
        return ResponseEntity.ok(result);
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/";
    }

    @PostMapping("/extend")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> extend(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            result.put("success", false);
            result.put("message", "로그인 세션이 없습니다.");
            return ResponseEntity.ok(result);
        }
        session.setMaxInactiveInterval(600);
        long expiry = System.currentTimeMillis() + 600_000L;
        session.setAttribute("sessionExpiry", expiry);
        result.put("success", true);
        result.put("sessionExpiry", expiry);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/join")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> join(
            @RequestParam String userId,
            @RequestParam String userPw,
            @RequestParam String userName,
            @RequestParam String nickname,
            @RequestParam String emailId,
            @RequestParam String emailDomain,
            @RequestParam(required = false) String birthDate,
            @RequestParam String gender,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();

        try {
            if (!memberService.isUserIdAvailable(userId)) {
                result.put("success", false);
                result.put("message", "이미 사용 중인 아이디입니다.");
                return ResponseEntity.ok(result);
            }

            MemberVO member = new MemberVO();
            member.setUserId(userId);
            member.setUserPw(userPw);
            member.setUserName(userName);
            member.setNickname(nickname);
            member.setEmailId(emailId);
            member.setEmailAddr(emailDomain);

            if (birthDate != null && !birthDate.isEmpty()) {
                member.setBirthDate(birthDate.replace("-", ""));
            }
            member.setGenderCd(gender);
            member.setRegIp(resolveIpv4(request));
            member.setRegLoginTypCd("I"); // 아이디 회원가입

            memberService.join(member);

            result.put("success", true);
            result.put("message", "회원가입이 완료되었습니다.");

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "가입 처리 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    @GetMapping("/checkId")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkId(@RequestParam String userId) {
        Map<String, Object> result = new HashMap<>();
        result.put("available", memberService.isUserIdAvailable(userId));
        return ResponseEntity.ok(result);
    }

    // ══════════════════════════════════════════════════════════════════
    //  네이버 OAuth 공통 유틸
    // ══════════════════════════════════════════════════════════════════

    /** 네이버 OAuth 시작 (intent: "join" 또는 "login") */
    private String naverOAuthStart(HttpServletRequest request, String intent) {
        String state = UUID.randomUUID().toString().replace("-", "");
        HttpSession session = request.getSession(true);
        session.setAttribute("naverOAuthState",  state);
        session.setAttribute("naverOAuthIntent", intent);

        String baseUrl = resolveBaseUrl(request);
        String naverAuthUrl = naverOAuthService.getAuthorizationUrl(state, baseUrl);
        return "redirect:" + naverAuthUrl;
    }

    // ══════════════════════════════════════════════════════════════════
    //  네이버 OAuth 회원가입
    // ══════════════════════════════════════════════════════════════════

    /** 가입 1단계: 네이버 인증 페이지로 리다이렉트 */
    @GetMapping("/naver/join")
    public String naverJoinRedirect(HttpServletRequest request) {
        return naverOAuthStart(request, "join");
    }

    // ══════════════════════════════════════════════════════════════════
    //  네이버 OAuth 로그인
    // ══════════════════════════════════════════════════════════════════

    /** 로그인 1단계: 네이버 인증 페이지로 리다이렉트 */
    @GetMapping("/naver/login-start")
    public String naverLoginStart(
            @RequestParam(required = false) String redirect,
            HttpServletRequest request) {
        // 이미 로그인된 경우 메인으로 리다이렉트
        HttpSession existing = request.getSession(false);
        if (existing != null && existing.getAttribute("loginUser") != null) {
            return "redirect:/";
        }
        // 로그인 후 돌아갈 URL을 세션에 저장
        if (redirect != null && !redirect.isEmpty()) {
            HttpSession session = request.getSession(true);
            session.setAttribute("loginRedirect", redirect);
        }
        return naverOAuthStart(request, "login");
    }

    // ══════════════════════════════════════════════════════════════════
    //  네이버 OAuth 공통 콜백
    // ══════════════════════════════════════════════════════════════════

    /** 공통 콜백: intent에 따라 가입/로그인 분기 */
    @GetMapping("/naver/callback")
    public String naverCallback(
            @RequestParam(required = false) String code,
            @RequestParam(required = false) String state,
            @RequestParam(required = false) String error,
            HttpServletRequest request) {

        // intent 먼저 읽기 (오류 시 올바른 페이지로 리다이렉트하기 위함)
        HttpSession session = request.getSession(false);
        String intent = (session != null) ? (String) session.getAttribute("naverOAuthIntent") : null;
        boolean isLogin = "login".equals(intent);
        String errorBase = isLogin ? "/member/login" : "/member/join";

        // 사용자가 네이버 로그인 취소한 경우
        if (error != null || code == null) {
            return "redirect:" + errorBase + "?error=naver_cancel";
        }

        // state 검증 (CSRF 방지)
        String savedState = (session != null) ? (String) session.getAttribute("naverOAuthState") : null;
        if (savedState == null || !savedState.equals(state)) {
            return "redirect:" + errorBase + "?error=invalid_state";
        }
        session.removeAttribute("naverOAuthState");
        session.removeAttribute("naverOAuthIntent");

        try {
            String baseUrl    = resolveBaseUrl(request);
            String accessToken = naverOAuthService.getAccessToken(code, state, baseUrl);
            if (accessToken == null) {
                return "redirect:" + errorBase + "?error=naver_token_fail";
            }

            Map<String, String> profile = naverOAuthService.getUserProfile(accessToken);
            String socialId = profile.get("socialId");
            MemberVO member  = memberService.findBySocialId(socialId);

            if (isLogin) {
                // ── 로그인 처리 ──────────────────────────────────────
                if (member == null) {
                    return "redirect:/member/login?error=naver_not_registered";
                }
                if (member.getAcctStsCd() != 1) {
                    return "redirect:/member/login?error=naver_inactive";
                }

                // 세션 생성 (기존 ID 로그인과 동일한 구조)
                session.setMaxInactiveInterval(600);
                long expiry = System.currentTimeMillis() + 600_000L;
                session.setAttribute("loginUser",     member.getUserId());
                session.setAttribute("loginNickname", member.getNickname());
                session.setAttribute("loginMemberNo", member.getMemberNo());
                session.setAttribute("sessionExpiry", expiry);

                // 로그인 이력 저장 (reg_login_typ_cd = "N")
                memberService.saveLoginHistory(member, member.getUserId(), "N",
                        "S", null, resolveIpv4(request), session.getId(),
                        request.getHeader("User-Agent"));

                // 로그인 후 redirect URL 처리
                String loginRedirect = (String) session.getAttribute("loginRedirect");
                session.removeAttribute("loginRedirect");
                return "redirect:" + (loginRedirect != null ? loginRedirect : "/");

            } else {
                // ── 가입 처리 ────────────────────────────────────────
                if (member != null) {
                    return "redirect:/member/join?error=already_registered";
                }
                session.setAttribute("naverProfile", profile);
                return "redirect:/member/naver/join-form";
            }

        } catch (Exception e) {
            return "redirect:" + errorBase + "?error=naver_error";
        }
    }

    /** 3단계: 간편가입 폼 표시 (세션의 네이버 프로필 데이터 pre-fill) */
    @GetMapping("/naver/join-form")
    public String naverJoinForm(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("naverProfile") == null) {
            return "redirect:/member/join";
        }
        @SuppressWarnings("unchecked")
        Map<String, String> profile = (Map<String, String>) session.getAttribute("naverProfile");
        model.addAttribute("naverProfile", profile);
        return "member/naver-join";
    }

    /** 4단계: 네이버 회원가입 처리 */
    @PostMapping("/naver/join")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> naverJoin(
            @RequestParam String userId,
            @RequestParam String nickname,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("naverProfile") == null) {
            result.put("success", false);
            result.put("message", "세션이 만료되었습니다. 다시 시도해 주세요.");
            return ResponseEntity.ok(result);
        }

        @SuppressWarnings("unchecked")
        Map<String, String> profile = (Map<String, String>) session.getAttribute("naverProfile");

        try {
            if (!memberService.isUserIdAvailable(userId)) {
                result.put("success", false);
                result.put("message", "이미 사용 중인 아이디입니다.");
                return ResponseEntity.ok(result);
            }

            MemberVO member = new MemberVO();
            member.setUserId(userId);
            member.setUserName(profile.getOrDefault("userName", ""));
            member.setNickname(nickname);
            member.setEmailId(profile.getOrDefault("emailId", ""));
            member.setEmailAddr(profile.getOrDefault("emailAddr", ""));
            member.setBirthDate(profile.getOrDefault("birthDate", ""));
            member.setGenderCd(profile.getOrDefault("genderCd", ""));
            member.setMobileNo(profile.getOrDefault("mobileNo", ""));
            member.setRegIp(resolveIpv4(request));
            member.setRegLoginTypCd("N");
            member.setSocialId(profile.get("socialId"));

            memberService.joinBySocial(member);

            session.removeAttribute("naverProfile");
            result.put("success", true);
            result.put("message", "네이버 계정으로 가입이 완료되었습니다.");

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "가입 처리 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    // ══════════════════════════════════════════════════════════════════
    //  카카오 OAuth 공통 유틸
    // ══════════════════════════════════════════════════════════════════

    /** 카카오 OAuth 시작 (intent: "join" 또는 "login") */
    private String kakaoOAuthStart(HttpServletRequest request, String intent) {
        String state = UUID.randomUUID().toString().replace("-", "");
        HttpSession session = request.getSession(true);
        session.setAttribute("kakaoOAuthState",  state);
        session.setAttribute("kakaoOAuthIntent", intent);

        String baseUrl = resolveBaseUrl(request);
        String kakaoAuthUrl = kakaoOAuthService.getAuthorizationUrl(state, baseUrl);
        return "redirect:" + kakaoAuthUrl;
    }

    // ══════════════════════════════════════════════════════════════════
    //  카카오 OAuth 회원가입
    // ══════════════════════════════════════════════════════════════════

    /** 가입 1단계: 카카오 인증 페이지로 리다이렉트 */
    @GetMapping("/kakao/join")
    public String kakaoJoinRedirect(HttpServletRequest request) {
        return kakaoOAuthStart(request, "join");
    }

    // ══════════════════════════════════════════════════════════════════
    //  카카오 OAuth 로그인
    // ══════════════════════════════════════════════════════════════════

    /** 로그인 1단계: 카카오 인증 페이지로 리다이렉트 */
    @GetMapping("/kakao/login-start")
    public String kakaoLoginStart(
            @RequestParam(required = false) String redirect,
            HttpServletRequest request) {
        HttpSession existing = request.getSession(false);
        if (existing != null && existing.getAttribute("loginUser") != null) {
            return "redirect:/";
        }
        if (redirect != null && !redirect.isEmpty()) {
            HttpSession session = request.getSession(true);
            session.setAttribute("loginRedirect", redirect);
        }
        return kakaoOAuthStart(request, "login");
    }

    // ══════════════════════════════════════════════════════════════════
    //  카카오 OAuth 공통 콜백
    // ══════════════════════════════════════════════════════════════════

    /** 공통 콜백: intent에 따라 가입/로그인 분기 */
    @GetMapping("/kakao/callback")
    public String kakaoCallback(
            @RequestParam(required = false) String code,
            @RequestParam(required = false) String state,
            @RequestParam(required = false) String error,
            HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        String intent  = (session != null) ? (String) session.getAttribute("kakaoOAuthIntent") : null;
        boolean isLogin = "login".equals(intent);
        String errorBase = isLogin ? "/member/login" : "/member/join";

        // 사용자가 카카오 로그인 취소한 경우
        if (error != null || code == null) {
            return "redirect:" + errorBase + "?error=kakao_cancel";
        }

        // state 검증 (CSRF 방지)
        String savedState = (session != null) ? (String) session.getAttribute("kakaoOAuthState") : null;
        if (savedState == null || !savedState.equals(state)) {
            return "redirect:" + errorBase + "?error=invalid_state";
        }
        session.removeAttribute("kakaoOAuthState");
        session.removeAttribute("kakaoOAuthIntent");

        try {
            String baseUrl    = resolveBaseUrl(request);
            String accessToken = kakaoOAuthService.getAccessToken(code, baseUrl);
            if (accessToken == null) {
                return "redirect:" + errorBase + "?error=kakao_token_fail";
            }

            Map<String, String> profile = kakaoOAuthService.getUserProfile(accessToken);
            String socialId = profile.get("socialId");
            MemberVO member  = memberService.findBySocialId(socialId);

            if (isLogin) {
                // ── 로그인 처리 ──────────────────────────────────────
                if (member == null) {
                    return "redirect:/member/login?error=kakao_not_registered";
                }
                if (member.getAcctStsCd() != 1) {
                    return "redirect:/member/login?error=kakao_inactive";
                }

                session.setMaxInactiveInterval(600);
                long expiry = System.currentTimeMillis() + 600_000L;
                session.setAttribute("loginUser",     member.getUserId());
                session.setAttribute("loginNickname", member.getNickname());
                session.setAttribute("loginMemberNo", member.getMemberNo());
                session.setAttribute("sessionExpiry", expiry);

                // 로그인 이력 저장 (reg_login_typ_cd = "K")
                memberService.saveLoginHistory(member, member.getUserId(), "K",
                        "S", null, resolveIpv4(request), session.getId(),
                        request.getHeader("User-Agent"));

                String loginRedirect = (String) session.getAttribute("loginRedirect");
                session.removeAttribute("loginRedirect");
                return "redirect:" + (loginRedirect != null ? loginRedirect : "/");

            } else {
                // ── 가입 처리 ────────────────────────────────────────
                if (member != null) {
                    return "redirect:/member/join?error=kakao_already_registered";
                }
                session.setAttribute("kakaoProfile", profile);
                return "redirect:/member/kakao/join-form";
            }

        } catch (Exception e) {
            return "redirect:" + errorBase + "?error=kakao_error";
        }
    }

    /** 3단계: 카카오 간편가입 폼 표시 */
    @GetMapping("/kakao/join-form")
    public String kakaoJoinForm(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("kakaoProfile") == null) {
            return "redirect:/member/join";
        }
        @SuppressWarnings("unchecked")
        Map<String, String> profile = (Map<String, String>) session.getAttribute("kakaoProfile");
        model.addAttribute("kakaoProfile", profile);
        return "member/kakao-join";
    }

    /** 4단계: 카카오 회원가입 처리 */
    @PostMapping("/kakao/join")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> kakaoJoin(
            @RequestParam String userId,
            @RequestParam String userName,
            @RequestParam String nickname,
            @RequestParam String emailId,
            @RequestParam String emailDomain,
            @RequestParam(required = false) String birthDate,
            @RequestParam String gender,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("kakaoProfile") == null) {
            result.put("success", false);
            result.put("message", "세션이 만료되었습니다. 다시 시도해 주세요.");
            return ResponseEntity.ok(result);
        }

        @SuppressWarnings("unchecked")
        Map<String, String> profile = (Map<String, String>) session.getAttribute("kakaoProfile");

        try {
            if (!memberService.isUserIdAvailable(userId)) {
                result.put("success", false);
                result.put("message", "이미 사용 중인 아이디입니다.");
                return ResponseEntity.ok(result);
            }

            MemberVO member = new MemberVO();
            member.setUserId(userId);
            member.setUserName(userName);
            member.setNickname(nickname);
            member.setEmailId(emailId);
            member.setEmailAddr(emailDomain);
            if (birthDate != null && !birthDate.isEmpty()) {
                member.setBirthDate(birthDate.replace("-", ""));
            }
            member.setGenderCd(gender);
            member.setMobileNo(profile.getOrDefault("mobileNo", ""));
            member.setRegIp(resolveIpv4(request));
            member.setRegLoginTypCd("K");
            member.setSocialId(profile.get("socialId"));

            memberService.joinBySocial(member);

            session.removeAttribute("kakaoProfile");
            result.put("success", true);
            result.put("message", "카카오 계정으로 가입이 완료되었습니다.");

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "가입 처리 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /** 요청에서 scheme+host+port+contextPath 추출 */
    private String resolveBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int port = request.getServerPort();
        String contextPath = request.getContextPath();

        StringBuilder sb = new StringBuilder(scheme).append("://").append(serverName);
        if (("http".equals(scheme) && port != 80) || ("https".equals(scheme) && port != 443)) {
            sb.append(":").append(port);
        }
        sb.append(contextPath);
        return sb.toString();
    }

    /** 모든 IPv6 루프백 및 IPv6-mapped IPv4를 IPv4 문자열로 변환 */
    private String resolveIpv4(HttpServletRequest request) {
        String ip = request.getRemoteAddr();
        if (ip == null) return "";
        /*
        try {
            InetAddress addr = InetAddress.getByName(ip);
            if (addr.isLoopbackAddress()) {
                return "127.0.0.1";
            }
        } catch (Exception ignored) {}
        */
        // IPv6-mapped IPv4: ::ffff:x.x.x.x
        if (ip.regionMatches(true, 0, "::ffff:", 0, 7)) {
            return ip.substring(7);
        }
        return ip;
    }
}
