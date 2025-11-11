package com.library.libman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.library.libman.model.Reader;
import com.library.libman.utils.DBUtils;

public class ReaderDAO {
    public ReaderDAO() {}
    public Reader searchReaderByReaderCode(String readerCode) {
        String sql = "select u.*, r.readerCode " +
                "from user u " +
                "join reader r " +
                "on u.id = r.id " +
                "where r.readerCode = ?";
        Reader reader = null;
        try{
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(sql)){
                ps.setString(1, readerCode);
                try (ResultSet rs = ps.executeQuery()){
                    if(rs.next()){
                        reader = new Reader(
                                rs.getInt("id"),
                                rs.getString("name"),
                                rs.getString("username"),
                                rs.getString("password"),
                                rs.getDate("birthday"),
                                rs.getString("address"),
                                rs.getString("email"),
                                rs.getString("phoneNumber"),
                                rs.getString("role"),
                                rs.getString("readerCode")
                        );
                    }
                }
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return reader;
    }

    public Reader getReaderById(int readerId) {
        String sql = "select u.*, r.readerCode " +
                "from user u " +
                "join reader r " +
                "on u.id = r.id " +
                "where r.id = ?";
        Reader reader = null;
        try{
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(sql)){
                ps.setInt(1, readerId);
                try (ResultSet rs = ps.executeQuery()){
                    if(rs.next()){
                        reader = new Reader(
                                rs.getInt("id"),
                                rs.getString("name"),
                                rs.getString("username"),
                                rs.getString("password"),
                                rs.getDate("birthday"),
                                rs.getString("address"),
                                rs.getString("email"),
                                rs.getString("phoneNumber"),
                                rs.getString("role"),
                                rs.getString("readerCode")
                        );
                    }
                }
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return reader;
    }
}
