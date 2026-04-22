package com.lostfound.controller;

import com.lostfound.dao.CategoryDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.model.Item;
import com.lostfound.service.ItemService;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/student/postFound")
@MultipartConfig(maxFileSize = 5242880, maxRequestSize = 10485760)
public class PostFoundServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ItemDAO itemDAO = new ItemDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private ItemService itemService = new ItemService();

    // Only these image formats are allowed for upload
    private static final Set<String> ALLOWED_EXTENSIONS =
            new HashSet<>(Arrays.asList(".jpg", ".jpeg", ".png"));

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Load category list and open the form page
        req.setAttribute("categories", categoryDAO.getAll());
        req.getRequestDispatcher("/WEB-INF/views/student/postFound.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Read all form values submitted by the user
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String location = req.getParameter("location");
        String date = req.getParameter("dateReported");
        String catParam = req.getParameter("categoryId");

        // Validate main item fields before continuing
        String error = itemService.validateItem(title, location, date);
        if (error != null) {
            reloadForm(req, resp, error, title, description, location, date, catParam);
            return;
        }

        // Convert category value safely
        int catId = 0;
        try {
            catId = Integer.parseInt(catParam);
        } catch (Exception e) {
            catId = 0;
        }

        int userId = (int) req.getSession().getAttribute("userId");
        String imagePath = null;

        // Read uploaded image part from the form
        Part filePart = req.getPart("image");

        if (filePart != null && filePart.getSize() > 0) {
            // Get only the file name part, not the full client path
            String originalFileName = new File(filePart.getSubmittedFileName()).getName();
            String contentType = filePart.getContentType();

            if (originalFileName == null || originalFileName.trim().isEmpty()) {
                reloadForm(req, resp, "Invalid image file.", title, description, location, date, catParam);
                return;
            }

            // Make sure uploaded file has an extension
            int dotIndex = originalFileName.lastIndexOf(".");
            if (dotIndex == -1) {
                reloadForm(req, resp, "File must be an image with a valid extension.", title, description, location, date, catParam);
                return;
            }

            String extension = originalFileName.substring(dotIndex).toLowerCase();

            // Allow only jpg, jpeg, and png files
            if (!ALLOWED_EXTENSIONS.contains(extension)) {
                reloadForm(req, resp, "Only JPG, JPEG, and PNG image files are allowed.", title, description, location, date, catParam);
                return;
            }

            // Double-check MIME type as extra validation
            if (contentType == null ||
                    !(contentType.equals("image/jpeg") || contentType.equals("image/png"))) {
                reloadForm(req, resp, "Only JPG, JPEG, and PNG image files are allowed.", title, description, location, date, catParam);
                return;
            }

            // Create upload folder if it does not already exist
            String rootPath = getServletContext().getRealPath("/uploads/items");
            File uploadDir = new File(rootPath);

            if (!uploadDir.exists() && !uploadDir.mkdirs()) {
                reloadForm(req, resp, "Unable to create upload folder.", title, description, location, date, catParam);
                return;
            }

            // Generate a unique file name so files do not overwrite each other
            String uniqueIdentifier = "found_" + userId + "_" + System.currentTimeMillis();
            String newFileName = uniqueIdentifier + extension;

            String fullPath = rootPath + File.separator + newFileName;
            filePart.write(fullPath);

            // Save relative path in database
            imagePath = "uploads/items/" + newFileName;
        }

        // Create item object and fill it with submitted values
        Item item = new Item();
        item.setUserId(userId);
        item.setType("found");
        item.setTitle(title.trim());
        item.setDescription(description != null ? description.trim() : "");
        item.setCategoryId(catId);
        item.setLocation(location.trim());
        item.setDateReported(date);
        item.setImagePath(imagePath);

        boolean saved = itemDAO.saveItem(item);

        // If DB save fails, return to form with message
        if (!saved) {
            reloadForm(req, resp, "Failed to save item. Please try again.", title, description, location, date, catParam);
            return;
        }

        // On success, go back to user's posts page
        resp.sendRedirect(req.getContextPath() + "/student/myPosts");
    }

    private void reloadForm(HttpServletRequest req, HttpServletResponse resp,
                            String error, String title, String description,
                            String location, String date, String catParam)
            throws ServletException, IOException {

        int selectedCategoryId = 0;
        try {
            selectedCategoryId = Integer.parseInt(catParam);
        } catch (Exception e) {
            selectedCategoryId = 0;
        }

        // Send all old values back so user does not have to type everything again
        req.setAttribute("error", error);
        req.setAttribute("categories", categoryDAO.getAll());

        req.setAttribute("title", title);
        req.setAttribute("description", description);
        req.setAttribute("location", location);
        req.setAttribute("dateReported", date);
        req.setAttribute("selectedCategoryId", selectedCategoryId);

        req.getRequestDispatcher("/WEB-INF/views/student/postFound.jsp").forward(req, resp);
    }
}
