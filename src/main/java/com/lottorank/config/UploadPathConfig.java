package com.lottorank.config;

import jakarta.servlet.ServletContext;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.context.ServletContextAware;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;
import java.io.IOException;

/**
 * 이미지 업로드 경로 설정
 *
 * - 로컬(Windows) : C:/uploads/lottorank/
 * - 서버(Linux)   : {ROOT 디렉토리 상위}/uploads/
 *                  예) /opt/tomcat/webapps/ROOT → /opt/tomcat/webapps/uploads/
 */
@Configuration
public class UploadPathConfig implements WebMvcConfigurer, ServletContextAware {

    private ServletContext servletContext;

    @Override
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    /**
     * 업로드 베이스 디렉토리 (절대경로, 슬래시로 끝나지 않음)
     * - Windows : C:/uploads/lottorank
     * - Linux   : /opt/tomcat/webapps/uploads  (ROOT 상위/uploads)
     */
    public static String resolveBase(ServletContext ctx) {
        if (isWindows()) {
            return "C:/uploads/lottorank";
        }
        try {
            String webappRoot = ctx.getRealPath("/");          // e.g. /opt/tomcat/webapps/ROOT
            File rootDir = new File(webappRoot).getCanonicalFile();
            return rootDir.getParentFile().getAbsolutePath() + "/uploads"; // e.g. /opt/tomcat/webapps/uploads
        } catch (IOException e) {
            throw new RuntimeException("업로드 경로를 결정할 수 없습니다: " + e.getMessage(), e);
        }
    }

    /**
     * 게시판 이미지 저장 디렉토리 (절대경로)
     * - Windows : C:/uploads/lottorank/board
     * - Linux   : /opt/tomcat/webapps/uploads/board
     */
    public static String resolveBoardDir(ServletContext ctx) {
        return resolveBase(ctx) + "/board";
    }

    /** Spring MVC 리소스 핸들러: /uploads/** → 파일시스템 업로드 베이스 */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String base = resolveBase(servletContext);
        // file: URI 형식 (Windows: file:///C:/..., Linux: file:/opt/...)
        String location = isWindows()
                ? "file:///" + base.replace("\\", "/") + "/"
                : "file:" + base + "/";

        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(location)
                .setCachePeriod(3600);
    }

    private static boolean isWindows() {
        return System.getProperty("os.name", "").toLowerCase().contains("win");
    }
}
