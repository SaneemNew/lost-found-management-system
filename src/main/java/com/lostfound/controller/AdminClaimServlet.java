package com.lostfound.controller;

import java.io.IOException;

import com.lostfound.dao.ClaimDAO;
import com.lostfound.model.Claim;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/claims")
public class AdminClaimServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ClaimDAO claimDAO = new ClaimDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("claims", claimDAO.getAllClaims());
        req.setAttribute("activePage", "adminClaims");

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
            resp.sendRedirect(req.getContextPath() + "/admin/claims?error=invalidClaim");
            return;
        }

        Claim claim = claimDAO.getById(claimId);

        if (claim == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/claims?error=invalidClaim");
            return;
        }

        if (!"pending".equals(claim.getStatus())) {
            resp.sendRedirect(req.getContextPath() + "/admin/claims?error=invalidClaim");
            return;
        }

        if ("approve".equals(action)) {
            /*
             * Approving a claim affects more than one table.
             * The DAO handles this in a transaction so the claim, item,
             * and other related claim statuses stay consistent.
             */
            boolean approved = claimDAO.approveClaimWithTransaction(claimId);

            if (approved) {
                resp.sendRedirect(req.getContextPath() + "/admin/claims?success=approved");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/claims?error=approveFailed");
            }
            return;
        }

        if ("reject".equals(action)) {
            boolean rejected = claimDAO.updateStatus(claimId, "rejected");

            if (rejected) {
                resp.sendRedirect(req.getContextPath() + "/admin/claims?success=rejected");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/claims?error=rejectFailed");
            }
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/claims?error=invalidAction");
    }
}