package com.lostfound.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/getimage")
public class GetImageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String UPLOAD_BASE_DIR =
            System.getProperty("user.home") + File.separator + "campusfind_uploads" + File.separator + "items";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String imagePath = req.getParameter("path");

        if (imagePath == null || imagePath.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String fileName = imagePath.substring(imagePath.lastIndexOf("/") + 1);

        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        File imageFile = new File(UPLOAD_BASE_DIR, fileName);

        if (!imageFile.exists() || !imageFile.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String lowerName = fileName.toLowerCase();

        if (lowerName.endsWith(".png")) {
            resp.setContentType("image/png");
        } else if (lowerName.endsWith(".jpg") || lowerName.endsWith(".jpeg")) {
            resp.setContentType("image/jpeg");
        } else {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        resp.setContentLengthLong(imageFile.length());

        try (FileInputStream fis = new FileInputStream(imageFile);
             OutputStream out = resp.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = fis.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}