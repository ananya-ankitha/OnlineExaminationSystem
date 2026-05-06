package com.myapp.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import com.myapp.dao.ExamDao;
import com.myapp.dao.QuestionDao;
import com.myapp.dao.ResultDao;
import com.myapp.utils.Result;
import com.myapp.utils.User;
import com.myapp.utils.ExamScore;
import com.myapp.utils.Question;

public class SubmitExamServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static ExamDao examDao = new ExamDao();
    private static ResultDao resultDao = new ResultDao();
    private static QuestionDao questionDao = new QuestionDao();

    public SubmitExamServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int noOfQuestions = Integer.parseInt(request.getParameter("no_of_questions"));
        String examName = request.getParameter("examName");
        HttpSession session1 = request.getSession(false);

        if (session1 != null && session1.getAttribute("userObject") != null) {
            User user = (User) session1.getAttribute("userObject");

            int score = 0;
            int i = 1;

            // Store selected and correct answers for results page
            ArrayList<String> selectedAnswers = new ArrayList<>();
            ArrayList<String> correctAnswers = new ArrayList<>();

            for (i = 1; i <= noOfQuestions; i++) {
                String optionSelected = request.getParameter("q" + i);
                String crctOption = request.getParameter("q" + i + "answer");

                // Handle unanswered questions
                if (optionSelected == null) optionSelected = "-";

                selectedAnswers.add(optionSelected);
                correctAnswers.add(crctOption);

                if (optionSelected.equals(crctOption))
                    score++;
            }

            int percentage = (score * 100) / (--i);

            // Save result
            Result result = new Result();
            result.setExamId(examDao.getExamId(examName));
            result.setScore(percentage);
            result.setUserId(user.getUserId());

            int resultExists = resultDao.getResultId(user.getUserId(), examDao.getExamId(examName));
            if (resultExists == -1) {
                int addResult = resultDao.addResult(result);
                if (addResult != -1)
                    result.setResultId(addResult);
            } else {
                result.setResultId(resultExists);
                resultDao.updateResult(result);
            }

            // Load questions for results page
            ArrayList<Question> questionList = questionDao.getAllQuestions(examDao.getExamId(examName));

            // Pass everything to results page
            request.setAttribute("questionList", questionList);
            request.setAttribute("selectedAnswers", selectedAnswers);
            request.setAttribute("correctAnswers", correctAnswers);
            request.setAttribute("score", score);
            request.setAttribute("totalQuestions", noOfQuestions);
            request.setAttribute("percentage", percentage);
            request.setAttribute("examName", examName);

            request.getRequestDispatcher("examResults.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}