package com.lostfound.controller;

import com.lostfound.dao.BookmarkDAO;
import com.lostfound.util.SessionUtil;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/student/bookmark", "/student/bookmarks"})
public class BookmarkServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BookmarkDAO bookmarkDAO = new BookmarkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = SessionUtil.getUserId(req);

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        /*
         * This page shows all items bookmarked by the logged-in student.
         * The userId is taken from the session so students only see their own bookmarks.
         */
        req.setAttribute("items", bookmarkDAO.getBookmarkedItems(userId));
        req.setAttribute("activePage", "bookmarks");

        req.getRequestDispatcher("/WEB-INF/views/student/bookmarks.jsp").forward(req, resp);
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
        int itemId;

        try {
            itemId = Integer.parseInt(req.getParameter("itemId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/search?error=invalidItem");
            return;
        }

        /*
         * Bookmark actions are simple add/remove operations.
         * Invalid actions are rejected instead of being silently ignored.
         */
        if ("add".equals(action)) {
            bookmarkDAO.addBookmark(userId, itemId);

        } else if ("remove".equals(action)) {
            bookmarkDAO.removeBookmark(userId, itemId);

        } else {
            resp.sendRedirect(req.getContextPath() + "/item?id=" + itemId);
            return;
        }

        /*
         * After adding or removing a bookmark, send the student back to the page
         * they came from only if it belongs to the same application.
         * Otherwise, fall back to the item detail page.
         */
        String ref = req.getHeader("Referer");
        String contextPath = req.getContextPath();

        if (ref != null && ref.contains(contextPath)) {
            resp.sendRedirect(ref);
        } else {
            resp.sendRedirect(contextPath + "/item?id=" + itemId);
        }
    }
}