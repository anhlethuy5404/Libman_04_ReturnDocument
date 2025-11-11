package com.library.libman.controller;

import com.library.libman.dao.FineDetailDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "DeleteFineDetailServlet", urlPatterns = "/delete-fine-detail")
public class DeleteFineDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fineDetailIdStr = request.getParameter("fineDetailId");
        String borrowSlipDetailIdStr = request.getParameter("borrowSlipDetailId");

        if (fineDetailIdStr == null || borrowSlipDetailIdStr == null) {
            response.sendRedirect("DocumentReturnFrm.jsp");
            return;
        }

        try {
            int fineDetailId = Integer.parseInt(fineDetailIdStr);
            FineDetailDAO fineDetailDAO = new FineDetailDAO();
            fineDetailDAO.deleteFineDetail(fineDetailId);

            response.sendRedirect("fine?borrowSlipDetailId=" + borrowSlipDetailIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("DocumentReturnFrm.jsp");
        }
    }
}
