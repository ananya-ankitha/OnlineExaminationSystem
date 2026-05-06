package com.myapp.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import com.myapp.dao.ExamDao;
import com.myapp.dao.QuestionDao;
import com.myapp.utils.Exam;
import com.myapp.utils.Question;

public class LoadQuestionsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static QuestionDao questiondao = new QuestionDao();
    private static ExamDao examdao = new ExamDao();

    public LoadQuestionsServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String page = request.getParameter("page");
        String examName = request.getParameter("examName");

        // FIX 1: Always load examList for the dropdown
        ArrayList<Exam> examList = examdao.getAllExams();
        request.setAttribute("examList", examList);

        // FIX 2: Null check before parsing examId
        String examIdParam = request.getParameter("examId");
        if (examIdParam == null || examIdParam.isEmpty()) {
            // No exam selected yet, just load the page with empty question list
            request.setAttribute("questionList", null);
            request.getRequestDispatcher("manageQuestions.jsp").forward(request, response);
            return;
        }

        int examId = Integer.parseInt(examIdParam);
        List<Question> questionList = questiondao.getAllQuestions(examId);
        request.setAttribute("examId", examId);
        request.setAttribute("questionList", questionList);
        request.setAttribute("examName", examName);

        if (page != null && page.equals("examPage"))
            request.getRequestDispatcher("examPage.jsp").forward(request, response);
        else
            request.getRequestDispatcher("manageQuestions.jsp").forward(request, response);
    }
}