package com.lostfound.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/getimage")
public class GetImageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getParameter("path");

        if (path == null || path.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Image path is required.");
            return;
        }

        path = path.replace("\\", "/").trim();

        if (!path.startsWith("uploads/items/") || path.contains("..")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid image path.");
            return;
        }

        String rootPath = getServletContext().getRealPath("/");
        File baseDir = new File(rootPath, "uploads/items");
        File file = new File(rootPath, path);

        String baseCanonicalPath = baseDir.getCanonicalPath();
        String fileCanonicalPath = file.getCanonicalPath();

        if (!fileCanonicalPath.startsWith(baseCanonicalPath + File.separator)
                && !fileCanonicalPath.equals(baseCanonicalPath)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid image path.");
            return;
        }

        if (!file.exists() || file.isDirectory()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found.");
            return;
        }

        String mimeType = getServletContext().getMimeType(file.getName());
        if (mimeType == null ||
                !(mimeType.equals("image/jpeg") || mimeType.equals("image/png"))) {
            resp.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE, "Invalid image type.");
            return;
        }

        resp.setContentType(mimeType);
        resp.setContentLengthLong(file.length());

        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = resp.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }

            os.flush();
        }
    }
}