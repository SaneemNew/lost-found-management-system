package com.lostfound.controller;

import com.lostfound.model.User;
import com.lostfound.service.UserService;
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

        // look for saved email in cookies...
        String savedEmail = "";
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("rememberEmail".equals(c.getName())) {
                    savedEmail = c.getValue();
                    break;
                }
            }
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

        /*---------------------
        setting up the session
      	----------------------*/
        
        SessionUtil.createUserSession(req, user.getId(), user.getFullName(), user.getRole());

     // remember me cookie...
        
        if ("on".equals(remember)) {
            Cookie emailCookie = new Cookie("rememberEmail", email.trim());
            emailCookie.setMaxAge(7 * 24 * 60 * 60);
            emailCookie.setPath("/");
            resp.addCookie(emailCookie);
        } else {
            Cookie clear = new Cookie("rememberEmail", "");
            clear.setMaxAge(0);
            clear.setPath("/");
            resp.addCookie(clear);
        }

        if ("admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        }
    }
}