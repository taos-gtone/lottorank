import java.sql.*;

public class tmp_db_check {
    public static void main(String[] args) throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://wonther2.cafe24.com:3306/wonther2?useSSL=false&allowPublicKeyRetrieval=true",
            "wonther2", "tkfkdgo!@");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SHOW TABLES");
        int count = 0;
        while (rs.next()) {
            System.out.println(rs.getString(1));
            count++;
        }
        System.out.println("총 테이블 수: " + count);
        conn.close();
    }
}
