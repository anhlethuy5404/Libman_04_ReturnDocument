package com.library.libman.controller;

import java.io.IOException;

import com.library.libman.dao.*;
import com.library.libman.model.BorrowSlipDetail;
import com.library.libman.model.Fine;
import com.library.libman.model.FineDetail;
import com.library.libman.model.Librarian;
import com.library.libman.model.ReturnSlip;
import com.library.libman.model.ReturnSlipDetail;
import com.library.libman.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AddFineDetailServlet", urlPatterns = "/add-fine-detail")
public class AddFineDetailServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String borrowSlipDetailIdStr = request.getParameter("borrowSlipDetailId");
        String fineIdStr = request.getParameter("fineId");
        String quantityStr = request.getParameter("quantity");

        if (borrowSlipDetailIdStr == null || fineIdStr == null) {
            response.sendRedirect("DocumentReturnFrm.jsp");
            return;
        }

        try {
            int borrowSlipDetailId = Integer.parseInt(borrowSlipDetailIdStr);
            int fineId = Integer.parseInt(fineIdStr);
            int quantity = (quantityStr != null && !quantityStr.isEmpty()) ? Integer.parseInt(quantityStr) : 1;

            FineDetailDAO fineDetailDAO = new FineDetailDAO();
            ReturnSlipDAO returnSlipDAO = new ReturnSlipDAO();
            BorrowSlipDetailDAO borrowSlipDetailDAO = new BorrowSlipDetailDAO();
            ReturnSlipDetailDAO returnSlipDetailDAO = new ReturnSlipDetailDAO();

            BorrowSlipDetail bsd = borrowSlipDetailDAO.getBorrowSlipDetailById(borrowSlipDetailId);

            User userFromSession = (User) request.getSession().getAttribute("user");
            if (userFromSession == null) {
                response.sendRedirect("login.jsp"); // Or handle as unauthorized
                return;
            }

            Librarian librarian = new Librarian();
            librarian.setId(userFromSession.getId());
            librarian.setName(userFromSession.getName());
            librarian.setUsername(userFromSession.getUsername());
            librarian.setPassword(userFromSession.getPassword());
            librarian.setBirthday(userFromSession.getBirthday());
            librarian.setAddress(userFromSession.getAddress());
            librarian.setEmail(userFromSession.getEmail());
            librarian.setPhoneNumber(userFromSession.getPhoneNumber());
            librarian.setRole(userFromSession.getRole()); 

            Integer returnSlipId = (Integer) request.getSession().getAttribute("returnSlipId");
            if (returnSlipId == null) {
                ReturnSlip newReturnSlip = new ReturnSlip();
                newReturnSlip.setReader(bsd.getBorrowSlip().getReader());
                newReturnSlip.setLibrarian(librarian);
                newReturnSlip.setReturnDate(new java.util.Date());
                newReturnSlip.setTotalFine(0); // Initial total fine
                returnSlipId = returnSlipDAO.addReturnSlip(newReturnSlip);
                if (returnSlipId == 0) {
                    request.setAttribute("message", "Error: Failed to create return slip.");
                    request.getRequestDispatcher("DocumentReturnFrm.jsp").forward(request, response);
                    return;
                }
                request.getSession().setAttribute("returnSlipId", returnSlipId);
            }

            ReturnSlipDetail returnSlipDetail = returnSlipDetailDAO.getReturnSlipDetailByBorrowSlipDetailId(borrowSlipDetailId);
            int returnSlipDetailId;

            if (returnSlipDetail == null) {
                returnSlipDetail = new ReturnSlipDetail();
                returnSlipDetail.setBorrowSlipDetail(bsd);

                ReturnSlip parentReturnSlip = new ReturnSlip();
                parentReturnSlip.setId(returnSlipId);
                returnSlipDetail.setReturnSlip(parentReturnSlip);

                returnSlipDetailId = returnSlipDetailDAO.addReturnSlipDetail(returnSlipDetail);
                if (returnSlipDetailId == 0) {
                    request.setAttribute("message", "Error: Failed to create return slip detail.");
                    request.getRequestDispatcher("DocumentReturnFrm.jsp").forward(request, response);
                    return;
                }
            } else {
                returnSlipDetailId = returnSlipDetail.getId();
            }

            Fine fine = new FineDAO().getFineById(fineId);
            if (fine != null) {
                FineDetail fineDetail = new FineDetail();
                fineDetail.setFine(fine);
                fineDetail.setQuantity(quantity);

                fineDetailDAO.addFineDetail(fineDetail, returnSlipDetailId);
            }

            response.sendRedirect("fine?borrowSlipDetailId=" + borrowSlipDetailId);

        } catch (NumberFormatException e) {
            response.sendRedirect("DocumentReturnFrm.jsp");
        }
    }
}
