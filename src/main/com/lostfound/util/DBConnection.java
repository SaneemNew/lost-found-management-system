package com.lostfound.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DB_URL  = "jdbc:mysql://localhost:3306/lostfound_db?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    // a new connection each time
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL driver not found: " + e.getMessage());
        }
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    // helperr
    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.out.println("warning: could not close connection");
            }
        }
    }

}
