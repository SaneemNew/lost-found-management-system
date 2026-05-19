package com.lostfound.controller;

import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.dao.UserDAO;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO = new UserDAO();
    private ItemDAO itemDAO = new ItemDAO();
    private ClaimDAO claimDAO = new ClaimDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String download = req.getParameter("download");

        if ("csv".equalsIgnoreCase(download)) {
            downloadCsvReport(resp);
            return;
        }

        loadReportData(req);

        req.getRequestDispatcher("/WEB-INF/views/admin/adminReports.jsp").forward(req, resp);
    }

    private void loadReportData(HttpServletRequest req) {

        // user counts
        req.setAttribute("totalUsers", userDAO.countAll());
        req.setAttribute("activeUsers", userDAO.countByStatus("approved"));
        req.setAttribute("pendingUsers", userDAO.countByStatus("pending"));
        req.setAttribute("rejectedUsers", userDAO.countByStatus("rejected"));

        // item counts
        req.setAttribute("totalItems", itemDAO.countAll());
        req.setAttribute("lostItems", itemDAO.countByType("lost"));
        req.setAttribute("foundItems", itemDAO.countByType("found"));

        // claim counts
        req.setAttribute("totalClaims", claimDAO.countAll());
        req.setAttribute("approvedClaims", claimDAO.countByStatus("approved"));
        req.setAttribute("pendingClaims", claimDAO.countByStatus("pending"));
        req.setAttribute("rejectedClaims", claimDAO.countByStatus("rejected"));

        // top lost categories
        req.setAttribute("topCategories", itemDAO.getTopLostCategories(5));
    }

    private void downloadCsvReport(HttpServletResponse resp) throws IOException {

        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm"));
        String fileName = "CampusFind_Report_" + timestamp + ".csv";

        resp.setContentType("text/csv; charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        try (PrintWriter writer = resp.getWriter()) {

            writer.println("CampusFind Admin Report");
            writer.println("Generated At," + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            writer.println();

            writer.println("User Summary");
            writer.println("Metric,Count");
            writer.println("Total Users," + userDAO.countAll());
            writer.println("Approved Users," + userDAO.countByStatus("approved"));
            writer.println("Pending Users," + userDAO.countByStatus("pending"));
            writer.println("Rejected Users," + userDAO.countByStatus("rejected"));
            writer.println();

            writer.println("Item Summary");
            writer.println("Metric,Count");
            writer.println("Total Items," + itemDAO.countAll());
            writer.println("Lost Items," + itemDAO.countByType("lost"));
            writer.println("Found Items," + itemDAO.countByType("found"));
            writer.println();

            writer.println("Claim Summary");
            writer.println("Metric,Count");
            writer.println("Total Claims," + claimDAO.countAll());
            writer.println("Approved Claims," + claimDAO.countByStatus("approved"));
            writer.println("Pending Claims," + claimDAO.countByStatus("pending"));
            writer.println("Rejected Claims," + claimDAO.countByStatus("rejected"));
            writer.println();

            writer.println("Top Lost Item Categories");
            writer.println("Category,Lost Reports");

            List<String[]> topCategories = itemDAO.getTopLostCategories(5);

            if (topCategories == null || topCategories.isEmpty()) {
                writer.println("No data,0");
            } else {
                for (String[] row : topCategories) {
                    writer.println(escapeCsv(row[0]) + "," + escapeCsv(row[1]));
                }
            }
        }
    }

    private String escapeCsv(String value) {
        if (value == null) {
            return "";
        }

        String escaped = value.replace("\"", "\"\"");

        if (escaped.contains(",") || escaped.contains("\"") || escaped.contains("\n")) {
            return "\"" + escaped + "\"";
        }

        return escaped;
    }
}