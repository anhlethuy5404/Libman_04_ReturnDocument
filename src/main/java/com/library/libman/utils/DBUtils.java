/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.library.libman.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author asus
 */
public class DBUtils {
    public static final String jdbcURL = "jdbc:mysql://localhost:3306/libman?useSSL=false";
    public static final String jdbcUsername = "root";
    public static final String jdbcPassword = "root";
    public static Connection jdbcConnection;
 
    public static void connect() throws SQLException{
        if(jdbcConnection == null || jdbcConnection.isClosed()){
            try{
                Class.forName("com.mysql.cj.jdbc.Driver");
            }
            catch (ClassNotFoundException e) {
                throw new SQLException(e);
            }
            jdbcConnection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        }
    }
    
    public static void disconnect() {
        if (jdbcConnection != null) {
            try {
                jdbcConnection.close();
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }
}
