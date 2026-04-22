package com.lostfound.controller;

import com.lostfound.dao.BookmarkDAO;
import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.model.Item;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/item")
public class ItemDetailServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ItemDAO itemDAO = new ItemDAO();
    private ClaimDAO claimDAO = new ClaimDAO();
    private BookmarkDAO bookmarkDAO = new BookmarkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Read item id from the URL
        int itemId = 0;
        try {
            itemId = Integer.parseInt(req.getParameter("id"));
        } catch (NumberFormatException e) {
            // If id is missing or invalid, send user back to search page
            resp.sendRedirect(req.getContextPath() + "/search");
            return;
        }

        // Fetch the selected item from database
        Item item = itemDAO.getById(itemId);
        if (item == null) {
            // If item does not exist, return to search page
            resp.sendRedirect(req.getContextPath() + "/search");
            return;
        }

        // Send item details to JSP
        req.setAttribute("item", item);

        // If user is logged in, check bookmark and claim status for this item
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            int userId = (int) session.getAttribute("userId");

            req.setAttribute("isBookmarked", bookmarkDAO.isBookmarked(userId, itemId));
            req.setAttribute("alreadyClaimed", claimDAO.alreadyClaimed(itemId, userId));
        }

        // Open the item detail page
        req.getRequestDispatcher("/WEB-INF/views/items/itemDetail.jsp").forward(req, resp);
    }
}
