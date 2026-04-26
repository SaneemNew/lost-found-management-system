package com.lostfound.controller;

import com.lostfound.dao.BookmarkDAO;
import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.model.Item;
import com.lostfound.util.SessionUtil;

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

        int itemId = 0;
        try {
            itemId = Integer.parseInt(req.getParameter("id"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/search");
            return;
        }

        Item item = itemDAO.getById(itemId);
        if (item == null) {
            resp.sendRedirect(req.getContextPath() + "/search");
            return;
        }

        req.setAttribute("item", item);

        Integer userId = SessionUtil.getUserId(req);
        if (userId != null) {
            req.setAttribute("isBookmarked", bookmarkDAO.isBookmarked(userId, itemId));
            req.setAttribute("alreadyClaimed", claimDAO.alreadyClaimed(itemId, userId));
        }

        req.setAttribute("claims", claimDAO.getByItem(itemId));
        req.getRequestDispatcher("/WEB-INF/views/items/itemDetail.jsp").forward(req, resp);
    }
}