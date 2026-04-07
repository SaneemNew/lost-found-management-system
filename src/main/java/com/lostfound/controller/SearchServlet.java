package com.lostfound.controller;

import com.lostfound.dao.CategoryDAO;
import com.lostfound.dao.ItemDAO;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    private ItemDAO     itemDAO     = new ItemDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword  = req.getParameter("keyword");
        String catParam = req.getParameter("categoryId");
        String location = req.getParameter("location");

        int catId = 0;
        try {
            if (catParam != null && !catParam.isEmpty())
                catId = Integer.parseInt(catParam);
        } catch (NumberFormatException e) {
            catId = 0;
        }

        req.setAttribute("items",      itemDAO.searchFound(keyword, catId, location));
        req.setAttribute("categories", categoryDAO.getAll());
        req.setAttribute("keyword",    keyword);
        req.setAttribute("catId",      catId);
        req.setAttribute("location",   location);

        req.getRequestDispatcher("/WEB-INF/views/items/search.jsp").forward(req, resp);
    }
}