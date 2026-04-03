package com.lostfound.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // remove the cookie
        Cookie clear = new Cookie("rememberEmail", "");
        clear.setMaxAge(0);
        clear.setPath("/");
        resp.addCookie(clear);

        resp.sendRedirect(req.getContextPath() + "/login");
    }
}