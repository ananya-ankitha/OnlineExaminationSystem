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
public class LeaderboardServlet  extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private static ResultDao resultDao = new ResultDao();
    private static ExamDao examDao = new ExamDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArrayList<Exam> examList = examDao.getAllExams();
        request.setAttribute("examList", examList);

        String examIdParam = request.getParameter("examId");
        if (examIdParam != null && !examIdParam.isEmpty()) {
            int examId = Integer.parseInt(examIdParam);
            ArrayList<UserScore> leaderboard = resultDao.getLeaderboard(examId);
            request.setAttribute("leaderboard", leaderboard);
        }

        request.getRequestDispatcher("leaderboard.jsp").forward(request, response);
    }
}

