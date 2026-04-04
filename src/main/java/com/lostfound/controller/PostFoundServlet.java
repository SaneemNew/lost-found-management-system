package com.lostfound.controller;

import com.lostfound.dao.CategoryDAO;
import com.lostfound.dao.ItemDAO;
import com.lostfound.model.Item;
import com.lostfound.service.ItemService;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/student/postFound")
@MultipartConfig(maxFileSize = 5242880, maxRequestSize = 10485760)
public class PostFoundServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    private ItemDAO     itemDAO     = new ItemDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private ItemService itemService = new ItemService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("categories", categoryDAO.getAll());
        req.getRequestDispatcher("/WEB-INF/views/student/postFound.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String title       = req.getParameter("title");
        String description = req.getParameter("description");
        String location    = req.getParameter("location");
        String date        = req.getParameter("dateReported");
        String catParam    = req.getParameter("categoryId");

        String error = itemService.validateItem(title, location, date);
        if (error != null) {
            req.setAttribute("error", error);
            req.setAttribute("categories", categoryDAO.getAll());
            req.getRequestDispatcher("/WEB-INF/views/student/postFound.jsp").forward(req, resp);
            return;
        }

        int catId = 0;
        try { catId = Integer.parseInt(catParam); } catch (Exception e) {}

        // handle image upload
        String imagePath = null;
        Part filePart = req.getPart("image");

        if (filePart != null && filePart.getSize() > 0) {
            String original = filePart.getSubmittedFileName();
            String ext      = original.substring(original.lastIndexOf("."));
            String newName  = System.currentTimeMillis() + ext;

            String uploadDir = getServletContext().getRealPath("/uploads/items");
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            filePart.write(uploadDir + File.separator + newName);
            imagePath = "uploads/items/" + newName;
        }

        int userId = (int) req.getSession().getAttribute("userId");

        Item item = new Item();
        item.setUserId(userId);
        item.setType("found");
        item.setTitle(title.trim());
        item.setDescription(description != null ? description.trim() : "");
        item.setCategoryId(catId);
        item.setLocation(location.trim());
        item.setDateReported(date);
        item.setImagePath(imagePath);

        itemDAO.saveItem(item);
        resp.sendRedirect(req.getContextPath() + "/student/myPosts");
    }
}
