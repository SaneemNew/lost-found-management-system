package com.lostfound.dao;

import com.lostfound.model.Claim;
import com.lostfound.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClaimDAO {

    // save a new claim submitted by a student
    public boolean saveClaim(Claim claim) {
        String sql = "INSERT INTO claims (item_id, claimant_id, description, status) VALUES (?, ?, ?, 'pending')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, claim.getItemId());
            ps.setInt(2, claim.getClaimantId());
            ps.setString(3, claim.getDescription());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error in saveClaim: " + e.getMessage());
            return false;
        }
    }

    // check whether this user has already submitted a claim for this item
    public boolean alreadyClaimed(int itemId, int userId) {
        String sql = "SELECT id FROM claims WHERE item_id = ? AND claimant_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, itemId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            System.out.println("Error in alreadyClaimed: " + e.getMessage());
        }

        return false;
    }

    // get all claims submitted for one specific item
    public List<Claim> getByItem(int itemId) {
        String sql = "SELECT c.*, u.full_name AS claimant_name, i.title AS item_title "
                   + "FROM claims c "
                   + "JOIN users u ON c.claimant_id = u.id "
                   + "JOIN items i ON c.item_id = i.id "
                   + "WHERE c.item_id = ? ORDER BY c.created_at DESC";

        return runQuery(sql, itemId);
    }

    // get all claims submitted by one user
    public List<Claim> getByUser(int userId) {
        String sql = "SELECT c.*, u.full_name AS claimant_name, i.title AS item_title "
                   + "FROM claims c "
                   + "JOIN users u ON c.claimant_id = u.id "
                   + "JOIN items i ON c.item_id = i.id "
                   + "WHERE c.claimant_id = ? ORDER BY c.created_at DESC";

        return runQuery(sql, userId);
    }

    // get every claim in the system for admin review
    public List<Claim> getAllClaims() {
        String sql = "SELECT c.*, u.full_name AS claimant_name, i.title AS item_title "
                   + "FROM claims c "
                   + "JOIN users u ON c.claimant_id = u.id "
                   + "JOIN items i ON c.item_id = i.id "
                   + "ORDER BY c.created_at DESC";

        List<Claim> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(buildClaim(rs));
            }

        } catch (Exception e) {
            System.out.println("Error in getAllClaims: " + e.getMessage());
        }

        return list;
    }

    // fetch one claim by its id
    public Claim getById(int claimId) {
        String sql = "SELECT c.*, u.full_name AS claimant_name, i.title AS item_title "
                   + "FROM claims c "
                   + "JOIN users u ON c.claimant_id = u.id "
                   + "JOIN items i ON c.item_id = i.id "
                   + "WHERE c.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, claimId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return buildClaim(rs);
                }
            }

        } catch (Exception e) {
            System.out.println("Error in getById: " + e.getMessage());
        }

        return null;
    }

    // update claim status such as approved or rejected
    public boolean updateStatus(int claimId, String newStatus) {
        String sql = "UPDATE claims SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, claimId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error in updateStatus: " + e.getMessage());
            return false;
        }
    }

    // once one claim is approved, reject all other pending claims for the same item
    public boolean rejectOtherPendingClaims(int itemId, int approvedClaimId) {
        String sql = "UPDATE claims SET status = 'rejected' "
                   + "WHERE item_id = ? AND id <> ? AND status = 'pending'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, itemId);
            ps.setInt(2, approvedClaimId);

            ps.executeUpdate();
            return true;

        } catch (Exception e) {
            System.out.println("Error in rejectOtherPendingClaims: " + e.getMessage());
            return false;
        }
    }

    // count how many claims of a user are still pending
    public int countPendingByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM claims WHERE claimant_id = ? AND status = 'pending'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            System.out.println("Error in countPendingByUser: " + e.getMessage());
        }

        return 0;
    }

    // count all claims in the system
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM claims";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.out.println("Error in countAll: " + e.getMessage());
        }

        return 0;
    }

    // count claims by a specific status like pending, approved, or rejected
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM claims WHERE status = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            System.out.println("Error in countByStatus: " + e.getMessage());
        }

        return 0;
    }

    // reusable helper for methods that fetch a list using one integer parameter
    private List<Claim> runQuery(String sql, int param) {
        List<Claim> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, param);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(buildClaim(rs));
                }
            }

        } catch (Exception e) {
            System.out.println("Error in runQuery: " + e.getMessage());
        }

        return list;
    }

    // convert one result set row into a Claim object
    private Claim buildClaim(ResultSet rs) throws SQLException {
        Claim c = new Claim();
        c.setId(rs.getInt("id"));
        c.setItemId(rs.getInt("item_id"));
        c.setClaimantId(rs.getInt("claimant_id"));
        c.setDescription(rs.getString("description"));
        c.setStatus(rs.getString("status"));
        c.setCreatedAt(rs.getString("created_at"));
        c.setClaimantName(rs.getString("claimant_name"));
        c.setItemTitle(rs.getString("item_title"));
        return c;
    }
}