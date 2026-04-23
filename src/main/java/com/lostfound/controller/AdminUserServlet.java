package com.lostfound.controller;

import com.lostfound.dao.UserDAO;


import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String filter = req.getParameter("filter");
        if (filter == null) filter = "all";

        if ("pending".equals(filter)) {
            req.setAttribute("users", userDAO.getPendingUsers());
        } else {
            req.setAttribute("users", userDAO.getAllUsers());
        }
        req.setAttribute("filter", filter);

        req.getRequestDispatcher("/WEB-INF/views/admin/adminUsers.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        int userId = 0;
        try {
            userId = Integer.parseInt(req.getParameter("userId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        if ("approve".equals(action)) {
            userDAO.updateStatus(userId, "approved");
        } else if ("reject".equals(action)) {
            userDAO.updateStatus(userId, "rejected");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}