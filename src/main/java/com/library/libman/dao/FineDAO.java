package com.library.libman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.library.libman.model.Fine;
import com.library.libman.utils.DBUtils;

public class FineDAO {

    public List<Fine> getAllFines() {
        List<Fine> fines = new ArrayList<>();
        String query = "SELECT * FROM fine";

        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Fine fine = new Fine();
                    fine.setId(rs.getInt("id"));
                    fine.setType(rs.getString("type"));
                    fine.setAmount(rs.getFloat("amount"));
                    fines.add(fine);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return fines;
    }

    public Fine getFineById(int fineId) {
        Fine fine = null;
        String query = "SELECT * FROM fine WHERE id = ?";

        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(query)) {

                ps.setInt(1, fineId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        fine = new Fine();
                        fine.setId(rs.getInt("id"));
                        fine.setType(rs.getString("type"));
                        fine.setAmount(rs.getFloat("amount"));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return fine;
    }

    
}
