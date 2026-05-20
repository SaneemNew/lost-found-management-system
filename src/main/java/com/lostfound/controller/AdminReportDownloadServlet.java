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

/*
 * This servlet allows the admin to download a simple CSV report.
 * CSV is used instead of an external Excel library so the project stays simple
 * and within the Servlet/JSP/JDBC coursework scope.
 */
@WebServlet("/admin/reports/download")
public class AdminReportDownloadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // DAO objects used to collect report data from the database.
    private final UserDAO userDAO = new UserDAO();
    private final ItemDAO itemDAO = new ItemDAO();
    private final ClaimDAO claimDAO = new ClaimDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Create a unique file name using the current date and time.
        String fileTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm"));
        String fileName = "CampusFind_Admin_Report_" + fileTime + ".csv";

        // Tell the browser to download the response as a CSV file.
        resp.setContentType("text/csv; charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        try (PrintWriter writer = resp.getWriter()) {

            // Report title and generated date.
            writer.println("CampusFind Admin Report");
            writer.println("Generated At,"
                    + escapeCsv(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"))));
            writer.println();

            // User summary section.
            writer.println("User Summary");
            writer.println("Metric,Count");
            writer.println("Total Users," + userDAO.countAll());
            writer.println("Approved Users," + userDAO.countByStatus("approved"));
            writer.println("Pending Users," + userDAO.countByStatus("pending"));
            writer.println("Rejected Users," + userDAO.countByStatus("rejected"));
            writer.println();

            // Item summary section.
            writer.println("Item Summary");
            writer.println("Metric,Count");
            writer.println("Total Items," + itemDAO.countAll());
            writer.println("Lost Items," + itemDAO.countByType("lost"));
            writer.println("Found Items," + itemDAO.countByType("found"));
            writer.println();

            // Claim summary section.
            writer.println("Claim Summary");
            writer.println("Metric,Count");
            writer.println("Total Claims," + claimDAO.countAll());
            writer.println("Approved Claims," + claimDAO.countByStatus("approved"));
            writer.println("Pending Claims," + claimDAO.countByStatus("pending"));
            writer.println("Rejected Claims," + claimDAO.countByStatus("rejected"));
            writer.println();

            // Top lost item categories section.
            writer.println("Top Lost Item Categories");
            writer.println("Category,Lost Reports");

            List<String[]> topCategories = itemDAO.getTopLostCategories(5);

            if (topCategories == null || topCategories.isEmpty()) {
                writer.println("No category data available,0");
            } else {
                for (String[] row : topCategories) {
                    writer.println(escapeCsv(row[0]) + "," + escapeCsv(row[1]));
                }
            }

            writer.flush();
        }
    }

    /*
     * Escapes CSV values so commas, quotes, or line breaks do not break the file.
     */
    private String escapeCsv(String value) {
        if (value == null) {
            return "";
        }

        boolean needsQuotes = value.contains(",")
                || value.contains("\"")
                || value.contains("\n")
                || value.contains("\r");

        String escaped = value.replace("\"", "\"\"");

        if (needsQuotes) {
            return "\"" + escaped + "\"";
        }

        return escaped;
    }
}