package com.myapp.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.myapp.dao.ExamDao;
import com.myapp.utils.Exam;

/**
 * Servlet implementation class AdminServlet
 */
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static ExamDao examdao = new ExamDao();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminServlet() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Handle DELETE first, before any exam name checks
        if (action != null && action.equals("delete")) {
            int examId = Integer.parseInt(request.getParameter("examId"));
            examdao.deleteExam(examId);
            response.sendRedirect("LoadExamsServlet?page=1");
            return;
        }

        // Handle ADD exam
        String examName = request.getParameter("examName");
        String description = request.getParameter("description");

        // Check if exam already exists
        int examExists = examdao.getExamId(examName);
        if (examExists != -1) {
            response.sendRedirect("LoadExamsServlet?error=1");
            return;
        }

        // Add new exam
        Exam exam = new Exam();
        exam.setExamName(examName);
        exam.setDescription(description);
        int id = examdao.addExam(exam);
        if (id != -1) {
            exam.setId(id);
        }
        response.sendRedirect("LoadExamsServlet?page=1");
    }
}