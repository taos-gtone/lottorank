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
