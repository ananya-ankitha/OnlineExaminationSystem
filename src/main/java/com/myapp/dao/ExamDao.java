package com.myapp.dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import com.myapp.utils.DBConnection;
import com.myapp.utils.Exam;

public class ExamDao {

    public ArrayList<Exam> getAllExams() {
        ArrayList<Exam> list = new ArrayList<>();
        String query = "SELECT * FROM exams";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Exam exam = new Exam();
                exam.setId(resultSet.getInt("exam_id"));
                exam.setExamName(resultSet.getString("exam_name"));
                exam.setDescription(resultSet.getString("description"));
                exam.setMinAttendance(resultSet.getInt("min_attendance")); // NEW
                list.add(exam);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getExamId(String examName) {
        String query = "SELECT * FROM exams WHERE exam_name = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, examName);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next())
                return resultSet.getInt("exam_id");
            else
                return -1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
 // Add these two methods to your existing ExamDao.java

 // NEW: Get total number of exams
 public int getTotalExams() {
     String query = "select count(*) from exams";
     try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
         ResultSet rs = ps.executeQuery();
         if (rs.next()) return rs.getInt(1);
     } catch (SQLException e) {
         e.printStackTrace();
     }
     return 0;
 }

 // NEW: Get total number of questions
 public int getTotalQuestions() {
     String query = "select count(*) from questions";
     try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
         ResultSet rs = ps.executeQuery();
         if (rs.next()) return rs.getInt(1);
     } catch (SQLException e) {
         e.printStackTrace();
     }
     return 0;
 }
    public int addExam(Exam exam) {
        // NEW: include min_attendance in insert
        String query = "INSERT INTO exams(exam_name, description, min_attendance) VALUES(?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, exam.getExamName());
            preparedStatement.setString(2, exam.getDescription());
            preparedStatement.setInt(3, exam.getMinAttendance()); // NEW
            preparedStatement.executeUpdate();
            return getExamId(exam.getExamName());
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void deleteExam(int examId) {
        String deleteAttendanceQuery = "DELETE FROM attendance WHERE exam_id = ?"; // NEW
        String deleteQuestionsQuery  = "DELETE FROM questions WHERE examId = ?";
        String deleteResultsQuery    = "DELETE FROM results WHERE exam_id = ?";
        String deleteExamQuery       = "DELETE FROM exams WHERE exam_id = ?";

        try (Connection connection = DBConnection.getConnection()) {
            connection.setAutoCommit(false);

            // NEW: delete attendance records first
            try (PreparedStatement ps = connection.prepareStatement(deleteAttendanceQuery)) {
                ps.setInt(1, examId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = connection.prepareStatement(deleteQuestionsQuery)) {
                ps.setInt(1, examId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = connection.prepareStatement(deleteResultsQuery)) {
                ps.setInt(1, examId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = connection.prepareStatement(deleteExamQuery)) {
                ps.setInt(1, examId);
                ps.executeUpdate();
            }
            connection.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}