package com.myapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import com.myapp.utils.DBConnection;
import com.myapp.utils.ExamScore;
import com.myapp.utils.Result;
import com.myapp.utils.UserScore;

public class ResultDao {

    public int getResultId(int userId, int examId) {
        String query = "SELECT * FROM results WHERE user_id = ? AND exam_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, examId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            else return -1;
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public int addResult(Result result) {
        String query = "INSERT INTO results(user_id, exam_id, score) VALUES(?,?,?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, result.getUserId());
            ps.setInt(2, result.getExamId());
            ps.setInt(3, result.getScore());
            ps.executeUpdate();
            return getResultId(result.getUserId(), result.getExamId());
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public void updateResult(Result result) {
        String query = "UPDATE results SET score = ?, date_time = CURRENT_TIMESTAMP WHERE result_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, result.getScore());
            ps.setInt(2, result.getResultId());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public ArrayList<ExamScore> getUserResults(int userId) {
        ArrayList<ExamScore> list = new ArrayList<>();
        String query = "SELECT e.exam_name, r.score, r.date_time FROM results r JOIN exams e ON r.exam_id = e.exam_id WHERE r.user_id = ? ORDER BY r.date_time DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ExamScore examScore = new ExamScore();
                examScore.setExamName(rs.getString(1));
                examScore.setScore(rs.getInt(2));
                examScore.setDateTime(rs.getString(3));
                list.add(examScore);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public ArrayList<UserScore> getAdminScores(int examId) {
        ArrayList<UserScore> list = new ArrayList<>();
        String query = "SELECT u.username, r.score FROM results r JOIN users u ON r.user_id = u.user_id WHERE r.exam_id = ? ORDER BY r.score DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserScore userScore = new UserScore();
                userScore.setUserName(rs.getString(1));
                userScore.setScore(rs.getInt(2));
                list.add(userScore);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public ArrayList<UserScore> getLeaderboard(int examId) {
        ArrayList<UserScore> list = new ArrayList<>();
        String query = "SELECT u.username, r.score FROM results r JOIN users u ON r.user_id = u.user_id WHERE r.exam_id = ? ORDER BY r.score DESC LIMIT 10";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserScore userScore = new UserScore();
                userScore.setUserName(rs.getString(1));
                userScore.setScore(rs.getInt(2));
                list.add(userScore);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getTotalExamsTaken(int userId) {
        String query = "SELECT COUNT(*) FROM results WHERE user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getAverageScore(int userId) {
        String query = "SELECT ROUND(AVG(score)) FROM results WHERE user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getHighestScore(int userId) {
        String query = "SELECT MAX(score) FROM results WHERE user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getLowestScore(int userId) {
        String query = "SELECT MIN(score) FROM results WHERE user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalPassed(int userId) {
        String query = "SELECT COUNT(*) FROM results WHERE user_id = ? AND score >= 50";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public ArrayList<ExamScore> getSubjectWiseAvgScore(int userId) {
        ArrayList<ExamScore> list = new ArrayList<>();
        String query = "SELECT e.exam_name, ROUND(AVG(r.score)) FROM results r JOIN exams e ON r.exam_id = e.exam_id WHERE r.user_id = ? GROUP BY e.exam_name";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ExamScore es = new ExamScore();
                es.setExamName(rs.getString(1));
                es.setScore(rs.getInt(2));
                list.add(es);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public ArrayList<ExamScore> getAttemptsPerSubject(int userId) {
        ArrayList<ExamScore> list = new ArrayList<>();
        String query = "SELECT e.exam_name, COUNT(r.result_id) FROM results r JOIN exams e ON r.exam_id = e.exam_id WHERE r.user_id = ? GROUP BY e.exam_name";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ExamScore es = new ExamScore();
                es.setExamName(rs.getString(1));
                es.setScore(rs.getInt(2));
                list.add(es);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public ArrayList<String[]> getStudentWiseStats() {
        ArrayList<String[]> list = new ArrayList<>();
        String query = "SELECT u.username, COUNT(r.result_id), ROUND(AVG(r.score)), MAX(r.score), MIN(r.score) " +
                       "FROM results r JOIN users u ON r.user_id = u.user_id " +
                       "WHERE u.role = 'student' GROUP BY u.username ORDER BY AVG(r.score) DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String[] row = { rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5) };
                list.add(row);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public ArrayList<String[]> getSubjectWiseStats() {
        ArrayList<String[]> list = new ArrayList<>();
        String query = "SELECT e.exam_name, COUNT(r.result_id), ROUND(AVG(r.score)), MAX(r.score), MIN(r.score) " +
                       "FROM results r JOIN exams e ON r.exam_id = e.exam_id " +
                       "GROUP BY e.exam_name ORDER BY AVG(r.score) DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String[] row = { rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5) };
                list.add(row);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getTotalStudents() {
        String query = "SELECT COUNT(*) FROM users WHERE role = 'student'";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalExamsInSystem() {
        String query = "SELECT COUNT(*) FROM exams";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalAttemptsInSystem() {
        String query = "SELECT COUNT(*) FROM results";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getOverallPassRate() {
        String query = "SELECT ROUND((SUM(CASE WHEN score >= 50 THEN 1 ELSE 0 END) / COUNT(*)) * 100) FROM results";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}