package com.lostfound.controller;

import com.lostfound.dao.BookmarkDAO;
import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.model.Item;
import com.lostfound.util.SessionUtil;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/item")
public class ItemDetailServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ItemDAO itemDAO = new ItemDAO();
    private ClaimDAO claimDAO = new ClaimDAO();
    private BookmarkDAO bookmarkDAO = new BookmarkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int itemId;

        try {
            itemId = Integer.parseInt(req.getParameter("id"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/search?error=invalidItem");
            return;
        }

        /*
         * Load the selected item before opening the detail page.
         * If the item does not exist, the user is sent back to the search page.
         */
        Item item = itemDAO.getById(itemId);

        if (item == null) {
            resp.sendRedirect(req.getContextPath() + "/search?error=invalidItem");
            return;
        }

        req.setAttribute("item", item);

        /*
         * Extra student-specific information is only checked when a user is logged in.
         * This allows the JSP to show bookmark and claim status correctly.
         */
        Integer userId = SessionUtil.getUserId(req);

        if (userId != null) {
            req.setAttribute("isBookmarked", bookmarkDAO.isBookmarked(userId, itemId));
            req.setAttribute("alreadyClaimed", claimDAO.alreadyClaimed(itemId, userId));
        }

        /*
         * Claims for this item are loaded so the detail page can show claim history
         * or admin-related claim information where needed.
         */
        req.setAttribute("claims", claimDAO.getByItem(itemId));

        req.getRequestDispatcher("/WEB-INF/views/items/itemDetail.jsp").forward(req, resp);
    }
}