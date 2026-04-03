package com.lostfound.controller;

import com.lostfound.dao.BookmarkDAO;
import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    private ItemDAO     itemDAO     = new ItemDAO();
    private ClaimDAO    claimDAO    = new ClaimDAO();
    private BookmarkDAO bookmarkDAO = new BookmarkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = (int) req.getSession().getAttribute("userId");

        req.setAttribute("lostCount",     itemDAO.countByUserAndType(userId, "lost"));
        req.setAttribute("foundCount",    itemDAO.countByUserAndType(userId, "found"));
        req.setAttribute("claimCount",    claimDAO.countPendingByUser(userId));
        req.setAttribute("bookmarkCount", bookmarkDAO.countByUser(userId));
        req.setAttribute("recentItems",   itemDAO.getRecentFound(6));

        req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
    }
}