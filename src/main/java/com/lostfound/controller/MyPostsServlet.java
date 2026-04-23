package com.lostfound.controller;

import com.lostfound.dao.ItemDAO;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/student/myPosts")
public class MyPostsServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = (int) req.getSession().getAttribute("userId");
        req.setAttribute("items", itemDAO.getByUser(userId));
        req.getRequestDispatcher("/WEB-INF/views/student/myPosts.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = (int) req.getSession().getAttribute("userId");
        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            int itemId = 0;
            try {
                itemId = Integer.parseInt(req.getParameter("itemId"));
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/student/myPosts");
                return;
            }

            // only delete if the item belongs to this user
            itemDAO.deleteItemByUser(itemId, userId);
        }

        resp.sendRedirect(req.getContextPath() + "/student/myPosts");
    }
}