package com.lostfound.controller;

import com.lostfound.dao.CategoryDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.model.Item;
import com.lostfound.service.ItemService;
import com.lostfound.util.SessionUtil;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/student/postLost")
public class PostLostServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ItemDAO itemDAO = new ItemDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private ItemService itemService = new ItemService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = SessionUtil.getUserId(req);

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        /*
         * Load categories before opening the lost-item form.
         * The student must select one valid category for the lost item.
         */
        req.setAttribute("categories", categoryDAO.getAll());
        req.setAttribute("activePage", "postLost");

        req.getRequestDispatcher("/WEB-INF/views/student/postLost.jsp").forward(req, resp);
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
         * This keeps the main business rules separate from the servlet.
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

        /*
         * Lost item posts do not require an image in this system.
         * Image upload is only used for found item posts.
         */
        Item item = new Item();

        item.setUserId(userId);
        item.setType("lost");
        item.setTitle(title.trim());
        item.setDescription(description != null ? description.trim() : "");
        item.setCategoryId(catId);
        item.setLocation(location.trim());
        item.setDateReported(date);
        item.setImagePath(null);

        boolean saved = itemDAO.saveItem(item);

        if (!saved) {
            reloadForm(req, resp, "Failed to save item. Please try again.", title, description, location, date, catParam);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/student/myPosts?success=lostPosted");
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
         * need to enter all details again.
         */
        req.setAttribute("error", error);
        req.setAttribute("title", title);
        req.setAttribute("description", description);
        req.setAttribute("location", location);
        req.setAttribute("dateReported", date);
        req.setAttribute("selectedCategoryId", selectedCategoryId);
        req.setAttribute("categories", categoryDAO.getAll());
        req.setAttribute("activePage", "postLost");

        req.getRequestDispatcher("/WEB-INF/views/student/postLost.jsp").forward(req, resp);
    }
}