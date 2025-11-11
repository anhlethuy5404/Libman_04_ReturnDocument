package com.library.libman.controller;

import com.library.libman.dao.ReaderDAO;
import com.library.libman.model.Reader;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "ReaderServlet", urlPatterns = "/search-reader")
public class ReaderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String readerCode = request.getParameter("readerCode");
        if (readerCode != null && !readerCode.equals("")) {
            ReaderDAO readerDAO = new ReaderDAO();
            Reader reader = readerDAO.searchReaderByReaderCode(readerCode);
            request.setAttribute("foundReader", reader);
        }
        request.getRequestDispatcher("DocumentReturnFrm.jsp").forward(request, response);
    }
}
