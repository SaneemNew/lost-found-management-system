package com.lostfound.dao;

import com.lostfound.model.Claim;
import com.lostfound.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClaimDAO {

    // Saves a new claim submitted by a student.
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

    // Checks whether the same student has already claimed the same item.
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

    // Gets all claims submitted for one item.
    public List<Claim> getByItem(int itemId) {
        String sql = "SELECT c.*, u.full_name AS claimant_name, i.title AS item_title "
                   + "FROM claims c "
                   + "JOIN users u ON c.claimant_id = u.id "
                   + "JOIN items i ON c.item_id = i.id "
                   + "WHERE c.item_id = ? ORDER BY c.created_at DESC";

        return runQuery(sql, itemId);
    }

    // Gets all claims submitted by one student.
    public List<Claim> getByUser(int userId) {
        String sql = "SELECT c.*, u.full_name AS claimant_name, i.title AS item_title "
                   + "FROM claims c "
                   + "JOIN users u ON c.claimant_id = u.id "
                   + "JOIN items i ON c.item_id = i.id "
                   + "WHERE c.claimant_id = ? ORDER BY c.created_at DESC";

        return runQuery(sql, userId);
    }

    // Gets every claim in the system for the admin claims page.
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

    // Finds one claim by its ID.
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

    // Updates a claim status, for example pending, approved, or rejected.
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

    /*
     * Approves a pending claim and updates the related item in one transaction.
     * This is needed because approving a claim also means the item should become
     * claimed and the other pending claims for that item should be rejected.
     *
     * If any step fails, rollback keeps the database from saving only part of
     * the update.
     */
    public boolean approveClaimWithTransaction(int claimId) {
        String findClaimSql = "SELECT item_id FROM claims WHERE id = ? AND status = 'pending'";
        String approveClaimSql = "UPDATE claims SET status = 'approved' WHERE id = ? AND status = 'pending'";
        String updateItemSql = "UPDATE items SET status = 'claimed' WHERE id = ?";
        String rejectOthersSql = "UPDATE claims SET status = 'rejected' "
                               + "WHERE item_id = ? AND id <> ? AND status = 'pending'";

        Connection conn = null;

        try {
            // Start transaction because multiple related updates are needed.
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int itemId;

            // Find the item connected to this pending claim.
            try (PreparedStatement ps = conn.prepareStatement(findClaimSql)) {
                ps.setInt(1, claimId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }

                    itemId = rs.getInt("item_id");
                }
            }

            // Approve the selected claim.
            try (PreparedStatement ps = conn.prepareStatement(approveClaimSql)) {
                ps.setInt(1, claimId);

                if (ps.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            // Mark the item as claimed.
            try (PreparedStatement ps = conn.prepareStatement(updateItemSql)) {
                ps.setInt(1, itemId);

                if (ps.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            // Reject other pending claims for the same item.
            try (PreparedStatement ps = conn.prepareStatement(rejectOthersSql)) {
                ps.setInt(1, itemId);
                ps.setInt(2, claimId);
                ps.executeUpdate();
            }

            // Save all changes if every step succeeds.
            conn.commit();
            return true;

        } catch (Exception e) {
            System.out.println("Error in approveClaimWithTransaction: " + e.getMessage());

            if (conn != null) {
                try {
                    // Undo changes if any step fails.
                    conn.rollback();
                } catch (SQLException rollbackError) {
                    System.out.println("Rollback failed: " + rollbackError.getMessage());
                }
            }

            return false;

        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeError) {
                    System.out.println("Error closing transaction connection: " + closeError.getMessage());
                }
            }
        }
    }

    // Rejects other pending claims after one claim has already been approved.
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

    // Counts how many claims of a student are still pending.
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

    // Counts all claims in the system.
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

    // Counts claims by status for admin reports.
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

    // Gets the latest pending claim for dashboard or homepage preview.
    public Claim getLatestPendingClaim() {
        String sql = "SELECT c.*, u.full_name AS claimant_name, i.title AS item_title "
                   + "FROM claims c "
                   + "JOIN users u ON c.claimant_id = u.id "
                   + "JOIN items i ON c.item_id = i.id "
                   + "WHERE c.status = 'pending' "
                   + "ORDER BY c.created_at DESC LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return buildClaim(rs);
            }

        } catch (Exception e) {
            System.out.println("Error in getLatestPendingClaim: " + e.getMessage());
        }

        return null;
    }

    // Reusable helper for claim list queries that use one integer parameter.
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

    // Converts one database row into a Claim object.
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