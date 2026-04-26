package com.lostfound.controller;

import com.lostfound.dao.BookmarkDAO;
import com.lostfound.util.SessionUtil;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

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

        req.setAttribute("items", bookmarkDAO.getBookmarkedItems(userId));
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

        int itemId = 0;
        try {
            itemId = Integer.parseInt(req.getParameter("itemId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/search");
            return;
        }

        if ("add".equals(action)) {
            bookmarkDAO.addBookmark(userId, itemId);
        } else if ("remove".equals(action)) {
            bookmarkDAO.removeBookmark(userId, itemId);
        }

        String ref = req.getHeader("Referer");
        if (ref != null) {
            resp.sendRedirect(ref);
        } else {
            resp.sendRedirect(req.getContextPath() + "/item?id=" + itemId);
        }
    }
}