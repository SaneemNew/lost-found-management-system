package com.lostfound.controller;

import com.lostfound.service.UserService;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String studentId = req.getParameter("studentId");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirmPass = req.getParameter("confirmPassword");

        /*
         * Registration validation is handled in the service layer.
         * This keeps validation and duplicate-checking logic separate from
         * the servlet/controller.
         */
        String error = userService.validateRegistration(
                fullName,
                email,
                studentId,
                phone,
                password,
                confirmPass
        );

        if (error != null) {
            req.setAttribute("error", error);

            /*
             * Keep entered values on the form after validation fails.
             * Passwords are not sent back for safety.
             */
            req.setAttribute("fullName", fullName);
            req.setAttribute("email", email);
            req.setAttribute("studentId", studentId);
            req.setAttribute("phone", phone);

            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        /*
         * New student accounts are saved through the service layer.
         * The service/DAO handles password hashing and database insertion.
         */
        boolean saved = userService.register(fullName, email, studentId, phone, password);

        if (!saved) {
            req.setAttribute("error", "Registration failed, please try again.");

            req.setAttribute("fullName", fullName);
            req.setAttribute("email", email);
            req.setAttribute("studentId", studentId);
            req.setAttribute("phone", phone);

            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        /*
         * After successful registration, the student is shown the pending page.
         * Admin approval is required before the student can log in.
         */
        req.getRequestDispatcher("/WEB-INF/views/auth/pending.jsp").forward(req, resp);
    }
}