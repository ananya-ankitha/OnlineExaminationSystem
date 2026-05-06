package com.myapp.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import com.myapp.dao.ResultDao;
import com.myapp.utils.User;

public class AdminReportsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static ResultDao resultDao = new ResultDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userObject") == null) {
            response.sendRedirect("login.jsp"); return;
        }
        User admin = (User) session.getAttribute("userObject");
        if (!admin.getRole().equals("admin")) {
            response.sendRedirect("login.jsp"); return;
        }

        // Overall stats
        request.setAttribute("totalStudents",  resultDao.getTotalStudents());
        request.setAttribute("totalExams",     resultDao.getTotalExamsInSystem());
        request.setAttribute("totalAttempts",  resultDao.getTotalAttemptsInSystem());
        request.setAttribute("overallPassRate",resultDao.getOverallPassRate());

        // Studentwise & Subjectwise
        request.setAttribute("studentStats",   resultDao.getStudentWiseStats());
        request.setAttribute("subjectStats",   resultDao.getSubjectWiseStats());

        request.getRequestDispatcher("adminReports.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}