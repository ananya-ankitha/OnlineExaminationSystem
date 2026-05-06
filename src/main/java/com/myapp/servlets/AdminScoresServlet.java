package com.myapp.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import com.myapp.dao.ExamDao;
import com.myapp.dao.ResultDao;
import com.myapp.utils.Exam;
import com.myapp.utils.UserScore;

public class AdminScoresServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static ResultDao resultDao = new ResultDao();
    private static ExamDao examDao = new ExamDao();

    public AdminScoresServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String examIdParam = request.getParameter("examId");

        // Load all exams for the dropdown
        ArrayList<Exam> examList = examDao.getAllExams();
        request.setAttribute("examList", examList);

        if (examIdParam != null && !examIdParam.isEmpty()) {
            // Admin selected an exam — load scores for it
            int examId = Integer.parseInt(examIdParam);
            ArrayList<UserScore> adminScores = resultDao.getAdminScores(examId);
            request.setAttribute("adminScoresList", adminScores);
            request.setAttribute("selectedExamId", examId);
        }

        // Forward to adminScores.jsp whether examId is present or not
        request.getRequestDispatcher("adminScores.jsp").forward(request, response);
    }
}