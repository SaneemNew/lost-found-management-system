package com.lostfound.controller;

import com.lostfound.model.User;
import com.lostfound.service.UserService;
import com.lostfound.util.CookieUtil;
import com.lostfound.util.SessionUtil;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        /*
         * If a logged-in user opens the login page again, redirect them to
         * the correct dashboard instead of showing the login form.
         */
        Integer userId = SessionUtil.getUserId(req);
        String role = SessionUtil.getRole(req);

        if (userId != null) {
            if ("admin".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            }
            return;
        }

        /*
         * If the user selected "remember me" earlier, the saved email is loaded
         * from the cookie and shown in the login form.
         */
        String savedEmail = CookieUtil.getCookieValue(req, "rememberEmail");

        if (savedEmail == null) {
            savedEmail = "";
        }

        req.setAttribute("savedEmail", savedEmail);
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");

        String cleanEmail = email != null ? email.trim().toLowerCase() : "";

        /*
         * Basic server-side validation is done before checking the database.
         */
        if (cleanEmail.isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Please fill in all fields.");
            req.setAttribute("savedEmail", cleanEmail);
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

        User user = userService.checkLogin(cleanEmail, password);

        if (user == null) {
            req.setAttribute("error", "Incorrect email or password.");
            req.setAttribute("savedEmail", cleanEmail);
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

        /*
         * Student accounts must be approved by an admin before login is allowed.
         */
        if ("pending".equals(user.getStatus())) {
            req.setAttribute("error", "Your account is still waiting for admin approval.");
            req.setAttribute("savedEmail", cleanEmail);
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

        if ("rejected".equals(user.getStatus())) {
            req.setAttribute("error", "Your account was not approved. Contact support for help.");
            req.setAttribute("savedEmail", cleanEmail);
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

        /*
         * After successful login, only safe user details are stored in session.
         * The password is never stored in the session.
         */
        SessionUtil.createUserSession(
                req,
                user.getId(),
                user.getFullName(),
                user.getEmail(),
                user.getRole()
        );

        /*
         * Remember-me only stores the email for convenience.
         * It does not store password or authentication tokens.
         */
        if ("on".equals(remember)) {
            CookieUtil.addCookie(resp, "rememberEmail", cleanEmail, 7 * 24 * 60 * 60);
        } else {
            CookieUtil.deleteCookie(resp, "rememberEmail");
        }

        /*
         * Redirect users based on their role.
         */
        if ("admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        }
    }
}