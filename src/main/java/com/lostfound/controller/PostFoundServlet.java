package com.lostfound.controller;

import com.lostfound.dao.CategoryDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.model.Item;
import com.lostfound.service.ItemService;
import com.lostfound.util.SessionUtil;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(maxFileSize = 5242880, maxRequestSize = 10485760)
public class PostFoundServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ItemDAO itemDAO = new ItemDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private ItemService itemService = new ItemService();

    private static final Set<String> ALLOWED_EXTENSIONS =
            new HashSet<>(Arrays.asList(".jpg", ".jpeg", ".png"));

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        /*
         * Load categories before opening the found-item form.
         * The student must select one valid category for the item.
         */
        req.setAttribute("categories", categoryDAO.getAll());
        req.setAttribute("activePage", "postFound");

        req.getRequestDispatcher("/WEB-INF/views/student/postFound.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = SessionUtil.getUserId(req);

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String location = req.getParameter("location");
        String date = req.getParameter("dateReported");
        String catParam = req.getParameter("categoryId");

        /*
         * Common item validation is handled by the service layer.
         * This keeps basic business rules outside the servlet.
         */
        String error = itemService.validateItem(title, location, date);

        if (error != null) {
            reloadForm(req, resp, error, title, description, location, date, catParam);
            return;
        }

        int catId;

        try {
            catId = Integer.parseInt(catParam);
        } catch (Exception e) {
            catId = 0;
        }

        if (catId <= 0) {
            reloadForm(req, resp, "Please select a valid category.", title, description, location, date, catParam);
            return;
        }

        String imagePath = null;
        Part filePart = req.getPart("image");

        /*
         * Image upload is optional for found items.
         * If an image is provided, the servlet validates its name, extension,
         * and content type before saving it.
         */
        if (filePart != null && filePart.getSize() > 0) {
            String originalFileName = filePart.getSubmittedFileName();
            String contentType = filePart.getContentType();

            if (originalFileName == null || originalFileName.trim().isEmpty()) {
                reloadForm(req, resp, "Invalid image file.", title, description, location, date, catParam);
                return;
            }

            int dotIndex = originalFileName.lastIndexOf(".");

            if (dotIndex == -1) {
                reloadForm(req, resp, "File must be an image with a valid extension.", title, description, location, date, catParam);
                return;
            }

            String extension = originalFileName.substring(dotIndex).toLowerCase();

            if (!ALLOWED_EXTENSIONS.contains(extension)) {
                reloadForm(req, resp, "Only JPG, JPEG, and PNG image files are allowed.", title, description, location, date, catParam);
                return;
            }

            if (contentType == null || !contentType.startsWith("image/")) {
                reloadForm(req, resp, "Uploaded file must be of type image.", title, description, location, date, catParam);
                return;
            }

            /*
             * Uploaded images are stored outside the project folder.
             * The database stores only the relative image path.
             */
            String rootPath = System.getProperty("user.home")
                    + File.separator + "campusfind_uploads"
                    + File.separator + "items";

            File uploadDir = new File(rootPath);

            if (!uploadDir.exists() && !uploadDir.mkdirs()) {
                reloadForm(req, resp, "Unable to create upload folder.", title, description, location, date, catParam);
                return;
            }

            String uniqueIdentifier = "found_" + userId + "_" + System.currentTimeMillis();
            String newFileName = uniqueIdentifier + extension;

            String fullPath = rootPath + File.separator + newFileName;
            filePart.write(fullPath);

            imagePath = "uploads/items/" + newFileName;
        }

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

        if (!saved) {
            reloadForm(req, resp, "Failed to save item. Please try again.", title, description, location, date, catParam);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/student/myPosts?success=foundPosted");
    }

    private void reloadForm(HttpServletRequest req, HttpServletResponse resp,
                            String error, String title, String description,
                            String location, String date, String catParam)
            throws ServletException, IOException {

        int selectedCategoryId;

        try {
            selectedCategoryId = Integer.parseInt(catParam);
        } catch (Exception e) {
            selectedCategoryId = 0;
        }

        /*
         * Refill the form after validation failure so the student does not
         * need to type everything again.
         */
        req.setAttribute("error", error);
        req.setAttribute("categories", categoryDAO.getAll());
        req.setAttribute("title", title);
        req.setAttribute("description", description);
        req.setAttribute("location", location);
        req.setAttribute("dateReported", date);
        req.setAttribute("selectedCategoryId", selectedCategoryId);
        req.setAttribute("activePage", "postFound");

        req.getRequestDispatcher("/WEB-INF/views/student/postFound.jsp").forward(req, resp);
    }
}