package com.lostfound.controller;

import java.io.IOException;

import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.model.Claim;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/admin/claims")
public class AdminClaimServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ClaimDAO claimDAO = new ClaimDAO();
    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("claims", claimDAO.getAllClaims());
        req.getRequestDispatcher("/WEB-INF/views/admin/adminClaims.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        int claimId;
        try {
            claimId = Integer.parseInt(req.getParameter("claimId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/claims");
            return;
        }

        Claim claim = claimDAO.getById(claimId);
        if (claim == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/claims");
            return;
        }
        
        if (!"pending".equals(claim.getStatus())) {
            resp.sendRedirect(req.getContextPath() + "/admin/claims");
            return;
        }

        if ("approve".equals(action)) {
            boolean claimUpdated = claimDAO.updateStatus(claimId, "approved");
            boolean itemUpdated = itemDAO.updateStatus(claim.getItemId(), "claimed");

            if (claimUpdated && itemUpdated) {
                claimDAO.rejectOtherPendingClaims(claim.getItemId(), claimId);
            }

        } else if ("reject".equals(action)) {
            claimDAO.updateStatus(claimId, "rejected");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/claims");
    }
}