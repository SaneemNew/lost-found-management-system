package com.lostfound.dao;

import com.lostfound.model.Category;
import com.lostfound.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    /*
     * Retrieves all item categories from the database.
     * Categories are ordered alphabetically so they appear neatly in forms
     * and admin category management pages.
     */
    public List<Category> getAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();

                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));

                list.add(c);
            }

        } catch (Exception e) {
            System.out.println("Error in CategoryDAO.getAll: " + e.getMessage());
        }

        return list;
    }

    /*
     * Adds a new category to the system.
     * The database unique constraint prevents duplicate category names.
     */
    public boolean addCategory(String name) {
        String sql = "INSERT INTO categories (name) VALUES (?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name.trim());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error in addCategory: " + e.getMessage());
            return false;
        }
    }

    /*
     * Deletes a category by its ID.
     * If items are linked to this category, the database foreign key rule
     * controls how those records are handled.
     */
    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM categories WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error in deleteCategory: " + e.getMessage());
            return false;
        }
    }
}