package com.lostfound.controller;

import com.lostfound.dao.CategoryDAO;
import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.dao.UserDAO;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    private UserDAO     userDAO     = new UserDAO();
    private ItemDAO     itemDAO     = new ItemDAO();
    private ClaimDAO    claimDAO    = new ClaimDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("totalUsers",    userDAO.countAll());
        req.setAttribute("pendingUsers",  userDAO.countByStatus("pending"));
        req.setAttribute("activeUsers",   userDAO.countByStatus("approved"));
        req.setAttribute("totalItems",    itemDAO.countAll());
        req.setAttribute("totalClaims",   claimDAO.countAll());
        req.setAttribute("pendingClaims", claimDAO.countByStatus("pending"));
        req.setAttribute("categories",    categoryDAO.getAll());

        req.getRequestDispatcher("/WEB-INF/views/admin/adminDashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("addCategory".equals(action)) {
            String name = req.getParameter("catName");
            if (name != null && !name.trim().isEmpty()) {
                categoryDAO.addCategory(name.trim());
            }
        } else if ("deleteCategory".equals(action)) {
            try {
                int catId = Integer.parseInt(req.getParameter("catId"));
                categoryDAO.deleteCategory(catId);
            } catch (NumberFormatException e) {
                // bad input, skip
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}
