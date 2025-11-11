package com.library.libman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.library.libman.model.Fine;
import com.library.libman.model.FineDetail;
import com.library.libman.model.ReturnSlipDetail;
import com.library.libman.utils.DBUtils;

public class FineDetailDAO {
    public void addFineDetail(FineDetail fineDetail, int returnSlipDetailId) {
        String query = "INSERT INTO finedetail (fineId, quantity, returnSlipDetailId) VALUES (?, ?, ?)";

        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setInt(1, fineDetail.getFine().getId());
                ps.setInt(2, fineDetail.getQuantity());
                ps.setInt(3, returnSlipDetailId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<FineDetail> getFineDetailsByReturnSlipDetailId(int returnSlipDetailId) {
        List<FineDetail> fineDetails = new ArrayList<>();
        String query = "SELECT fd.id, fd.quantity, f.id as fine_id, f.type, f.amount FROM finedetail fd " +
                "JOIN fine f ON fd.fineId = f.id WHERE fd.returnSlipDetailId = ?";
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setInt(1, returnSlipDetailId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        FineDetail fineDetail = new FineDetail();
                        fineDetail.setId(rs.getInt("id"));
                        fineDetail.setQuantity(rs.getInt("quantity"));

                        Fine fine = new Fine();
                        fine.setId(rs.getInt("fine_id"));
                        fine.setType(rs.getString("type"));
                        fine.setAmount(rs.getFloat("amount"));
                        fineDetail.setFine(fine);

                        fineDetails.add(fineDetail);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fineDetails;
    }

    public void deleteFineDetail(int fineDetailId) {
        String query = "DELETE FROM finedetail WHERE id = ?";
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setInt(1, fineDetailId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


}
