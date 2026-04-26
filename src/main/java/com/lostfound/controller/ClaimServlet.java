package com.lostfound.controller;

import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.model.Claim;
import com.lostfound.model.Item;
import com.lostfound.util.SessionUtil;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

        String desc = req.getParameter("description");

        int itemId;
        try {
            itemId = Integer.parseInt(req.getParameter("itemId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/search");
            return;
        }

        Item item = itemDAO.getById(itemId);

        if (item == null || !"found".equals(item.getType()) || !"open".equals(item.getStatus())) {
            resp.sendRedirect(req.getContextPath() + "/search");
            return;
        }

        if (item.getUserId() == userId) {
            resp.sendRedirect(req.getContextPath() + "/item?id=" + itemId + "&err=own");
            return;
        }

        if (claimDAO.alreadyClaimed(itemId, userId)) {
            resp.sendRedirect(req.getContextPath() + "/item?id=" + itemId + "&err=dup");
            return;
        }

        Claim claim = new Claim();
        claim.setItemId(itemId);
        claim.setClaimantId(userId);
        claim.setDescription(desc != null ? desc.trim() : "");
        boolean saved = claimDAO.saveClaim(claim);

        if (!saved) {
            resp.sendRedirect(req.getContextPath() + "/item?id=" + itemId + "&err=claimfail");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/item?id=" + itemId + "&claimed=1");
    }
}