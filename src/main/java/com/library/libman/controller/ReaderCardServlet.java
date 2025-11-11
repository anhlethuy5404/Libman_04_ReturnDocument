package com.library.libman.controller;

import com.library.libman.dao.ReaderCardDAO;
import com.library.libman.model.Reader;
import com.library.libman.model.ReaderCard;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

@WebServlet(name = "ReaderCardServlet", urlPatterns = {"/reader-card-register"})
public class ReaderCardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("CardRegistration.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String birthdayStr = request.getParameter("birthday");
        String cardType = request.getParameter("cardType");
        String durationStr = request.getParameter("duration");

        String message = "";

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date birthday = sdf.parse(birthdayStr);
            int duration = Integer.parseInt(durationStr);

            HttpSession session = request.getSession();
            Reader reader = (Reader) session.getAttribute("user");

            if (reader == null) {
                message = "Error: Login first";
                request.setAttribute("message", message);
                request.getRequestDispatcher("CardRegistration.jsp").forward(request, response);
                return;
            }

            ReaderCard card = new ReaderCard();
            card.setName(name);
            card.setBirthday(birthday);
            card.setCardType(cardType);
            card.setReader(reader);

            Date registerDate = new Date();
            card.setRegisterDate(registerDate);

            Calendar cal = Calendar.getInstance();
            cal.setTime(registerDate);
            cal.add(Calendar.YEAR, duration);
            Date expiryDate = cal.getTime();
            card.setExpiryDate(expiryDate);

            ReaderCardDAO dao = new ReaderCardDAO();
            boolean success = dao.registerCard(card);

            if (success) {
                message = "Successfully card registration!";
            } else {
                message = "Card registration failed!";
            }

        } catch (ParseException e) {
            message = "Error: Invalid birthday format. Please use yyyy-MM-dd.";
        } catch (NumberFormatException e) {
            message = "Error: Invalid duration";
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
            e.printStackTrace();
        }

        request.setAttribute("message", message);
        request.getRequestDispatcher("CardRegistration.jsp").forward(request, response);
    }
}
