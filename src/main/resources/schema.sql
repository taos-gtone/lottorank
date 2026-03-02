-- =============================================
-- 게시판 테이블
-- =============================================
CREATE TABLE IF NOT EXISTS BRD_POST_MST (
    post_no        BIGINT(20)   NOT NULL AUTO_INCREMENT COMMENT '게시글번호',
    board_gbn_cd   VARCHAR(2)   NOT NULL                COMMENT '게시판구분코드',
    member_no      BIGINT(20)   NOT NULL                COMMENT '작성자회원번호',
    title          VARCHAR(200) NOT NULL                COMMENT '제목',
    content        LONGTEXT     NOT NULL                COMMENT '내용',
    view_cnt       INT(11)      NOT NULL DEFAULT 0      COMMENT '조회수',
    like_cnt       INT(11)      NOT NULL DEFAULT 0      COMMENT '좋아요수',
    dislike_cnt    INT(11)      NOT NULL DEFAULT 0      COMMENT '싫어요수',
    comment_cnt    INT(11)      NOT NULL DEFAULT 0      COMMENT '댓글수',
    reg_ip         VARCHAR(45)                          COMMENT '작성IP',
    approval_yn    VARCHAR(1)                           COMMENT '승인여부',
    approval_at    DATETIME                             COMMENT '승인일시',
    del_yn         CHAR(1)      NOT NULL DEFAULT 'N'    COMMENT '삭제여부',
    create_ts      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록시간',
    update_ts      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정시간',
    del_ts         TIMESTAMP                            COMMENT '삭제시간',
    PRIMARY KEY (post_no),
    INDEX idx_brd_post_member (member_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='게시판_원글';

CREATE TABLE IF NOT EXISTS BRD_POST_COMMENT (
    comment_no        BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '댓글번호',
    post_no           BIGINT(20) NOT NULL                COMMENT '원글번호',
    parent_comment_no BIGINT(20)                         COMMENT '부모댓글번호',
    depth             TINYINT(4) NOT NULL DEFAULT 0      COMMENT '댓글깊이(0:댓글,1:대댓글)',
    member_no         BIGINT(20) NOT NULL                COMMENT '작성자회원번호',
    content           TEXT       NOT NULL                COMMENT '내용',
    like_cnt          INT(11)    NOT NULL DEFAULT 0      COMMENT '좋아요수',
    dislike_cnt       INT(11)    NOT NULL DEFAULT 0      COMMENT '싫어요수',
    reg_ip            VARCHAR(45)                        COMMENT '작성IP',
    approval_yn       VARCHAR(1)                         COMMENT '승인여부',
    del_yn            CHAR(1)    NOT NULL DEFAULT 'N'    COMMENT '삭제여부',
    create_ts         TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록시간',
    update_ts         TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정시간',
    del_ts            TIMESTAMP                          COMMENT '삭제시간',
    PRIMARY KEY (comment_no),
    INDEX idx_brd_comment_post (post_no),
    INDEX idx_brd_comment_parent (parent_comment_no),
    INDEX idx_brd_comment_member (member_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='게시판_댓글대댓글';

DROP TABLE IF EXISTS BRD_POST_REACTION;
CREATE TABLE BRD_POST_REACTION (
    reaction_no      BIGINT(20)  NOT NULL AUTO_INCREMENT COMMENT '반응번호',
    post_typ_cd      VARCHAR(2)  NOT NULL                COMMENT '게시글유형코드(1:게시글,2:댓글)',
    post_no          BIGINT(20)  NOT NULL DEFAULT 0      COMMENT '게시글번호(댓글반응시 0)',
    comment_no       BIGINT(20)  NOT NULL DEFAULT 0      COMMENT '댓글번호(게시글반응시 0)',
    member_no        BIGINT(20)  NOT NULL                COMMENT '회원번호',
    reaction_typ_cd  VARCHAR(2)  NOT NULL                COMMENT '반응유형코드(1:추천,2:비추천)',
    create_ts        TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록시간',
    PRIMARY KEY (reaction_no),
    UNIQUE KEY uk_post_reaction (post_typ_cd, post_no, comment_no, member_no),
    INDEX idx_reaction_post    (post_no),
    INDEX idx_reaction_comment (comment_no),
    INDEX idx_reaction_member  (member_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='게시판_좋아요싫어요';

-- =============================================
-- 회원 가입정보 테이블
-- =============================================
CREATE TABLE IF NOT EXISTS MEM_JOIN_INFO (
    member_no        BIGINT(20)   NOT NULL AUTO_INCREMENT COMMENT '회원번호',
    user_id          VARCHAR(50)  NOT NULL                COMMENT '아이디',
    user_pw          VARCHAR(100)                         COMMENT '비밀번호(BCrypt)',
    user_name        VARCHAR(50)  NOT NULL                COMMENT '이름',
    nickname         VARCHAR(50)  NOT NULL                COMMENT '닉네임',
    email_id         VARCHAR(100)                         COMMENT '이메일아이디',
    email_addr       VARCHAR(100)                         COMMENT '이메일주소',
    birth_date       VARCHAR(8)                           COMMENT '생년월일(YYYYMMDD)',
    gender_cd        VARCHAR(2)                           COMMENT '성별코드(M/F)',
    reg_ip           VARCHAR(45)                          COMMENT '가입IP',
    reg_login_typ_cd VARCHAR(2)   NOT NULL DEFAULT 'I'    COMMENT '가입유형(I:아이디,N:네이버,K:카카오)',
    social_id        VARCHAR(100)                         COMMENT '소셜ID',
    mobile_no        VARCHAR(20)                          COMMENT '휴대전화번호',
    acct_sts_cd      INT          NOT NULL DEFAULT 1      COMMENT '계정상태코드(1:정상)',
    last_login_at    TIMESTAMP                            COMMENT '최종로그인일시',
    create_ts        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록시간',
    update_ts        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정시간',
    PRIMARY KEY (member_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회원_가입정보';

-- =============================================
-- 회원 전체 랭킹 테이블
-- =============================================
CREATE TABLE IF NOT EXISTS MEM_RANK_ALL (
    round_no      INT UNSIGNED   NOT NULL                COMMENT '회차',
    member_no     BIGINT(20)     NOT NULL                COMMENT '회원번호',
    ranking       INT UNSIGNED   NOT NULL                COMMENT '랭킹',
    grade         INT UNSIGNED   NOT NULL DEFAULT 0      COMMENT '등급',
    elps_cnt      INT UNSIGNED   NOT NULL DEFAULT 0      COMMENT '경과횟수',
    sel_num_cnt   INT UNSIGNED   NOT NULL DEFAULT 0      COMMENT '번호선택횟수',
    win_cnt       INT UNSIGNED   NOT NULL DEFAULT 0      COMMENT '정답횟수',
    cont_lost_cnt INT UNSIGNED   NOT NULL DEFAULT 0      COMMENT '연속오답횟수',
    prev_ranking  INT UNSIGNED                           COMMENT '이전랭킹(NULL=신규)',
    prev_grade    INT UNSIGNED                           COMMENT '이전등급',
    reg_datetime  DATETIME                               COMMENT '등록일시',
    create_ts     TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록시간',
    update_ts     TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정시간',
    PRIMARY KEY (round_no, member_no),
    INDEX idx_mem_rank_all_round  (round_no),
    INDEX idx_mem_rank_all_member (member_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회원_전체랭킹';

-- =============================================
-- 회원 최근5회 랭킹 테이블
-- =============================================
CREATE TABLE IF NOT EXISTS MEM_RANK_5ROUND (
    round_no      INT UNSIGNED   NOT NULL                COMMENT '회차',
    member_no     BIGINT(20)     NOT NULL                COMMENT '회원번호',
    ranking       INT UNSIGNED   NOT NULL                COMMENT '랭킹',
    last_sel_cnt  INT UNSIGNED   NOT NULL DEFAULT 0      COMMENT '최근5회내번호선택횟수',
    win_cnt       INT UNSIGNED   NOT NULL DEFAULT 0      COMMENT '정답횟수',
    lost_cnt      INT UNSIGNED   NOT NULL DEFAULT 0      COMMENT '오답횟수',
    prev_ranking  INT UNSIGNED                           COMMENT '이전랭킹(NULL=신규)',
    reg_datetime  DATETIME                               COMMENT '등록일시',
    create_ts     TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록시간',
    update_ts     TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정시간',
    PRIMARY KEY (round_no, member_no),
    INDEX idx_mem_rank_5round_round  (round_no),
    INDEX idx_mem_rank_5round_member (member_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회원_최근5회랭킹';

-- =============================================
-- 로또 당첨번호 테이블
-- =============================================
CREATE TABLE IF NOT EXISTS LTT_ROUND_RESULT (
    ROUND_NO            INT UNSIGNED   NOT NULL                COMMENT '회차',
    ROUND_DATE          VARCHAR(8)     NOT NULL                COMMENT '추첨일(YYYYMMDD)',
    NUM1                TINYINT(3) UNSIGNED NOT NULL           COMMENT '당첨번호1',
    NUM2                TINYINT(3) UNSIGNED NOT NULL           COMMENT '당첨번호2',
    NUM3                TINYINT(3) UNSIGNED NOT NULL           COMMENT '당첨번호3',
    NUM4                TINYINT(3) UNSIGNED NOT NULL           COMMENT '당첨번호4',
    NUM5                TINYINT(3) UNSIGNED NOT NULL           COMMENT '당첨번호5',
    NUM6                TINYINT(3) UNSIGNED NOT NULL           COMMENT '당첨번호6',
    BONUS_NUM           TINYINT(3) UNSIGNED NOT NULL           COMMENT '보너스번호',
    FST_PRZ_WINNER_CNT  SMALLINT(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1등당첨자수',
    FST_PRZ_SUM_AMT     BIGINT(20) UNSIGNED  NOT NULL DEFAULT 0 COMMENT '1등당첨금총액',
    FST_PRZ_PER_AMT     BIGINT(20) UNSIGNED  NOT NULL DEFAULT 0 COMMENT '1등인당당첨금',
    TOT_SELL_AMT        BIGINT(20) UNSIGNED  NOT NULL DEFAULT 0 COMMENT '총판매금액',
    CREATE_TS           TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록시간',
    UPDATE_TS           TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정시간',
    PRIMARY KEY (ROUND_NO),
    INDEX idx_ltt_round_date (ROUND_DATE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='로또_회차별당첨번호';

-- =============================================
-- 회원 예측번호 테이블
-- =============================================
CREATE TABLE IF NOT EXISTS MEM_PRED_NUM (
    round_no   INT UNSIGNED   NOT NULL                COMMENT '회차',
    member_no  BIGINT(20)     NOT NULL                COMMENT '회원번호',
    pred_num   TINYINT(3) UNSIGNED NOT NULL           COMMENT '예측번호(1~45)',
    hit_yn     VARCHAR(1)                             COMMENT '적중여부(Y/N)',
    submit_at  DATETIME                               COMMENT '제출시각',
    create_ts  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록시간',
    update_ts  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정시간',
    PRIMARY KEY (round_no, member_no),
    INDEX idx_mem_pred_member (member_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회원_예측번호';
