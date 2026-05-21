package com.lostfound.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/getimage")
public class GetImageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     * Uploaded item images are stored outside the project folder.
     * This makes the uploads safer during redeployment because images are not
     * removed when the web application is cleaned or rebuilt.
     */
    private static final String UPLOAD_BASE_DIR =
            System.getProperty("user.home") + File.separator
            + "campusfind_uploads" + File.separator
            + "items";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String imagePath = req.getParameter("path");

        if (imagePath == null || imagePath.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        /*
         * Only the file name is used from the stored path.
         * This prevents users from trying to access files from other folders.
         */
        String fileName = imagePath.substring(imagePath.lastIndexOf("/") + 1);

        /*
         * Basic path-safety check.
         * Requests containing directory traversal or path separators are blocked.
         */
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

        /*
         * Only image formats supported by the upload feature are served.
         * Other file types are rejected for safety.
         */
        if (lowerName.endsWith(".png")) {
            resp.setContentType("image/png");
        } else if (lowerName.endsWith(".jpg") || lowerName.endsWith(".jpeg")) {
            resp.setContentType("image/jpeg");
        } else {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        /*
         * Stream the image file to the browser in small chunks.
         * try-with-resources closes both the file input stream and output stream.
         */
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