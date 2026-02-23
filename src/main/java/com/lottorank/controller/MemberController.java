package com.lottorank.controller;

import com.lottorank.service.MemberService;
import com.lottorank.vo.MemberVO;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.net.InetAddress;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private MemberService memberService;

    @GetMapping("/join")
    public String joinForm() {
        return "member/join";
    }

    @GetMapping("/login")
    public String loginForm() {
        return "member/login";
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
            member.setGender(gender);
            member.setRegIp(resolveIpv4(request));

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
