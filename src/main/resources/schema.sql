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
-- 로또 당첨번호 테이블
-- =============================================
CREATE TABLE IF NOT EXISTS LTT_ROUND_RESULT (
    ROUND_NO         INT     NOT NULL PRIMARY KEY,
    DRAW_DATE        DATE    NOT NULL,
    NUM1             INT     NOT NULL,
    NUM2             INT     NOT NULL,
    NUM3             INT     NOT NULL,
    NUM4             INT     NOT NULL,
    NUM5             INT     NOT NULL,
    NUM6             INT     NOT NULL,
    BONUS_NUM        INT     NOT NULL,
    PRIZE_1ST_AMOUNT BIGINT  NOT NULL,
    PRIZE_1ST_COUNT  INT     NOT NULL
);
