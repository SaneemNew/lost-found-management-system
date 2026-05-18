package com.lostfound.controller;

import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.dao.UserDAO;
import com.lostfound.model.Item;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/home", "/about"})
public class PageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ItemDAO itemDAO = new ItemDAO();
    private ClaimDAO claimDAO = new ClaimDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/about".equals(path)) {
            req.setAttribute("activePage", "about");
            req.getRequestDispatcher("/WEB-INF/views/about.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("activePage", "home");

        int lostItemCount = itemDAO.countByType("lost");
        int foundItemCount = itemDAO.countByType("found");
        int claimCount = claimDAO.countAll();
        int userCount = userDAO.countAll();

        List<Item> recentFoundItems = itemDAO.getRecentFound(3);

        req.setAttribute("lostItemCount", lostItemCount);
        req.setAttribute("foundItemCount", foundItemCount);
        req.setAttribute("claimCount", claimCount);
        req.setAttribute("userCount", userCount);
        req.setAttribute("recentFoundItems", recentFoundItems);

        req.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(req, resp);
    }
}