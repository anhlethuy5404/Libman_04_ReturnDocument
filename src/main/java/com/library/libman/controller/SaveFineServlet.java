package com.library.libman.controller;

import com.library.libman.dao.FineDAO;
import com.library.libman.dao.ReturnSlipDAO;
import com.library.libman.model.ReturnSlipDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "SaveFineServlet", urlPatterns = "/save-fine")
public class SaveFineServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String borrowSlipDetailIdStr = request.getParameter("borrowSlipDetailId");
        String totalFineStr = request.getParameter("totalFine");

        if (borrowSlipDetailIdStr == null || borrowSlipDetailIdStr.isEmpty() || totalFineStr == null || totalFineStr.isEmpty()) {
            response.sendRedirect("DocumentReturnFrm.jsp");
            return;
        }

        try {
            int borrowSlipDetailId = Integer.parseInt(borrowSlipDetailIdStr);
            float totalFine = Float.parseFloat(totalFineStr);

            ReturnSlipDAO returnSlipDAO = new ReturnSlipDAO();
            returnSlipDAO.updateTotalFine(borrowSlipDetailId, totalFine);

            response.sendRedirect("SelectedDocumentFrm.jsp");

        } catch (NumberFormatException e) {
            response.sendRedirect("DocumentReturnFrm.jsp");
        }
    }
}
