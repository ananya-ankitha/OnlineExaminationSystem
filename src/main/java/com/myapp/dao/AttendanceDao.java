package com.myapp.dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.myapp.utils.DBConnection;
import com.myapp.utils.Attendance;
public class AttendanceDao {
	// Get attendance record for a student for a specific exam
    public Attendance getAttendance(int userId, int examId) {
        Attendance att = null;
        String query = "SELECT * FROM attendance WHERE user_id = ? AND exam_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, examId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                att = new Attendance();
                att.setId(rs.getInt("id"));
                att.setUserId(rs.getInt("user_id"));
                att.setExamId(rs.getInt("exam_id"));
                att.setAttendedClasses(rs.getInt("attended_classes"));
                att.setTotalClasses(rs.getInt("total_classes"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return att;
    }

    // Get attendance percentage for a student for a specific exam
    public double getAttendancePercentage(int userId, int examId) {
        Attendance att = getAttendance(userId, examId);
        if (att == null) return 0.0; // no record = 0% = blocked
        return att.getAttendancePercentage();
    }

    // Check if student is eligible to take the exam
    public boolean isEligible(int userId, int examId, int minAttendance) {
        double pct = getAttendancePercentage(userId, examId);
        return pct >= minAttendance;
    }

    // Save or update attendance (admin uses this)
    public boolean saveAttendance(int userId, int examId, int attended, int total) {
        // Check if record already exists
        String checkQuery = "SELECT id FROM attendance WHERE user_id = ? AND exam_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement checkPs = connection.prepareStatement(checkQuery)) {
            checkPs.setInt(1, userId);
            checkPs.setInt(2, examId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // Record exists — update it
                String updateQuery = "UPDATE attendance SET attended_classes = ?, total_classes = ? WHERE user_id = ? AND exam_id = ?";
                try (PreparedStatement updatePs = connection.prepareStatement(updateQuery)) {
                    updatePs.setInt(1, attended);
                    updatePs.setInt(2, total);
                    updatePs.setInt(3, userId);
                    updatePs.setInt(4, examId);
                    updatePs.executeUpdate();
                }
            } else {
                // No record — insert new
                String insertQuery = "INSERT INTO attendance (user_id, exam_id, attended_classes, total_classes) VALUES (?, ?, ?, ?)";
                try (PreparedStatement insertPs = connection.prepareStatement(insertQuery)) {
                    insertPs.setInt(1, userId);
                    insertPs.setInt(2, examId);
                    insertPs.setInt(3, attended);
                    insertPs.setInt(4, total);
                    insertPs.executeUpdate();
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all attendance records for a specific exam (admin view)
    public java.util.ArrayList<Attendance> getAttendanceByExam(int examId) {
        java.util.ArrayList<Attendance> list = new java.util.ArrayList<>();
        String query = "SELECT * FROM attendance WHERE exam_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Attendance att = new Attendance();
                att.setId(rs.getInt("id"));
                att.setUserId(rs.getInt("user_id"));
                att.setExamId(rs.getInt("exam_id"));
                att.setAttendedClasses(rs.getInt("attended_classes"));
                att.setTotalClasses(rs.getInt("total_classes"));
                list.add(att);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

