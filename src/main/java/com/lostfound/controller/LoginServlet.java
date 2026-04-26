package com.lostfound.controller;

import com.lostfound.model.User;
import com.lostfound.service.UserService;
import com.lostfound.util.CookieUtil;
import com.lostfound.util.SessionUtil;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

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

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Please fill in all fields.");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

        User user = userService.checkLogin(email, password);

        if (user == null) {
            req.setAttribute("error", "Incorrect email or password.");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

        if ("pending".equals(user.getStatus())) {
            req.setAttribute("error", "Your account is still waiting for admin approval.");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

        if ("rejected".equals(user.getStatus())) {
            req.setAttribute("error", "Your account was not approved. Contact support for help.");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

        SessionUtil.createUserSession(req, user.getId(), user.getFullName(), user.getEmail(), user.getRole());

        if ("on".equals(remember)) {
            CookieUtil.addCookie(resp, "rememberEmail", email.trim(), 7 * 24 * 60 * 60);
        } else {
            CookieUtil.deleteCookie(resp, "rememberEmail");
        }

        if ("admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        }
    }
}