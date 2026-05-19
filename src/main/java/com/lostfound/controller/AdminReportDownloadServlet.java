package com.lostfound.controller;

import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.dao.UserDAO;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet("/admin/reports/download")
public class AdminReportDownloadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAO();
    private final ItemDAO itemDAO = new ItemDAO();
    private final ClaimDAO claimDAO = new ClaimDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int totalUsers = userDAO.countAll();
        int approvedUsers = userDAO.countByStatus("approved");
        int pendingUsers = userDAO.countByStatus("pending");
        int rejectedUsers = userDAO.countByStatus("rejected");

        int totalItems = itemDAO.countAll();
        int lostItems = itemDAO.countByType("lost");
        int foundItems = itemDAO.countByType("found");

        int totalClaims = claimDAO.countAll();
        int approvedClaims = claimDAO.countByStatus("approved");
        int pendingClaims = claimDAO.countByStatus("pending");
        int rejectedClaims = claimDAO.countByStatus("rejected");

        List<String[]> topCategories = itemDAO.getTopLostCategories(5);

        String fileTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm"));
        String fileName = "CampusFind_Admin_Report_" + fileTime + ".xlsx";

        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        try (Workbook workbook = new XSSFWorkbook()) {

            Sheet sheet = workbook.createSheet("Admin Report");

            CellStyle titleStyle = createTitleStyle(workbook);
            CellStyle generatedLabelStyle = createGeneratedLabelStyle(workbook);
            CellStyle generatedValueStyle = createGeneratedValueStyle(workbook);
            CellStyle sectionStyle = createSectionStyle(workbook);
            CellStyle headerStyle = createHeaderStyle(workbook);
            CellStyle textStyle = createTextStyle(workbook);
            CellStyle numberStyle = createNumberStyle(workbook);

            int rowNum = 0;

            Row titleRow = sheet.createRow(rowNum++);
            titleRow.setHeightInPoints(32);
            createCell(titleRow, 0, "CampusFind Admin Report", titleStyle);
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 3));

            Row generatedRow = sheet.createRow(rowNum++);
            generatedRow.setHeightInPoints(22);
            createCell(generatedRow, 0, "Generated At", generatedLabelStyle);
            createCell(generatedRow, 1,
                    LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")),
                    generatedValueStyle);
            sheet.addMergedRegion(new CellRangeAddress(1, 1, 1, 3));

            rowNum++;

            rowNum = addSection(
                    sheet,
                    rowNum,
                    "User Summary",
                    sectionStyle,
                    headerStyle,
                    textStyle,
                    numberStyle,
                    new String[][] {
                            {"Total Users", String.valueOf(totalUsers)},
                            {"Approved Users", String.valueOf(approvedUsers)},
                            {"Pending Users", String.valueOf(pendingUsers)},
                            {"Rejected Users", String.valueOf(rejectedUsers)}
                    }
            );

            rowNum++;

            rowNum = addSection(
                    sheet,
                    rowNum,
                    "Item Summary",
                    sectionStyle,
                    headerStyle,
                    textStyle,
                    numberStyle,
                    new String[][] {
                            {"Total Items", String.valueOf(totalItems)},
                            {"Lost Items", String.valueOf(lostItems)},
                            {"Found Items", String.valueOf(foundItems)}
                    }
            );

            rowNum++;

            rowNum = addSection(
                    sheet,
                    rowNum,
                    "Claim Summary",
                    sectionStyle,
                    headerStyle,
                    textStyle,
                    numberStyle,
                    new String[][] {
                            {"Total Claims", String.valueOf(totalClaims)},
                            {"Approved Claims", String.valueOf(approvedClaims)},
                            {"Pending Claims", String.valueOf(pendingClaims)},
                            {"Rejected Claims", String.valueOf(rejectedClaims)}
                    }
            );

            rowNum++;

            Row topSectionRow = sheet.createRow(rowNum++);
            topSectionRow.setHeightInPoints(24);
            createCell(topSectionRow, 0, "Top Lost Item Categories", sectionStyle);
            sheet.addMergedRegion(new CellRangeAddress(rowNum - 1, rowNum - 1, 0, 1));

            Row topHeaderRow = sheet.createRow(rowNum++);
            topHeaderRow.setHeightInPoints(22);
            createCell(topHeaderRow, 0, "Category", headerStyle);
            createCell(topHeaderRow, 1, "Lost Reports", headerStyle);

            if (topCategories == null || topCategories.isEmpty()) {
                Row emptyRow = sheet.createRow(rowNum++);
                emptyRow.setHeightInPoints(21);
                createCell(emptyRow, 0, "No category data available", textStyle);
                createCell(emptyRow, 1, 0, numberStyle);
            } else {
                for (String[] categoryRow : topCategories) {
                    Row dataRow = sheet.createRow(rowNum++);
                    dataRow.setHeightInPoints(21);
                    createCell(dataRow, 0, categoryRow[0], textStyle);
                    createCell(dataRow, 1, Integer.parseInt(categoryRow[1]), numberStyle);
                }
            }

            sheet.setColumnWidth(0, 7800);
            sheet.setColumnWidth(1, 4200);
            sheet.setColumnWidth(2, 3200);
            sheet.setColumnWidth(3, 3200);

            workbook.write(resp.getOutputStream());
        }
    }

    private int addSection(
            Sheet sheet,
            int rowNum,
            String sectionTitle,
            CellStyle sectionStyle,
            CellStyle headerStyle,
            CellStyle textStyle,
            CellStyle numberStyle,
            String[][] data
    ) {
        Row sectionRow = sheet.createRow(rowNum++);
        sectionRow.setHeightInPoints(24);
        createCell(sectionRow, 0, sectionTitle, sectionStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum - 1, rowNum - 1, 0, 1));

        Row headerRow = sheet.createRow(rowNum++);
        headerRow.setHeightInPoints(22);
        createCell(headerRow, 0, "Metric", headerStyle);
        createCell(headerRow, 1, "Count", headerStyle);

        for (String[] item : data) {
            Row row = sheet.createRow(rowNum++);
            row.setHeightInPoints(21);
            createCell(row, 0, item[0], textStyle);
            createCell(row, 1, Integer.parseInt(item[1]), numberStyle);
        }

        return rowNum;
    }

    private void createCell(Row row, int column, String value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }

    private void createCell(Row row, int column, int value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }

    private CellStyle createTitleStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();

        Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 18);
        font.setColor(IndexedColors.WHITE.getIndex());

        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);

        return style;
    }

    private CellStyle createGeneratedLabelStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();

        Font font = workbook.createFont();
        font.setBold(true);
        font.setColor(IndexedColors.DARK_BLUE.getIndex());

        style.setFont(font);
        style.setVerticalAlignment(VerticalAlignment.CENTER);

        return style;
    }

    private CellStyle createGeneratedValueStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();

        Font font = workbook.createFont();
        font.setColor(IndexedColors.DARK_BLUE.getIndex());

        style.setFont(font);
        style.setVerticalAlignment(VerticalAlignment.CENTER);

        return style;
    }

    private CellStyle createSectionStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();

        Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 13);
        font.setColor(IndexedColors.WHITE.getIndex());

        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.BLUE_GREY.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setVerticalAlignment(VerticalAlignment.CENTER);

        return style;
    }

    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();

        Font font = workbook.createFont();
        font.setBold(true);
        font.setColor(IndexedColors.WHITE.getIndex());

        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);

        addBorders(style);

        return style;
    }

    private CellStyle createTextStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();

        style.setVerticalAlignment(VerticalAlignment.CENTER);
        addBorders(style);

        return style;
    }

    private CellStyle createNumberStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();

        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        addBorders(style);

        return style;
    }

    private void addBorders(CellStyle style) {
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);

        style.setTopBorderColor(IndexedColors.GREY_40_PERCENT.getIndex());
        style.setBottomBorderColor(IndexedColors.GREY_40_PERCENT.getIndex());
        style.setLeftBorderColor(IndexedColors.GREY_40_PERCENT.getIndex());
        style.setRightBorderColor(IndexedColors.GREY_40_PERCENT.getIndex());
    }
}