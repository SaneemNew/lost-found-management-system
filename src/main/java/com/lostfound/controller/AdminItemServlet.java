package com.lostfound.controller;

import com.lostfound.dao.ItemDAO;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/admin/items")
public class AdminItemServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("items", itemDAO.getAllItems());
        req.getRequestDispatcher("/WEB-INF/views/admin/adminItems.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        int itemId = 0;
        try {
            itemId = Integer.parseInt(req.getParameter("itemId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/items");
            return;
        }

        if ("delete".equals(action)) {
            itemDAO.deleteItem(itemId);
        } else if ("changeStatus".equals(action)) {
            String newStatus = req.getParameter("newStatus");
            if (newStatus != null) {
                itemDAO.updateStatus(itemId, newStatus);
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/items");
    }
}