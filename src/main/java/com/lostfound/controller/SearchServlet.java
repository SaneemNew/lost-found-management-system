package com.lostfound.controller;

import com.lostfound.dao.CategoryDAO;
import com.lostfound.dao.ItemDAO;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ItemDAO itemDAO = new ItemDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword = req.getParameter("keyword");
        String catParam = req.getParameter("categoryId");
        String location = req.getParameter("location");

        int catId = 0;

        try {
            if (catParam != null && !catParam.trim().isEmpty()) {
                catId = Integer.parseInt(catParam);
            }
        } catch (NumberFormatException e) {
            catId = 0;
        }

        req.setAttribute("activePage", "search");

        req.setAttribute("items", itemDAO.searchFound(keyword, catId, location));
        req.setAttribute("categories", categoryDAO.getAll());
        req.setAttribute("keyword", keyword);
        req.setAttribute("catId", catId);
        req.setAttribute("location", location);

        req.getRequestDispatcher("/WEB-INF/views/items/search.jsp").forward(req, resp);
    }
}