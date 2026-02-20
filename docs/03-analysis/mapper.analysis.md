# Mapper Gap 분석 보고서 - LottoRank

> **Feature**: mapper
> **Phase**: Check (Gap Analysis)
> **분석일**: 2026-02-20
> **프로젝트**: LottoRank (Spring MVC + MyBatis)

---

## 1. 분석 개요

| 항목 | 내용 |
|---|---|
| **분석 대상** | Mapper Layer (MyBatis) |
| **기준 문서** | `docs/implements_mandatory.txt` |
| **현재 구현** | `SampleMapper.java` + `SampleMapper.xml` |
| **전체 매칭률** | **6.25%** (1/16) |
| **핵심 기능 매칭률** | **0%** (0/11) |

---

## 2. 현재 구현 현황

### 구현된 Mapper (1개)

| # | 인터페이스 | 메서드 | XML 쿼리 | 비고 |
|---|---|---|---|---|
| 1 | `SampleMapper.java` | `selectCurrentTime()` | `SampleMapper.xml` | 테스트용 샘플 |

### 인프라 구성 현황

- Spring MVC 6.0.23 + MyBatis 3.5.16
- H2 DB (개발용), HikariCP 5.0.1
- `mapUnderscoreToCamelCase` 활성화
- SLF4J 로깅 설정 완료

---

## 3. 요구사항 vs 구현 Gap 목록

### 🔴 Critical Priority (6개 미구현)

| Gap # | 기능 | Mapper 메서드 | 테이블 | 상태 | 블로커 |
|---|---|---|---|---|---|
| 1 | 최근 당첨번호 조회 | `selectLatestLottoResult()` | lotto_result | ❌ 미구현 | Y |
| 2 | 회차별 상금 정보 조회 | `selectLottoPrize()` | lotto_prize | ❌ 미구현 | Y |
| 3 | 예측 번호 저장 | `insertPredict()` | predict | ❌ 미구현 | Y |
| 4 | 중복 예측 확인 | `checkDuplicate()` | predict | ❌ 미구현 | Y |
| 5 | 랭킹 조회 (JOIN) | `selectRanking()` | predict + result | ❌ 미구현 | Y |
| 6 | 현재 회차 조회 | `selectCurrentRound()` | lotto_result | ❌ 미구현 | Y |

### 🟡 Important Priority (5개 미구현)

| Gap # | 기능 | Mapper 메서드 | 테이블 | 상태 | 블로커 |
|---|---|---|---|---|---|
| 7 | 로그인 사용자 조회 | `selectUserByLoginCredentials()` | user | ❌ 미구현 | Y |
| 8 | 회원가입 저장 | `insertUser()` | user | ❌ 미구현 | Y |
| 9 | 총 사용자 수 통계 | `countTotalUsers()` | user | ❌ 미구현 | N |
| 10 | 현재 회차 예측 수 | `countPredictionsCurrentRound()` | predict | ❌ 미구현 | N |
| 11 | 탭별 랭킹 조회 | `selectRankingByTab()` | predict + result | ❌ 미구현 | N |

### 🟢 Optional Priority (5개 미구현)

| Gap # | 기능 | Mapper 메서드 | 테이블 | 상태 | 블로커 |
|---|---|---|---|---|---|
| 12 | 포인트 잔액 조회 | `selectUserPoints()` | user_points | ❌ 미구현 | N |
| 13 | 포인트 차감 | `deductUserPoints()` | user_points | ❌ 미구현 | N |
| 14 | TOP 3 사용자 조회 | `selectTop3Users()` | ranking | ❌ 미구현 | N |
| 15 | 순위 변동 계산 | `selectRankChange()` | ranking | ❌ 미구현 | N |
| 16 | 멤버십 업데이트 | `updateMembership()` | membership | ❌ 미구현 | N |

---

## 4. 매칭률 계산

```
전체 매칭률     = 구현(1) / 필요(16) × 100 = 6.25%
핵심 매칭률     = 구현(0) / 필요(11) × 100 = 0%  (Critical + Important)
Critical 매칭률 = 구현(0) / 필요(6) × 100  = 0%
```

**판정: ⛔ 매칭률 6.25% — 핵심 기능 전무 (iterate 권장)**

---

## 5. 필요한 VO 클래스 (미생성)

```
com.lottorank.vo 패키지 (미존재)
├── LottoResult.java     (id, round, number1~7, bonus, createdAt)
├── LottoPrize.java      (id, round, rank, winnersCount, prizeAmount)
├── User.java            (id, username, password, email, createdAt)
├── Predict.java         (id, userId, round, numbers, createdAt)
├── UserRanking.java     (userId, username, hitCount, totalPredictions, hitRate, rank)
├── TopUser.java         (userId, username, rank, consecutiveRounds, hitRate)
└── RankChange.java      (userId, username, previousRank, currentRank, rankChange)
```

---

## 6. 필요한 Mapper 파일 구조

```
src/main/java/com/lottorank/mapper/
├── LottoResultMapper.java   (당첨번호 조회)
├── LottoPrizeMapper.java    (상금 정보)
├── UserMapper.java          (사용자 인증/관리)
├── PredictMapper.java       (예측 제출/조회)
└── RankingMapper.java       (랭킹 조회 - 복잡)

src/main/resources/mapper/
├── LottoResultMapper.xml
├── LottoPrizeMapper.xml
├── UserMapper.xml
├── PredictMapper.xml
└── RankingMapper.xml
```

---

## 7. 권장 구현 순서

### Phase 1: 기초 설계 (1-2일)
- [ ] `com.lottorank.vo` 패키지 + VO 클래스 7개 생성
- [ ] DB 테이블 스키마 SQL 작성 (H2 초기화 스크립트)
- [ ] `UserMapper` 구현 (selectUserByLoginCredentials, insertUser)

### Phase 2: 핵심 기능 (3-4일)
- [ ] `LottoResultMapper` (selectLatestLottoResult, selectCurrentRound)
- [ ] `PredictMapper` (insertPredict, checkDuplicate)
- [ ] `LottoPrizeMapper` (selectLottoPrize)

### Phase 3: 랭킹 기능 (2-3일)
- [ ] `RankingMapper` (selectRanking - JOIN 쿼리)
- [ ] `RankingMapper` (selectRankingByTab, selectTop3Users, selectRankChange)

### Phase 4: 통계/부가 기능 (2일)
- [ ] 통계 메서드 (countTotalUsers, countPredictionsCurrentRound)
- [ ] PointMapper, MembershipMapper

---

## 8. 기술 주의사항

```
1. #{} 바인딩 사용 (SQL Injection 방지, ${} 금지)
2. 동적 쿼리: <if>, <choose>, <foreach> 활용
3. 복합 인덱스 권장: predict(user_id, round)
4. 트랜잭션: insertPredict + checkDuplicate 묶음 처리
5. mapUnderscoreToCamelCase 이미 활성화 → VO 필드명 camelCase로 작성
```

---

## 9. 결론 및 다음 단계

**현황**: 환경 구성 완료, 비즈니스 Mapper 전무

**즉시 필요 작업**:
1. VO 클래스 7개 생성
2. DB 스키마 정의 (H2 초기화 SQL)
3. Critical Gap 6개 구현 시작

**권장 명령**: `/pdca iterate mapper` — 자동 개선 반복 실행

---

*분석 도구: bkit gap-detector | 매칭률: 6.25% | 상태: iterate 필요*
