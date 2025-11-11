package com.library.libman.controller;

import java.io.IOException;

import com.library.libman.dao.BorrowSlipDetailDAO;
import com.library.libman.dao.ReaderDAO;
import com.library.libman.dao.ReturnSlipDAO;
import com.library.libman.dao.ReturnSlipDetailDAO;
import com.library.libman.model.BorrowSlipDetail;
import com.library.libman.model.Librarian;
import com.library.libman.model.Reader;
import com.library.libman.model.ReturnSlip;
import com.library.libman.model.ReturnSlipDetail;
import com.library.libman.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ReturnSlipServlet", urlPatterns = "/create-return-slip")
public class ReturnSlipServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User librarianUser = (User) request.getSession().getAttribute("user");
        if (librarianUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String readerCode = request.getParameter("readerCode");
        if (readerCode == null || readerCode.isEmpty()) {
            request.setAttribute("message", "Error: Missing reader information for return slip creation.");
            request.getRequestDispatcher("MainFrm.jsp").forward(request, response);
            return;
        }

        ReaderDAO readerDAO = new ReaderDAO();
        Reader reader = readerDAO.searchReaderByReaderCode(readerCode);

        if (reader == null) {
            request.setAttribute("message", "Error: Could not find the specified reader.");
            request.getRequestDispatcher("MainFrm.jsp").forward(request, response);
            return;
        }

        ReturnSlipDAO returnSlipDAO = new ReturnSlipDAO();
        Integer returnSlipId = (Integer) request.getSession().getAttribute("returnSlipId");

        // If no return slip is in progress, create one
        if (returnSlipId == null) {
            Librarian librarian = new Librarian();
            librarian.setId(librarianUser.getId());
            librarian.setName(librarianUser.getName());
            librarian.setUsername(librarianUser.getUsername());
            librarian.setPassword(librarianUser.getPassword());
            librarian.setBirthday(librarianUser.getBirthday());
            librarian.setAddress(librarianUser.getAddress());
            librarian.setEmail(librarianUser.getEmail());
            librarian.setPhoneNumber(librarianUser.getPhoneNumber());
            librarian.setRole(librarianUser.getRole());

            ReturnSlip newReturnSlip = new ReturnSlip();
            newReturnSlip.setReader(reader);
            newReturnSlip.setLibrarian(librarian);
            newReturnSlip.setReturnDate(new java.util.Date());
            newReturnSlip.setTotalFine(0); 
            returnSlipId = returnSlipDAO.addReturnSlip(newReturnSlip);

            if (returnSlipId == 0) {
                request.setAttribute("message", "Error: Failed to create return slip.");
                request.getRequestDispatcher("DocumentReturnFrm.jsp").forward(request, response);
                return;
            }
            request.getSession().setAttribute("returnSlipId", returnSlipId);

            // Also create the ReturnSlipDetail entries
            String[] selectedDetailsIds = request.getParameterValues("selectedDetails");
            if (selectedDetailsIds != null) {
                ReturnSlipDetailDAO returnSlipDetailDAO = new ReturnSlipDetailDAO();
                BorrowSlipDetailDAO borrowSlipDetailDAO = new BorrowSlipDetailDAO();
                for (String bsdIdStr : selectedDetailsIds) {
                    int bsdId = Integer.parseInt(bsdIdStr);
                    ReturnSlipDetail existingRsd = returnSlipDetailDAO.getReturnSlipDetailByBorrowSlipDetailId(bsdId);
                    if (existingRsd == null) {
                        BorrowSlipDetail bsd = borrowSlipDetailDAO.getBorrowSlipDetailById(bsdId);
                        ReturnSlipDetail newRsd = new ReturnSlipDetail();
                        newRsd.setBorrowSlipDetail(bsd);
                        ReturnSlip parentReturnSlip = new ReturnSlip();
                        parentReturnSlip.setId(returnSlipId);
                        newRsd.setReturnSlip(parentReturnSlip);
                        returnSlipDetailDAO.addReturnSlipDetail(newRsd);
                    }
                }
            }
        }


        float totalFine = returnSlipDAO.calculateTotalFine(returnSlipId);
        returnSlipDAO.updateTotalFineForSlip(returnSlipId, totalFine);

        ReturnSlip returnSlip = returnSlipDAO.getReturnSlipById(returnSlipId);

        // if (returnSlip == null) {
        //     request.setAttribute("message", "Error: Could not retrieve the created return slip. The slip might have been processed already or an error occurred.");
        //     // Clear the potentially invalid session attribute
        //     request.getSession().removeAttribute("returnSlipId");
        //     request.getRequestDispatcher("DocumentReturnFrm.jsp").forward(request, response);
        //     return;
        // }

        request.getSession().removeAttribute("returnSlipId");
        request.setAttribute("totalFine", totalFine);
        request.setAttribute("createdReturnSlip", returnSlip);
        request.setAttribute("readerCodeForExport", readerCode);
        request.getRequestDispatcher("ReturnSlipFrm.jsp").forward(request, response);
    }
}
