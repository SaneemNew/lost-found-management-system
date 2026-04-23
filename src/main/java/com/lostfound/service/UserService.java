package com.lostfound.service;
import com.lostfound.dao.UserDAO;
import com.lostfound.model.User;

import java.security.MessageDigest;

public class UserService {

    private UserDAO userDAO = new UserDAO();

    /*-----------------------------
      password hashing (SHA-256)
    ------------------------------*/
    public String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(password.getBytes("UTF-8"));

            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();

        } catch (Exception e) {
            System.out.println("Hash error: " + e.getMessage());
            return null;
        }
    }

    // validate the form, returns null if all good
    public String validateRegistration(String fullName, String email,
            String studentId, String password, String confirmPass) {

        if (fullName == null || fullName.trim().isEmpty())
            return "Full name is required.";

        if (email == null || email.trim().isEmpty())
            return "Email is required.";

        if (studentId == null || studentId.trim().isEmpty())
            return "Student ID is required.";

        if (password == null || password.length() < 6)
            return "Password must be at least 6 characters.";

        if (!password.equals(confirmPass))
            return "Passwords do not match.";

        if (userDAO.emailExists(email.trim()))
            return "This email is already registered.";

        if (userDAO.studentIdExists(studentId.trim()))
            return "This student ID is already in use.";

        return null;
    }

    public boolean register(String fullName, String email, String studentId,
                             String phone, String password) {
        User u = new User();
        u.setFullName(fullName.trim());
        u.setEmail(email.trim());
        u.setStudentId(studentId.trim());
        u.setPhone(phone != null ? phone.trim() : "");
        u.setPassword(hashPassword(password));
        return userDAO.register(u);
    }

    // null means wrong email or password
    public User checkLogin(String email, String password) {
        User user = userDAO.findByEmail(email.trim());
        if (user == null)
            return null;

        String hashed = hashPassword(password);
        if (hashed == null || !hashed.equals(user.getPassword()))
            return null;

        return user;
    }
}