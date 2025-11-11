package com.library.libman.dao;

import com.library.libman.model.Document;
import com.library.libman.utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DocumentDAO {

    public Document getDocumentById(int documentId) {
        Document document = null;
        String query = "SELECT * FROM document WHERE id = ?";

        try {
            DBUtils.connect();
            Connection conn = DBUtils.jdbcConnection;
            try (PreparedStatement ps = conn.prepareStatement(query)) {

                ps.setInt(1, documentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        document = new Document();
                        document.setId(rs.getInt("id"));
                        document.setTitle(rs.getString("title"));
                        document.setPublishedYear(rs.getDate("published_year"));
                        document.setAuthor(rs.getString("author"));
                        document.setPrice(rs.getFloat("price"));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return document;
    }
}
