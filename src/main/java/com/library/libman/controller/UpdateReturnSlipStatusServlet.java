package com.library.libman.controller;

import java.io.IOException;

import com.library.libman.dao.ReturnSlipDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "UpdateReturnSlipStatusServlet", urlPatterns = "/update-return-slip-status")
public class UpdateReturnSlipStatusServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String returnSlipIdParam = request.getParameter("returnSlipId");
        String status = request.getParameter("status");

        if (returnSlipIdParam == null || returnSlipIdParam.isEmpty() || status == null || status.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing returnSlipId or status parameter.");
            return;
        }

        try {
            int returnSlipId = Integer.parseInt(returnSlipIdParam);
            ReturnSlipDAO returnSlipDAO = new ReturnSlipDAO();
            returnSlipDAO.updateReturnSlipStatus(returnSlipId, status);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Return slip status updated successfully.");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid returnSlipId format.");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
        }
    }
}
