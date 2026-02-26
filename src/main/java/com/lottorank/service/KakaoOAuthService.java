package com.lottorank.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.HashMap;
import java.util.Map;

@Service
public class KakaoOAuthService {

    private static final String AUTH_URL    = "https://kauth.kakao.com/oauth/authorize";
    private static final String TOKEN_URL   = "https://kauth.kakao.com/oauth/token";
    private static final String PROFILE_URL = "https://kapi.kakao.com/v2/user/me";

    @Value("${kakao.client-id}")
    private String clientId;

    @Value("${kakao.client-secret:}")
    private String clientSecret;

    @Value("${kakao.redirect-uri}")
    private String redirectUriPath;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper  = new ObjectMapper();

    /**
     * 카카오 인증 페이지 URL 생성
     */
    public String getAuthorizationUrl(String state, String baseUrl) {
        return UriComponentsBuilder.fromHttpUrl(AUTH_URL)
                .queryParam("client_id",    clientId)
                .queryParam("redirect_uri", baseUrl + redirectUriPath)
                .queryParam("response_type", "code")
                .queryParam("state",        state)
                .queryParam("prompt",       "login")
                .toUriString();
    }

    /**
     * 인증 코드를 액세스 토큰으로 교환 (POST 방식)
     */
    public String getAccessToken(String code, String baseUrl) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("grant_type",   "authorization_code");
        body.add("client_id",    clientId);
        body.add("redirect_uri", baseUrl + redirectUriPath);
        body.add("code",         code);
        if (clientSecret != null && !clientSecret.isBlank()) {
            body.add("client_secret", clientSecret);
        }

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(body, headers);

        try {
            ResponseEntity<String> response =
                    restTemplate.postForEntity(TOKEN_URL, entity, String.class);
            JsonNode root = objectMapper.readTree(response.getBody());
            return root.path("access_token").asText(null);
        } catch (Exception e) {
            throw new RuntimeException("카카오 액세스 토큰 획득 실패", e);
        }
    }

    /**
     * 액세스 토큰으로 카카오 사용자 프로필 조회
     * @return socialId, nickname, userName, emailId, emailAddr, birthDate, genderCd 포함 Map
     */
    public Map<String, String> getUserProfile(String accessToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        HttpEntity<Void> entity = new HttpEntity<>(headers);

        try {
            ResponseEntity<String> response =
                    restTemplate.exchange(PROFILE_URL, HttpMethod.GET, entity, String.class);
            JsonNode root    = objectMapper.readTree(response.getBody());
            JsonNode account = root.path("kakao_account");
            JsonNode profile = account.path("profile");

            Map<String, String> result = new HashMap<>();

            // socialId: 네이버 ID와 충돌 방지를 위해 "K_" 접두사 사용
            result.put("socialId", "K_" + root.path("id").asText(""));
            result.put("nickname", profile.path("nickname").asText(""));

            // 비즈 앱 전환 후 수집 가능한 항목 (현재 비즈 앱 아닌 경우 빈 문자열)
            result.put("userName", account.path("name").asText(""));
            result.put("genderCd", mapGender(account.path("gender").asText("")));
            result.put("birthDate", buildBirthDate(account));
            result.put("mobileNo", account.path("phone_number").asText("").replaceAll("[^0-9]", ""));

            // 이메일 분리
            String email = account.path("email").asText("");
            if (email.contains("@")) {
                result.put("emailId",   email.substring(0, email.indexOf('@')));
                result.put("emailAddr", email.substring(email.indexOf('@') + 1));
            } else {
                result.put("emailId",   "");
                result.put("emailAddr", "");
            }

            return result;
        } catch (Exception e) {
            throw new RuntimeException("카카오 프로필 조회 실패", e);
        }
    }

    /** 카카오 gender ("male"/"female") → MemberVO genderCd ("M"/"F") 변환 */
    private String mapGender(String gender) {
        if ("male".equalsIgnoreCase(gender))   return "M";
        if ("female".equalsIgnoreCase(gender)) return "F";
        return "";
    }

    /** 생년월일 조합: birthyear(1990) + birthday(0101) → 19900101 */
    private String buildBirthDate(JsonNode account) {
        String year = account.path("birthyear").asText("");
        String bday = account.path("birthday").asText("").replace("-", "");
        if (!year.isEmpty() && !bday.isEmpty()) return year + bday;
        return "";
    }
}
