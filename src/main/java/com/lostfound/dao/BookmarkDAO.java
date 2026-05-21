package com.lostfound.dao;

import com.lostfound.model.Item;
import com.lostfound.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BookmarkDAO {

    /*
     * Adds an item to the student's bookmark list.
     * INSERT IGNORE prevents duplicate bookmarks because the database has
     * a unique constraint on user_id and item_id.
     */
    public boolean addBookmark(int userId, int itemId) {
        String sql = "INSERT IGNORE INTO bookmarks (user_id, item_id) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, itemId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error in addBookmark: " + e.getMessage());
            return false;
        }
    }

    /*
     * Removes a bookmarked item for a specific student.
     */
    public boolean removeBookmark(int userId, int itemId) {
        String sql = "DELETE FROM bookmarks WHERE user_id = ? AND item_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, itemId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error in removeBookmark: " + e.getMessage());
            return false;
        }
    }

    /*
     * Checks whether a student has already bookmarked a specific item.
     * This is used to decide whether to show "Bookmark" or "Remove Bookmark"
     * on the item detail page.
     */
    public boolean isBookmarked(int userId, int itemId) {
        String sql = "SELECT 1 FROM bookmarks WHERE user_id = ? AND item_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, itemId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            System.out.println("Error in isBookmarked: " + e.getMessage());
            return false;
        }
    }

    /*
     * Retrieves all items bookmarked by a specific student.
     * The query joins items, categories, and users so the JSP can display
     * item details, category name, and poster name.
     */
    public List<Item> getBookmarkedItems(int userId) {
        String sql = "SELECT i.*, c.name AS cat_name, u.full_name AS poster "
                   + "FROM bookmarks b "
                   + "JOIN items i ON b.item_id = i.id "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "WHERE b.user_id = ?";

        List<Item> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();

                    item.setId(rs.getInt("id"));
                    item.setUserId(rs.getInt("user_id"));
                    item.setType(rs.getString("type"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setCategoryId(rs.getInt("category_id"));
                    item.setCategoryName(rs.getString("cat_name"));
                    item.setLocation(rs.getString("location"));
                    item.setDateReported(rs.getString("date_reported"));
                    item.setImagePath(rs.getString("image_path"));
                    item.setStatus(rs.getString("status"));
                    item.setCreatedAt(rs.getString("created_at"));
                    item.setPostedBy(rs.getString("poster"));

                    list.add(item);
                }
            }

        } catch (Exception e) {
            System.out.println("Error in getBookmarkedItems: " + e.getMessage());
        }

        return list;
    }

    /*
     * Counts the number of bookmarks saved by a student.
     * This can be used on the student dashboard.
     */
    public int countByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM bookmarks WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            System.out.println("Error in countByUser: " + e.getMessage());
        }

        return 0;
    }
}