package com.lostfound.controller;

import com.lostfound.dao.ItemDAO;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/items")
public class AdminItemServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        /*
         * Admin can view all lost and found item posts from this page.
         * The DAO retrieves the item list from the database.
         */
        req.setAttribute("items", itemDAO.getAllItems());
        req.setAttribute("activePage", "adminItems");

        req.getRequestDispatcher("/WEB-INF/views/admin/adminItems.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        int itemId;

        try {
            itemId = Integer.parseInt(req.getParameter("itemId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/items?error=invalidItem");
            return;
        }

        /*
         * Delete removes the selected item record from the system.
         * The actual SQL operation is handled by ItemDAO.
         */
        if ("delete".equals(action)) {
            boolean deleted = itemDAO.deleteItem(itemId);

            if (deleted) {
                resp.sendRedirect(req.getContextPath() + "/admin/items?success=deleted");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/items?error=deleteFailed");
            }

            return;
        }

        /*
         * Admin can change item status only to valid system statuses.
         * This protects the database from invalid status values.
         */
        if ("changeStatus".equals(action)) {
            String newStatus = req.getParameter("newStatus");

            if (!"open".equals(newStatus)
                    && !"claimed".equals(newStatus)
                    && !"resolved".equals(newStatus)) {

                resp.sendRedirect(req.getContextPath() + "/admin/items?error=invalidStatus");
                return;
            }

            boolean updated = itemDAO.updateStatus(itemId, newStatus);

            if (updated) {
                resp.sendRedirect(req.getContextPath() + "/admin/items?success=statusUpdated");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/items?error=statusUpdateFailed");
            }

            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/items?error=invalidAction");
    }
}