package com.lostfound.dao;

import com.lostfound.model.Category;
import com.lostfound.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public List<Category> getAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY name";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }
        } catch (Exception e) {
            System.out.println("Error in CategoryDAO.getAll: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return list;
    }

    public boolean addCategory(String name) {
        String sql = "INSERT INTO categories (name) VALUES (?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error in addCategory: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM categories WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error in deleteCategory: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }
}