package com.lostfound.controller;

import com.lostfound.dao.ItemDAO;
import com.lostfound.util.SessionUtil;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/student/myPosts")
public class MyPostsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = SessionUtil.getUserId(req);

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        /*
         * Shows only the posts created by the logged-in student.
         * The userId comes from the session, so students cannot view another
         * student's posts through this page.
         */
        req.setAttribute("myItems", itemDAO.getByUser(userId));
        req.setAttribute("activePage", "myPosts");

        req.getRequestDispatcher("/WEB-INF/views/student/myPosts.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = SessionUtil.getUserId(req);

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            try {
                int itemId = Integer.parseInt(req.getParameter("itemId"));

                /*
                 * Delete is restricted by both itemId and userId.
                 * This prevents a student from deleting another student's item.
                 */
                boolean deleted = itemDAO.deleteItemByUser(itemId, userId);

                if (deleted) {
                    resp.sendRedirect(req.getContextPath() + "/student/myPosts?success=deleted");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/student/myPosts?error=deleteFailed");
                }

                return;

            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/student/myPosts?error=invalidItem");
                return;
            }
        }

        resp.sendRedirect(req.getContextPath() + "/student/myPosts?error=invalidAction");
    }
}