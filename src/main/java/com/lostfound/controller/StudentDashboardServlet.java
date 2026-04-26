package com.lostfound.controller;

import com.lostfound.dao.BookmarkDAO;
import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.util.SessionUtil;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

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

        req.setAttribute("lostCount", itemDAO.countByUserAndType(userId, "lost"));
        req.setAttribute("foundCount", itemDAO.countByUserAndType(userId, "found"));
        req.setAttribute("claimCount", claimDAO.countPendingByUser(userId));
        req.setAttribute("bookmarkCount", bookmarkDAO.countByUser(userId));
        req.setAttribute("recentItems", itemDAO.getRecentFound(6));

        req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
    }
}