package com.library.libman.controller;

import java.io.IOException;
import java.util.List;

import com.library.libman.dao.BorrowSlipDetailDAO;
import com.library.libman.dao.FineDAO;
import com.library.libman.dao.FineDetailDAO;
import com.library.libman.dao.ReturnSlipDetailDAO;
import com.library.libman.model.BorrowSlipDetail;
import com.library.libman.model.Fine;
import com.library.libman.model.FineDetail;
import com.library.libman.model.ReturnSlipDetail;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "FineServlet", urlPatterns = "/fine")
public class FineServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String borrowSlipDetailIdStr = request.getParameter("borrowSlipDetailId");
        if (borrowSlipDetailIdStr == null || borrowSlipDetailIdStr.isEmpty()) {
            response.sendRedirect("DocumentReturnFrm.jsp");
            return;
        }

        try {
            int borrowSlipDetailId = Integer.parseInt(borrowSlipDetailIdStr);
            BorrowSlipDetailDAO borrowSlipDetailDAO = new BorrowSlipDetailDAO();
            BorrowSlipDetail borrowSlipDetail = borrowSlipDetailDAO.getBorrowSlipDetailById(borrowSlipDetailId);

            if (borrowSlipDetail == null) {
                response.sendRedirect("DocumentReturnFrm.jsp");
                return;
            }

            FineDAO fineDAO = new FineDAO();
            List<Fine> fines = fineDAO.getAllFines();

            FineDetailDAO fineDetailDAO = new FineDetailDAO();
            ReturnSlipDetailDAO returnSlipDetailDAO = new ReturnSlipDetailDAO();
            ReturnSlipDetail returnSlipDetail = returnSlipDetailDAO.getReturnSlipDetailByBorrowSlipDetailId(borrowSlipDetailId);
            List<FineDetail> fineDetails = null;
            if (returnSlipDetail != null) {
                fineDetails = fineDetailDAO.getFineDetailsByReturnSlipDetailId(returnSlipDetail.getId());
            }

            request.setAttribute("borrowSlipDetail", borrowSlipDetail);
            request.setAttribute("fines", fines);
            request.setAttribute("fineDetails", fineDetails);
            request.getRequestDispatcher("FineListFrm.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("DocumentReturnFrm.jsp");
        }
    }
}
