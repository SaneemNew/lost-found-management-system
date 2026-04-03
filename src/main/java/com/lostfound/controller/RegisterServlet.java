package com.lostfound.controller;

import com.lostfound.service.UserService;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName       = req.getParameter("fullName");
        String email          = req.getParameter("email");
        String studentId      = req.getParameter("studentId");
        String phone          = req.getParameter("phone");
        String password       = req.getParameter("password");
        String confirmPass    = req.getParameter("confirmPassword");

        String error = userService.validateRegistration(fullName, email, studentId, password, confirmPass);

        if (error != null) {
            req.setAttribute("error", error);
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        boolean saved = userService.register(fullName, email, studentId, phone, password);

        if (!saved) {
            req.setAttribute("error", "Registration failed, please try again.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/auth/pending.jsp").forward(req, resp);
    }
}