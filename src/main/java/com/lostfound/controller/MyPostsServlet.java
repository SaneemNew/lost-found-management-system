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

        // Get the logged-in user's id from session
        int userId = (int) req.getSession().getAttribute("userId");

        // Load all posts created by this user
        req.setAttribute("items", itemDAO.getByUser(userId));

        // Open the My Posts page
        req.getRequestDispatcher("/WEB-INF/views/student/myPosts.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Get the logged-in user's id and action from the form
        int userId = (int) req.getSession().getAttribute("userId");
        String action = req.getParameter("action");

        // Handle delete action when user wants to remove one of their posts
        if ("delete".equals(action)) {
            int itemId = 0;

            try {
                itemId = Integer.parseInt(req.getParameter("itemId"));
            } catch (NumberFormatException e) {
                // If item id is invalid, just return to My Posts page
                resp.sendRedirect(req.getContextPath() + "/student/myPosts");
                return;
            }

            // Delete the item only if it belongs to the current logged-in user
            itemDAO.deleteItemByUser(itemId, userId);
        }

        // Reload the page after the action is completed
        resp.sendRedirect(req.getContextPath() + "/student/myPosts");
    }
}