package com.library.libman.controller;

import com.library.libman.dao.BorrowSlipDetailDAO;
import com.library.libman.model.BorrowSlipDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BorrowSlipServlet", urlPatterns = {"/borrow-slip"})
public class BorrowSlipServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String readerIdStr = request.getParameter("readerId");
        if (readerIdStr != null && !readerIdStr.isEmpty()) {
            try {
                int readerId = Integer.parseInt(readerIdStr);
                BorrowSlipDetailDAO borrowSlipDetailDAO = new BorrowSlipDetailDAO();
                List<BorrowSlipDetail> borrowingList = borrowSlipDetailDAO.getBorrowingList(readerId);
                request.setAttribute("borrowingList", borrowingList);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
    }
}
