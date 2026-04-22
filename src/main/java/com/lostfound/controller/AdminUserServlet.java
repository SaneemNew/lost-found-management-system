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

        // Read filter from URL, default is all users
        String filter = req.getParameter("filter");
        if (filter == null) {
            filter = "all";
        }

        // Show only pending users if filter is pending, otherwise show all users
        if ("pending".equals(filter)) {
            req.setAttribute("users", userDAO.getPendingUsers());
        } else {
            req.setAttribute("users", userDAO.getAllUsers());
        }

        // Send current filter to JSP so active button/state can be shown
        req.setAttribute("filter", filter);

        // Open admin user management page
        req.getRequestDispatcher("/WEB-INF/views/admin/adminUsers.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Get action and selected user id from form
        String action = req.getParameter("action");
        int userId = 0;

        try {
            userId = Integer.parseInt(req.getParameter("userId"));
        } catch (NumberFormatException e) {
            // If invalid user id is received, return back to user management page
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        // Admin can only approve or reject users
        if ("approve".equals(action)) {
            userDAO.updateStatus(userId, "approved");
        } else if ("reject".equals(action)) {
            userDAO.updateStatus(userId, "rejected");
        }

        // Reload page after status update
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}