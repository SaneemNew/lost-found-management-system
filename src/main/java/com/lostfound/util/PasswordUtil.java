package com.lostfound.util;

import java.security.MessageDigest;

public class PasswordUtil {

    public static String hashPassword(String password) {
        if (password == null) {
            return null;
        }

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

    public static boolean checkPassword(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null) {
            return false;
        }

        String hashedInput = hashPassword(plainPassword);

        return hashedInput != null && hashedInput.equals(storedHash);
    }
}