package com.lostfound.controller;

import com.lostfound.dao.BookmarkDAO;
import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.util.SessionUtil;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ItemDAO itemDAO = new ItemDAO();
    private ClaimDAO claimDAO = new ClaimDAO();
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
         * The dashboard shows summary information for the logged-in student.
         * Counts are based on the session userId so each student only sees
         * their own activity.
         */
        req.setAttribute("lostCount", itemDAO.countByUserAndType(userId, "lost"));
        req.setAttribute("foundCount", itemDAO.countByUserAndType(userId, "found"));
        req.setAttribute("claimCount", claimDAO.countPendingByUser(userId));
        req.setAttribute("bookmarkCount", bookmarkDAO.countByUser(userId));

        /*
         * Only the latest few found items are shown to keep the dashboard clean.
         * Full browsing is handled by the search page.
         */
        req.setAttribute("recentItems", itemDAO.getRecentFound(3));
        req.setAttribute("activePage", "studentDashboard");

        req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
    }
}