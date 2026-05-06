package com.myapp.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import com.myapp.dao.ResultDao;
import com.myapp.utils.ExamScore;
import com.myapp.utils.User;

public class ViewScoresServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static ResultDao resultDao = new ResultDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userObject") != null) {
            User user = (User) session.getAttribute("userObject");
            int userId = user.getUserId();

            // Existing
            ArrayList<ExamScore> userResultList = resultDao.getUserResults(userId);

            // Stats
            int totalExams   = resultDao.getTotalExamsTaken(userId);
            int avgScore     = resultDao.getAverageScore(userId);
            int highestScore = resultDao.getHighestScore(userId);
            int lowestScore  = resultDao.getLowestScore(userId);
            int totalPassed  = resultDao.getTotalPassed(userId);

            // Graph data
            ArrayList<ExamScore> subjectAvg      = resultDao.getSubjectWiseAvgScore(userId);
            ArrayList<ExamScore> attemptsPerSubject = resultDao.getAttemptsPerSubject(userId);

            request.setAttribute("userResultList",      userResultList);
            request.setAttribute("totalExams",          totalExams);
            request.setAttribute("avgScore",            avgScore);
            request.setAttribute("highestScore",        highestScore);
            request.setAttribute("lowestScore",         lowestScore);
            request.setAttribute("totalPassed",         totalPassed);
            request.setAttribute("subjectAvg",          subjectAvg);
            request.setAttribute("attemptsPerSubject",  attemptsPerSubject);

            request.getRequestDispatcher("studentReport.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}