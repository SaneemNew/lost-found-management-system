package com.lostfound.controller;

import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.model.Claim;
import com.lostfound.model.Item;
import com.lostfound.util.SessionUtil;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/student/claim")
public class ClaimServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ClaimDAO claimDAO = new ClaimDAO();
    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = SessionUtil.getUserId(req);

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int itemId;

        try {
            itemId = Integer.parseInt(req.getParameter("itemId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/search?error=invalidItem");
            return;
        }

        String desc = req.getParameter("description");
        String cleanDescription = desc != null ? desc.trim() : "";

        /*
         * Claim description is required on the server side as well.
         * This prevents empty claims even if browser validation is bypassed.
         */
        if (cleanDescription.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/item?id=" + itemId + "&err=claimfail");
            return;
        }

        /*
         * A student can only claim a valid found item that is still open.
         * This prevents claims on lost items, closed items, or invalid item IDs.
         */
        Item item = itemDAO.getById(itemId);

        if (item == null || !"found".equals(item.getType()) || !"open".equals(item.getStatus())) {
            resp.sendRedirect(req.getContextPath() + "/search?error=invalidItem");
            return;
        }

        /*
         * Students should not be able to claim their own found item.
         */
        if (item.getUserId() == userId) {
            resp.sendRedirect(req.getContextPath() + "/item?id=" + itemId + "&err=own");
            return;
        }

        /*
         * Prevent duplicate claims from the same student for the same item.
         */
        if (claimDAO.alreadyClaimed(itemId, userId)) {
            resp.sendRedirect(req.getContextPath() + "/item?id=" + itemId + "&err=dup");
            return;
        }

        Claim claim = new Claim();
        claim.setItemId(itemId);
        claim.setClaimantId(userId);
        claim.setDescription(cleanDescription);

        boolean saved = claimDAO.saveClaim(claim);

        if (!saved) {
            resp.sendRedirect(req.getContextPath() + "/item?id=" + itemId + "&err=claimfail");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/item?id=" + itemId + "&claimed=1");
    }
}