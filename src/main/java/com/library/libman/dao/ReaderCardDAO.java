package com.library.libman.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.library.libman.model.ReaderCard;
import com.library.libman.utils.DBUtils;

public class ReaderCardDAO {
    public ReaderCardDAO() {
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public boolean isReaderCardExist(int readerId) {
        String sql = "SELECT * FROM readercard WHERE readerId = ?";
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, readerId);
                try (var rs = ps.executeQuery()) {
                    return rs.next();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public boolean registerCard(ReaderCard card) {
        if (isReaderCardExist(card.getReader().getId())) {
            return false; 
        }
        String sql = "INSERT INTO readercard (name, birthday, cardType, registerDate, expiryDate, readerId) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, card.getName());
                ps.setDate(2, new Date(card.getBirthday().getTime()));
                ps.setString(3, card.getCardType());
                ps.setDate(4, new Date(card.getRegisterDate().getTime()));
                ps.setDate(5, new Date(card.getExpiryDate().getTime()));
                ps.setInt(6, card.getReader().getId());

                int result = ps.executeUpdate();
                return result > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
