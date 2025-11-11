package com.library.libman.controller;

import java.io.IOException;

import com.library.libman.dao.BorrowSlipDetailDAO;
import com.library.libman.dao.ReturnSlipDetailDAO;
import com.library.libman.model.BorrowSlipDetail;
import com.library.libman.model.ReturnSlip;
import com.library.libman.model.ReturnSlipDetail;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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

            ReturnSlipDetailDAO returnSlipDetailDAO = new ReturnSlipDetailDAO();
            ReturnSlipDetail existingDetail = returnSlipDetailDAO.getReturnSlipDetailByBorrowSlipDetailId(borrowSlipDetailId);

            if (existingDetail != null) {
                returnSlipDetailDAO.updateTotalFine(borrowSlipDetailId, totalFine);
            } else {
                Integer returnSlipId = (Integer) request.getSession().getAttribute("returnSlipId");
                if (returnSlipId != null) {
                    ReturnSlip parentReturnSlip = new ReturnSlip();
                    parentReturnSlip.setId(returnSlipId);

                    BorrowSlipDetailDAO borrowSlipDetailDAO = new BorrowSlipDetailDAO();
                    BorrowSlipDetail bsd = borrowSlipDetailDAO.getBorrowSlipDetailById(borrowSlipDetailId);

                    if (bsd != null) {
                        ReturnSlipDetail newDetail = new ReturnSlipDetail();
                        newDetail.setReturnSlip(parentReturnSlip);
                        newDetail.setBorrowSlipDetail(bsd);
                        newDetail.setTotalFineDetail(totalFine);

                        returnSlipDetailDAO.addReturnSlipDetail(newDetail);
                    } else {
                    }
                } else {
                }
            }

            response.sendRedirect("SelectedDocumentFrm.jsp");

        } catch (NumberFormatException e) {
            response.sendRedirect("DocumentReturnFrm.jsp");
        }
    }
}
