package com.lostfound.controller;

import com.lostfound.dao.CategoryDAO;
import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.dao.UserDAO;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO = new UserDAO();
    private ItemDAO itemDAO = new ItemDAO();
    private ClaimDAO claimDAO = new ClaimDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        /*
         * The admin dashboard shows summary data from different parts of the system.
         * DAO classes are used here to collect counts and category data from the database.
         */
        req.setAttribute("totalUsers", userDAO.countAll());
        req.setAttribute("pendingUsers", userDAO.countByStatus("pending"));
        req.setAttribute("activeUsers", userDAO.countByStatus("approved"));

        req.setAttribute("totalItems", itemDAO.countAll());

        req.setAttribute("totalClaims", claimDAO.countAll());
        req.setAttribute("pendingClaims", claimDAO.countByStatus("pending"));

        req.setAttribute("categories", categoryDAO.getAll());
        req.setAttribute("activePage", "adminDashboard");

        req.getRequestDispatcher("/WEB-INF/views/admin/adminDashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        /*
         * Category management is handled from the admin dashboard.
         * The servlet checks the requested action and then calls the DAO method.
         */
        if ("addCategory".equals(action)) {
            String name = req.getParameter("catName");

            if (name == null || name.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?error=emptyCategory");
                return;
            }

            boolean added = categoryDAO.addCategory(name.trim());

            if (added) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?success=categoryAdded");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?error=categoryAddFailed");
            }

            return;
        }

        if ("deleteCategory".equals(action)) {
            try {
                int catId = Integer.parseInt(req.getParameter("catId"));
                boolean deleted = categoryDAO.deleteCategory(catId);

                if (deleted) {
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard?success=categoryDeleted");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard?error=categoryDeleteFailed");
                }

                return;

            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?error=invalidCategory");
                return;
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/dashboard?error=invalidAction");
    }
}