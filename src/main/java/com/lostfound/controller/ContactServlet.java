package com.lostfound.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        /*
         * Opens the contact page.
         * The activePage value is used only for navbar highlighting.
         */
        req.setAttribute("activePage", "contact");
        req.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String message = req.getParameter("message");

        req.setAttribute("activePage", "contact");

        /*
         * The contact page is a simple inquiry form.
         * Messages are not stored in the database in this version, so validation
         * is done before showing the confirmation page.
         */
        if (fullName == null || fullName.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || message == null || message.trim().isEmpty()) {

            req.setAttribute("error", "Please fill in all fields before sending your message.");
            req.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(req, resp);
            return;
        }

        /*
         * Keep the submitted name so the success page can show a friendly
         * confirmation message to the user.
         */
        req.setAttribute("fullName", fullName.trim());
        req.getRequestDispatcher("/WEB-INF/views/contactSuccess.jsp").forward(req, resp);
    }
}