package com.lostfound.controller;

import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.model.Claim;
import com.lostfound.model.Item;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/student/claim")
public class ClaimServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    private ClaimDAO claimDAO = new ClaimDAO();
    private ItemDAO  itemDAO  = new ItemDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId  = (int) req.getSession().getAttribute("userId");
        String desc = req.getParameter("description");

        int itemId = 0;
        try {
            itemId = Integer.parseInt(req.getParameter("itemId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/search");
            return;
        }

        Item item = itemDAO.getById(itemId);

        // make sure item exists and is a found item
        if (item == null || !"found".equals(item.getType())) {
            resp.sendRedirect(req.getContextPath() + "/search");
            return;
        }

        // can't claim your own post
        if (item.getUserId() == userId) {
            resp.sendRedirect(req.getContextPath() + "/item?id=" + itemId + "&err=own");
            return;
        }

        // no duplicate claims
        if (claimDAO.alreadyClaimed(itemId, userId)) {
            resp.sendRedirect(req.getContextPath() + "/item?id=" + itemId + "&err=dup");
            return;
        }

        Claim claim = new Claim();
        claim.setItemId(itemId);
        claim.setClaimantId(userId);
        claim.setDescription(desc != null ? desc.trim() : "");
        claimDAO.saveClaim(claim);

        resp.sendRedirect(req.getContextPath() + "/item?id=" + itemId + "&claimed=1");
    }
}