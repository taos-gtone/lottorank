package com.lottorank.logging;

import ch.qos.logback.classic.pattern.ClassicConverter;
import ch.qos.logback.classic.spi.ILoggingEvent;

import java.util.ArrayList;
import java.util.List;

/**
 * MyBatis SQL 로그를 가독성 있게 줄 바꿈해서 출력하는 Logback Converter.
 *
 * 적용 후 예시:
 *   ==>  Preparing:
 *           SELECT id
 *                , name
 *                , email
 *             FROM member
 *            WHERE id = ?
 *              AND status = ?
 *         ORDER BY name
 */
public class SqlPrettyConverter extends ClassicConverter {

    private static final String PREPARING = "Preparing: ";

    // SELECT 컬럼 계속줄 들여쓰기: "        SELECT " = 15자, 콤마 포함 15자 맞춤
    private static final String COL_INDENT = "\n               , ";

    /** 키워드 치환 — 긴 키워드가 앞에 와야 부분 치환 방지 */
    private static final String[][] REPLACEMENTS = {
        { " LEFT OUTER JOIN ", "\n    LEFT OUTER JOIN " },
        { " RIGHT OUTER JOIN ", "\n   RIGHT OUTER JOIN " },
        { " FULL OUTER JOIN ", "\n   FULL OUTER JOIN "  },
        { " LEFT JOIN ",       "\n         LEFT JOIN "  },
        { " RIGHT JOIN ",      "\n        RIGHT JOIN "  },
        { " INNER JOIN ",      "\n        INNER JOIN "  },
        { " CROSS JOIN ",      "\n        CROSS JOIN "  },
        { " JOIN ",            "\n              JOIN "  },
        { " ON ",              "\n               ON "   },
        { " FROM ",            "\n             FROM "   },
        { " WHERE ",           "\n            WHERE "   },
        { " GROUP BY ",        "\n         GROUP BY "   },
        { " HAVING ",          "\n           HAVING "   },
        { " ORDER BY ",        "\n         ORDER BY "   },
        { " LIMIT ",           "\n            LIMIT "   },
        { " OFFSET ",          "\n           OFFSET "   },
        { " UNION ALL ",       "\n        UNION ALL "   },
        { " UNION ",           "\n            UNION "   },
        { " AND ",             "\n              AND "   },
        { " OR ",              "\n               OR "   },
        { " SET ",             "\n              SET "   },
        { " VALUES ",          "\n           VALUES "   },
    };

    @Override
    public String convert(ILoggingEvent event) {
        String msg = event.getFormattedMessage();

        int prepIdx = msg.indexOf(PREPARING);
        if (prepIdx < 0) {
            return msg;
        }

        String prefix = msg.substring(0, prepIdx + PREPARING.length());
        String sql    = msg.substring(prepIdx + PREPARING.length()).trim();

        // 1. SELECT 컬럼 리스트 줄 바꿈 (괄호 안 콤마는 분리하지 않음)
        sql = formatSelectList(sql);

        // 2. SQL 키워드 앞 줄 바꿈
        for (String[] pair : REPLACEMENTS) {
            sql = sql.replace(pair[0], pair[1]);
        }

        return prefix + "\n        " + sql;
    }

    /** SELECT 컬럼 리스트를 한 컬럼씩 줄 바꿈 */
    private String formatSelectList(String sql) {
        if (!sql.toUpperCase().startsWith("SELECT ")) {
            return sql;
        }

        int fromIdx = findTopLevel(sql, " FROM ");
        if (fromIdx < 0) {
            return sql;
        }

        String cols = sql.substring("SELECT ".length(), fromIdx);
        String rest = sql.substring(fromIdx); // " FROM ..." 이후

        List<String> colList = splitTopLevelComma(cols);
        if (colList.size() <= 1) {
            return sql;
        }

        StringBuilder sb = new StringBuilder("SELECT ");
        sb.append(colList.get(0).trim());
        for (int i = 1; i < colList.size(); i++) {
            sb.append(COL_INDENT).append(colList.get(i).trim());
        }
        sb.append(rest);
        return sb.toString();
    }

    /** 최상위 레벨(괄호 밖)에서 keyword 위치 탐색 */
    private int findTopLevel(String sql, String keyword) {
        String upper = sql.toUpperCase();
        String kwUpper = keyword.toUpperCase();
        int depth = 0;
        for (int i = 0; i < sql.length(); i++) {
            char c = sql.charAt(i);
            if (c == '(') depth++;
            else if (c == ')') depth--;
            else if (depth == 0 && upper.startsWith(kwUpper, i)) {
                return i;
            }
        }
        return -1;
    }

    /** 최상위 콤마 기준으로 분리 (괄호 안 콤마 제외) */
    private List<String> splitTopLevelComma(String sql) {
        List<String> parts = new ArrayList<>();
        int depth = 0;
        int start = 0;
        for (int i = 0; i < sql.length(); i++) {
            char c = sql.charAt(i);
            if (c == '(') depth++;
            else if (c == ')') depth--;
            else if (c == ',' && depth == 0) {
                parts.add(sql.substring(start, i).trim());
                start = i + 1;
            }
        }
        parts.add(sql.substring(start).trim());
        return parts;
    }
}
