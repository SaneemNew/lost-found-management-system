package com.lostfound.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    /*
     * Database configuration for local XAMPP/MySQL setup.
     * If the project is tested on another PC, update these values
     * according to that PC's MySQL port, username, and password.
     */
    private static final String DB_URL =
            "jdbc:mysql://localhost:3306/lostfound_db?useSSL=false&serverTimezone=UTC";

    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    /*
     * Creates and returns a new database connection.
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC driver not found.", e);
        }

        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    /*
     * Safely closes a database connection.
     */
    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.out.println("Warning: could not close database connection.");
            }
        }
    }
}