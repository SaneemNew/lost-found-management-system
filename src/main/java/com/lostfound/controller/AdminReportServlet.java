package com.lostfound.controller;


import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.dao.UserDAO;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    private UserDAO  userDAO  = new UserDAO();
    private ItemDAO  itemDAO  = new ItemDAO();
    private ClaimDAO claimDAO = new ClaimDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // user counts
        req.setAttribute("totalUsers",    userDAO.countAll());
        req.setAttribute("activeUsers",   userDAO.countByStatus("approved"));
        req.setAttribute("pendingUsers",  userDAO.countByStatus("pending"));
        req.setAttribute("rejectedUsers", userDAO.countByStatus("rejected"));

        // item counts
        req.setAttribute("totalItems", itemDAO.countAll());
        req.setAttribute("lostItems",  itemDAO.countByType("lost"));
        req.setAttribute("foundItems", itemDAO.countByType("found"));

        // claim counts
        req.setAttribute("totalClaims",    claimDAO.countAll());
        req.setAttribute("approvedClaims", claimDAO.countByStatus("approved"));
        req.setAttribute("pendingClaims",  claimDAO.countByStatus("pending"));
        req.setAttribute("rejectedClaims", claimDAO.countByStatus("rejected"));

        // top lost categories
        req.setAttribute("topCategories", itemDAO.getTopLostCategories(5));

        req.getRequestDispatcher("/WEB-INF/views/admin/adminReports.jsp").forward(req, resp);
    }
}