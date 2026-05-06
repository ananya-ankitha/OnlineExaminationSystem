package com.myapp.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import com.myapp.dao.ExamDao;
import com.myapp.dao.ResultDao;
import com.myapp.dao.UserDao;
import com.myapp.utils.ExamScore;
import com.myapp.utils.User;

public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static ResultDao resultDao = new ResultDao();
    private static ExamDao examDao = new ExamDao();
    private static UserDao userDao = new UserDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userObject") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("userObject");

        if (user.getRole().equals("student")) {
            int totalExams = resultDao.getTotalExamsTaken(user.getUserId());
            int avgScore = resultDao.getAverageScore(user.getUserId());
            int highestScore = resultDao.getHighestScore(user.getUserId());
            int lowestScore = resultDao.getLowestScore(user.getUserId()); // NEW
            int totalPassed = resultDao.getTotalPassed(user.getUserId());
            int totalFailed = totalExams - totalPassed;
            ArrayList<ExamScore> recentExams = resultDao.getUserResults(user.getUserId());

            request.setAttribute("totalExams", totalExams);
            request.setAttribute("avgScore", avgScore);
            request.setAttribute("highestScore", highestScore);
            request.setAttribute("lowestScore", lowestScore); // NEW
            request.setAttribute("totalPassed", totalPassed);
            request.setAttribute("totalFailed", totalFailed);
            request.setAttribute("recentExams", recentExams);
            request.getRequestDispatcher("studentProfile.jsp").forward(request, response);

        } else if (user.getRole().equals("admin")) {
            int totalExams = examDao.getTotalExams();
            int totalStudents = userDao.getTotalStudents();
            int totalQuestions = examDao.getTotalQuestions();

            request.setAttribute("totalExams", totalExams);
            request.setAttribute("totalStudents", totalStudents);
            request.setAttribute("totalQuestions", totalQuestions);
            request.getRequestDispatcher("adminProfile.jsp").forward(request, response);
        }
    }
}