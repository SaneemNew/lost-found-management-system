package com.lostfound.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public class PasswordUtil {

    /*
     * Converts a plain text password into a SHA-256 hash.
     * The hashed value is stored in the database instead of the original password.
     */
    public static String hashPassword(String password) {
        if (password == null) {
            return null;
        }

        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(password.getBytes(StandardCharsets.UTF_8));

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

    /*
     * Checks whether the entered password matches the stored password hash.
     * The entered password is hashed first, then compared with the saved hash.
     */
    public static boolean checkPassword(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null) {
            return false;
        }

        String hashedInput = hashPassword(plainPassword);

        return hashedInput != null && hashedInput.equals(storedHash);
    }
}