package com.lottorank.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.HashMap;
import java.util.Map;

@Service
public class NaverOAuthService {

    private static final String AUTH_URL    = "https://nid.naver.com/oauth2.0/authorize";
    private static final String TOKEN_URL   = "https://nid.naver.com/oauth2.0/token";
    private static final String PROFILE_URL = "https://openapi.naver.com/v1/nid/me";

    @Value("${naver.client-id}")
    private String clientId;

    @Value("${naver.client-secret}")
    private String clientSecret;

    @Value("${naver.redirect-uri}")
    private String redirectUriPath;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper  = new ObjectMapper();

    /**
     * 네이버 인증 페이지 URL 생성
     * @param state  CSRF 방지용 랜덤 상태값
     * @param baseUrl 요청 서버의 baseUrl (scheme+host+port+contextPath)
     */
    public String getAuthorizationUrl(String state, String baseUrl) {
        return UriComponentsBuilder.fromHttpUrl(AUTH_URL)
                .queryParam("response_type", "code")
                .queryParam("client_id", clientId)
                .queryParam("redirect_uri", baseUrl + redirectUriPath)
                .queryParam("state", state)
                .toUriString();
    }

    /**
     * 인증 코드를 액세스 토큰으로 교환
     * @return 액세스 토큰 문자열
     */
    public String getAccessToken(String code, String state, String baseUrl) {
        String url = UriComponentsBuilder.fromHttpUrl(TOKEN_URL)
                .queryParam("grant_type", "authorization_code")
                .queryParam("client_id", clientId)
                .queryParam("client_secret", clientSecret)
                .queryParam("redirect_uri", baseUrl + redirectUriPath)
                .queryParam("code", code)
                .queryParam("state", state)
                .toUriString();

        try {
            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
            JsonNode root = objectMapper.readTree(response.getBody());
            return root.path("access_token").asText(null);
        } catch (Exception e) {
            throw new RuntimeException("네이버 액세스 토큰 획득 실패", e);
        }
    }

    /**
     * 액세스 토큰으로 네이버 사용자 프로필 조회
     * @return socialId, userName, nickname, emailId, emailAddr, birthDate, genderCd 포함 Map
     */
    public Map<String, String> getUserProfile(String accessToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        HttpEntity<Void> entity = new HttpEntity<>(headers);

        try {
            ResponseEntity<String> response =
                    restTemplate.exchange(PROFILE_URL, HttpMethod.GET, entity, String.class);
            JsonNode root     = objectMapper.readTree(response.getBody());
            JsonNode profile  = root.path("response");

            Map<String, String> result = new HashMap<>();
            result.put("socialId",  profile.path("id").asText(""));
            result.put("userName",  profile.path("name").asText(""));
            result.put("nickname",  profile.path("nickname").asText(""));
            result.put("genderCd",  profile.path("gender").asText(""));

            // 이메일 분리
            String email = profile.path("email").asText("");
            if (email.contains("@")) {
                result.put("emailId",   email.substring(0, email.indexOf('@')));
                result.put("emailAddr", email.substring(email.indexOf('@') + 1));
            } else {
                result.put("emailId",   "");
                result.put("emailAddr", "");
            }

            // 생년월일 조합: birthyear(1990) + birthday(10-01) → 19901001
            String birthYear = profile.path("birthyear").asText("");
            String birthday  = profile.path("birthday").asText("").replace("-", "");
            result.put("birthDate", birthYear + birthday); // 예: 19901001

            return result;
        } catch (Exception e) {
            throw new RuntimeException("네이버 프로필 조회 실패", e);
        }
    }
}
