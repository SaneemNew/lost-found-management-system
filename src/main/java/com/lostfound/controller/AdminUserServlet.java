package com.lostfound.controller;

import com.lostfound.dao.UserDAO;
import com.lostfound.model.User;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String filter = req.getParameter("filter");

        if (filter == null) {
            filter = "all";
        }

        /*
         * Admin can either view all users or only pending users.
         * The filter value is also sent back to the JSP so the correct button
         * can be highlighted.
         */
        if ("pending".equals(filter)) {
            req.setAttribute("users", userDAO.getPendingUsers());
        } else {
            req.setAttribute("users", userDAO.getAllUsers());
        }

        req.setAttribute("filter", filter);
        req.setAttribute("activePage", "adminUsers");

        req.getRequestDispatcher("/WEB-INF/views/admin/adminUsers.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        int userId;

        try {
            userId = Integer.parseInt(req.getParameter("userId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=invalidUser");
            return;
        }

        User selectedUser = userDAO.getUserById(userId);

        if (selectedUser == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=userNotFound");
            return;
        }

        /*
         * Admin accounts should not be approved or rejected from this page.
         * This protects administrator access from accidental status changes.
         */
        if ("admin".equals(selectedUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=adminProtected");
            return;
        }

        if ("approve".equals(action)) {
            boolean updated = userDAO.updateStatus(userId, "approved");

            if (updated) {
                resp.sendRedirect(req.getContextPath() + "/admin/users?success=approved");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/users?error=updateFailed");
            }

            return;
        }

        if ("reject".equals(action)) {
            boolean updated = userDAO.updateStatus(userId, "rejected");

            if (updated) {
                resp.sendRedirect(req.getContextPath() + "/admin/users?success=rejected");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/users?error=updateFailed");
            }

            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/users?error=invalidAction");
    }
}