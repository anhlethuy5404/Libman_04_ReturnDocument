package com.library.libman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.library.libman.model.BorrowSlipDetail;
import com.library.libman.model.Document;
import com.library.libman.model.ReturnSlipDetail;
import com.library.libman.utils.DBUtils;

public class ReturnSlipDetailDAO {
    public ReturnSlipDetailDAO() {
    }
    public int addReturnSlipDetail(ReturnSlipDetail returnSlipDetail) {
        String sql = "insert into returnslipdetail(totalFineDetail, returnSlipId, borrowSlipDetailId) " +
                "values (?, ?, ?)";
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;

            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setFloat(1, returnSlipDetail.getTotalFineDetail());
                ps.setInt(2, returnSlipDetail.getReturnSlip().getId());
                ps.setInt(3, returnSlipDetail.getBorrowSlipDetail().getId());
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            return generatedKeys.getInt(1);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public ReturnSlipDetail getReturnSlipDetailByBorrowSlipDetailId(int borrowSlipDetailId) {
        String query = "SELECT id FROM returnslipdetail WHERE borrowSlipDetailId = ?";
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setInt(1, borrowSlipDetailId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        ReturnSlipDetail rsd = new ReturnSlipDetail();
                        rsd.setId(rs.getInt("id"));
                        return rsd;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ReturnSlipDetail> getReturnSlipDetailsByReturnSlipId(int returnSlipId) {
        List<ReturnSlipDetail> returnSlipDetails = new ArrayList<>();
        String sql = "SELECT rsd.id as rsd_id, rsd.totalFineDetail, " +
                "bsd.id as bsd_id, " +
                "d.id as doc_id, d.title as doc_title " +
                "FROM returnslipdetail rsd " +
                "JOIN borrowslipdetail bsd ON rsd.borrowSlipDetailId = bsd.id " +
                "JOIN document d ON bsd.documentId = d.id " +
                "WHERE rsd.returnSlipId = ?";
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, returnSlipId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        ReturnSlipDetail rsd = new ReturnSlipDetail();
                        rsd.setId(rs.getInt("rsd_id"));
                        rsd.setTotalFineDetail(rs.getFloat("totalFineDetail"));

                        BorrowSlipDetail bsd = new BorrowSlipDetail();
                        bsd.setId(rs.getInt("bsd_id"));

                        Document doc = new Document();
                        doc.setId(rs.getInt("doc_id"));
                        doc.setTitle(rs.getString("doc_title"));
                        bsd.setDocument(doc);

                        rsd.setBorrowSlipDetail(bsd);
                        returnSlipDetails.add(rsd);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return returnSlipDetails;
    }
    public void updateTotalFine(int borrowSlipDetailId, float totalFine) {
        String sql = "UPDATE returnslipdetail SET totalFineDetail = ? WHERE borrowSlipDetailId = ?";
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setFloat(1, totalFine);
                ps.setInt(2, borrowSlipDetailId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
