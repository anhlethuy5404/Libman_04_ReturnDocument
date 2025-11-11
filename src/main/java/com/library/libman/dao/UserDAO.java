package com.library.libman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.library.libman.model.Reader;
import com.library.libman.model.User;
import com.library.libman.utils.DBUtils;

public class UserDAO {
    public UserDAO() {
    }

    public User checkLogin(String username, String password) {
        String userSql = "SELECT * FROM user WHERE username = ? AND password = ?";
        User user = null;

        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;

            try (PreparedStatement ps = conn.prepareStatement(userSql)) {
                ps.setString(1, username);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String role = rs.getString("role");
                        int userId = rs.getInt("id");

                        if ("READER".equalsIgnoreCase(role)) {
                            String readerCode = null;
                            String readerSql = "SELECT readerCode FROM reader WHERE id = ?";
                            
                            try (PreparedStatement readerPs = conn.prepareStatement(readerSql)) {
                                readerPs.setInt(1, userId);
                                try (ResultSet readerRs = readerPs.executeQuery()) {
                                    if (readerRs.next()) {
                                        readerCode = readerRs.getString("readerCode");
                                    }
                                }
                            }
                            
                            user = new Reader(
                                userId,
                                rs.getString("name"),
                                rs.getString("username"),
                                rs.getString("password"),
                                rs.getDate("birthday"),
                                rs.getString("address"),
                                rs.getString("email"),
                                rs.getString("phoneNumber"),
                                role,
                                readerCode
                            );
                        } else {
                            // For other roles, just create the User object
                            user = new User(
                                userId,
                                rs.getString("name"),
                                rs.getString("username"),
                                rs.getString("password"),
                                rs.getDate("birthday"),
                                rs.getString("address"),
                                rs.getString("email"),
                                rs.getString("phoneNumber"),
                                role
                            );
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }
}
