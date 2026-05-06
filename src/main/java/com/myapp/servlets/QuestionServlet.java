package com.myapp.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.myapp.dao.QuestionDao;
import com.myapp.utils.Question;

public class QuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static QuestionDao questionDao = new QuestionDao();

    public QuestionServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String examIdParam = request.getParameter("examId");
        int examId = (examIdParam != null && !examIdParam.isEmpty()) ? Integer.parseInt(examIdParam) : -1;

        // Handle DELETE
        if (action != null && action.equals("delete")) {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            questionDao.deleteQuestion(questionId);
            response.sendRedirect("LoadQuestionsServlet?examId=" + examId);
            return;
        }

        // Handle EDIT
        if (action != null && action.equals("edit")) {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            String ques = request.getParameter("questionText");
            String optionA = request.getParameter("optionA");
            String optionB = request.getParameter("optionB");
            String optionC = request.getParameter("optionC");
            String optionD = request.getParameter("optionD");
            String crctOption = request.getParameter("correctOption");

            Question question = new Question();
            question.setQuestionId(questionId);
            question.setExamId(examId);
            question.setQuestion(ques);
            question.setOptionA(optionA);
            question.setOptionB(optionB);
            question.setOptionC(optionC);
            question.setOptionD(optionD);
            question.setCorrectOpt(crctOption);
            questionDao.updateQuestion(question);
            response.sendRedirect("LoadQuestionsServlet?examId=" + examId);
            return;
        }

        // Handle ADD
        String ques = request.getParameter("questionText");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String crctOption = request.getParameter("correctOption");

        Question question = new Question();
        question.setExamId(examId);
        question.setQuestion(ques);
        question.setOptionA(optionA);
        question.setOptionB(optionB);
        question.setOptionC(optionC);
        question.setOptionD(optionD);
        question.setCorrectOpt(crctOption);
        int id = questionDao.addQuestion(question);
        if (id != -1) {
            question.setQuestionId(id);
        }
        response.sendRedirect("LoadQuestionsServlet?examId=" + examId);
    }
}