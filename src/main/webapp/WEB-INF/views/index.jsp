<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LottoRank</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            background: white;
            border-radius: 16px;
            padding: 48px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            text-align: center;
            max-width: 600px;
        }
        h1 { color: #333; font-size: 2.2em; margin-bottom: 16px; }
        .badge {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.85em;
            margin: 4px;
        }
        .info {
            margin-top: 24px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            text-align: left;
        }
        .info p { margin: 8px 0; color: #555; font-size: 0.95em; }
        .info strong { color: #333; }
        .time { margin-top: 20px; color: #888; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="container">
        <h1>${message}</h1>
        <div>
            <span class="badge">Spring 5 MVC</span>
            <span class="badge">MyBatis</span>
            <span class="badge">JSP</span>
            <span class="badge">Tomcat 9</span>
        </div>
        <div class="info">
            <p><strong>Framework:</strong> Spring MVC 5.3</p>
            <p><strong>ORM:</strong> MyBatis 3.5 + Spring 연동</p>
            <p><strong>Database:</strong> H2 (내장 개발용)</p>
            <p><strong>View:</strong> JSP + JSTL</p>
            <p><strong>Build:</strong> Maven</p>
            <p><strong>IDE:</strong> Eclipse (Maven Import)</p>
        </div>
        <p class="time">서버 시간 (MyBatis 조회): ${serverTime}</p>
    </div>
</body>
</html>
