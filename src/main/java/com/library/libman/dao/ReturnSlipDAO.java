package com.library.libman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import com.library.libman.model.Librarian;
import com.library.libman.model.Reader;
import com.library.libman.model.ReturnSlip;
import com.library.libman.model.ReturnSlipDetail;
import com.library.libman.utils.DBUtils;

public class ReturnSlipDAO {
    public ReturnSlipDAO() {
    }

    public int addReturnSlip(ReturnSlip slip) {
        String sql = "insert into returnslip(returnDate, totalFine, librarianUserId, readerUserId) " +
                "values (?, ?, ?, ?)";
        int generatedId = 0;
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;

            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setDate(1, new java.sql.Date(slip.getReturnDate().getTime()));
                ps.setFloat(2, slip.getTotalFine());
                ps.setInt(3, slip.getLibrarian().getId());
                ps.setInt(4, slip.getReader().getId());
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            generatedId = generatedKeys.getInt(1);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return generatedId;
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

    public float calculateTotalFine(int returnSlipId) {
        float totalFine = 0;
        String sql = "SELECT rsd.id as rsd_id, rsd.totalFineDetail, fd.quantity, f.amount, f.type, bs.dueDate " +
                "FROM returnslipdetail rsd " +
                "LEFT JOIN finedetail fd ON rsd.id = fd.returnSlipDetailId " +
                "LEFT JOIN fine f ON fd.fineId = f.id " +
                "JOIN borrowslipdetail bsd ON rsd.borrowSlipDetailId = bsd.id " +
                "JOIN borrowslip bs ON bsd.borrowSlipId = bs.id " +
                "WHERE rsd.returnSlipId = ?";
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, returnSlipId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        float fineAmount = rs.getFloat("amount");
                        int quantity = rs.getInt("quantity");
                        String fineType = rs.getString("type");

                        if (fineType != null) {
                            if (fineType.equals("Late Return")) {
                                LocalDate dueDateLocal = rs.getDate("dueDate").toLocalDate();
                                LocalDate todayLocal = LocalDate.now();
                                long overdueDays = ChronoUnit.DAYS.between(dueDateLocal, todayLocal);
                                if (overdueDays < 0) overdueDays = 0;
                                totalFine += fineAmount * overdueDays;
                            } else {
                                totalFine += fineAmount * quantity;
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalFine;
    }

    public void updateTotalFineForSlip(int returnSlipId, float totalFine) {
        String sql = "UPDATE returnslip SET totalFine = ? WHERE id = ?";
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setFloat(1, totalFine);
                ps.setInt(2, returnSlipId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ReturnSlip getReturnSlipById(int returnSlipId) {
        ReturnSlip returnSlip = null;
        String sql = "SELECT rs.id, rs.returnDate, rs.totalFine, rs.status, " +
                "l.id as librarian_id, l.username as librarian_username, " +
                "u_reader.id as reader_id, r.readerCode, u_reader.name as reader_name " +
                "FROM returnslip rs " +
                "JOIN user l ON rs.librarianUserId = l.id " +
                "JOIN reader r ON rs.readerUserId = r.id " +
                "JOIN user u_reader ON r.id = u_reader.id " +
                "WHERE rs.id = ?";
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, returnSlipId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        returnSlip = new ReturnSlip();
                        returnSlip.setId(rs.getInt("id"));
                        returnSlip.setReturnDate(rs.getDate("returnDate"));
                        returnSlip.setTotalFine(rs.getFloat("totalFine"));
                        returnSlip.setStatus(rs.getString("status"));

                        Librarian librarian = new Librarian();
                        librarian.setId(rs.getInt("librarian_id"));
                        librarian.setUsername(rs.getString("librarian_username"));
                        returnSlip.setLibrarian(librarian);

                        Reader reader = new Reader();
                        reader.setId(rs.getInt("reader_id"));
                        reader.setReaderCode(rs.getString("readerCode"));
                        reader.setName(rs.getString("reader_name"));
                        returnSlip.setReader(reader);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return returnSlip;
    }

    public ReturnSlipDetail getReturnSlipDetailByBorrowSlipDetailId(int borrowSlipDetailId) {
    ReturnSlipDetail returnSlipDetail = null;
    String sql = "SELECT * FROM returnslipdetail WHERE borrowSlipDetailId = ?";
    try {
        DBUtils.connect();
        Connection conn = DBUtils.jdbcConnection;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, borrowSlipDetailId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    returnSlipDetail = new ReturnSlipDetail();
                    returnSlipDetail.setId(rs.getInt("id"));
                    returnSlipDetail.setTotalFineDetail(rs.getFloat("totalFineDetail"));
                    
                    FineDetailDAO fineDetailDAO = new FineDetailDAO();
                    returnSlipDetail.setFineDetails(fineDetailDAO.getFineDetailsByReturnSlipDetailId(returnSlipDetail.getId()));
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return returnSlipDetail;
}

    public void updateReturnSlipStatus(int returnSlipId, String status) throws SQLException {
        String sql = "UPDATE returnslip SET status = ? WHERE id = ?";
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, status);
                ps.setInt(2, returnSlipId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException(e);
        }
    }
}
