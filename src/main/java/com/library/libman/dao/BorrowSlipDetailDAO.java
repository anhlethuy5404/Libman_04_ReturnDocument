package com.library.libman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.library.libman.model.BorrowSlip;
import com.library.libman.model.BorrowSlipDetail;
import com.library.libman.model.Document;
import com.library.libman.model.Reader;
import com.library.libman.utils.DBUtils;

public class BorrowSlipDetailDAO {
    public BorrowSlipDetailDAO(){}
    public List<BorrowSlipDetail> getBorrowingList(int readerId) {
        String sql = "select bs.id as slipId, bs.borrowDate, bs.dueDate, bsd.id as detailId, d.id as docId, d.title, d.author " +
                "from borrowslip bs " +
                "join borrowslipdetail bsd on bs.id = bsd.borrowSlipId " +
                "join document d on bsd.documentId = d.id " +
                "left join returnslipdetail rsd on bsd.id = rsd.borrowSlipDetailId " +
                "where bs.readerUserId = ? and rsd.id is null " +
                "order by bs.borrowDate desc";
        List<BorrowSlipDetail> list = new ArrayList<>();
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, readerId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Document doc = new Document();
                        doc.setId(rs.getInt("docId"));
                        doc.setTitle(rs.getString("title"));
                        doc.setAuthor(rs.getString("author"));

                        BorrowSlip bs = new BorrowSlip();
                        bs.setId(rs.getInt("slipId"));
                        bs.setBorrowDate(rs.getDate("borrowDate"));
                        bs.setDueDate(rs.getDate("dueDate"));

                        BorrowSlipDetail bsd = new BorrowSlipDetail();
                        bsd.setId(rs.getInt("detailId"));
                        bsd.setDocument(doc);
                        bsd.setBorrowSlip(bs);

                        list.add(bsd);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public BorrowSlipDetail getBorrowSlipDetailById(int borrowSlipDetailId) {
        String sql = "select bs.id as slipId, bs.borrowDate, bs.dueDate, bsd.id as detailId, d.id as docId, d.title, d.author, d.price, u.id as readerId, r.readerCode, u.name as readerName " +
                "from borrowslip bs " +
                "join borrowslipdetail bsd on bs.id = bsd.borrowSlipId " +
                "join document d on bsd.documentId = d.id " +
                "join user u on bs.readerUserId = u.id " +
                "join reader r on u.id = r.id " +
                "where bsd.id = ?";
        BorrowSlipDetail bsd = null;
        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, borrowSlipDetailId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Document doc = new Document();
                        doc.setId(rs.getInt("docId"));
                        doc.setTitle(rs.getString("title"));
                        doc.setAuthor(rs.getString("author"));
                        doc.setPrice(rs.getFloat("price"));

                        Reader reader = new Reader();
                        reader.setId(rs.getInt("readerId"));
                        reader.setReaderCode(rs.getString("readerCode"));
                        reader.setName(rs.getString("readerName"));

                        BorrowSlip bs = new BorrowSlip();
                        bs.setId(rs.getInt("slipId"));
                        bs.setBorrowDate(rs.getDate("borrowDate"));
                        bs.setDueDate(rs.getDate("dueDate"));
                        bs.setReader(reader);

                        bsd = new BorrowSlipDetail();
                        bsd.setId(rs.getInt("detailId"));
                        bsd.setDocument(doc);
                        bsd.setBorrowSlip(bs);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bsd;
    }
}
