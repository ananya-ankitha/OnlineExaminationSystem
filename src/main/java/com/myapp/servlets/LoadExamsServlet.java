package com.myapp.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import com.myapp.dao.ExamDao;
import com.myapp.dao.AttendanceDao;
import com.myapp.utils.Exam;
import com.myapp.utils.User;

public class LoadExamsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static ExamDao examdao = new ExamDao();
    private static AttendanceDao attendanceDao = new AttendanceDao();

    public LoadExamsServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String error = request.getParameter("error");
        String page  = request.getParameter("page");

        if (error != null && error.equals("1")) {
            request.setAttribute("error", "1");
        }

        ArrayList<Exam> examList = examdao.getAllExams();
        request.setAttribute("examList", examList);

        // Attendance eligibility check — only for student exam list
        if (page != null && page.equals("examList")) {
            HttpSession session = request.getSession(false);

            if (session != null && session.getAttribute("userObject") != null) {
                // FIX: get userId from userObject, not from separate session attribute
                User user = (User) session.getAttribute("userObject");
                int userId = user.getUserId();

                Map<Integer, Boolean> eligibilityMap  = new HashMap<>();
                Map<Integer, Double> attendancePctMap = new HashMap<>();

                for (Exam exam : examList) {
                    double pct    = attendanceDao.getAttendancePercentage(userId, exam.getId());
                    boolean eligible = pct >= exam.getMinAttendance();
                    eligibilityMap.put(exam.getId(), eligible);
                    attendancePctMap.put(exam.getId(), pct);
                }

                request.setAttribute("eligibilityMap", eligibilityMap);
                request.setAttribute("attendancePctMap", attendancePctMap);
            }
        }

        // Routing
        if (page == null && error != null)
            request.getRequestDispatcher("manageExams.jsp").forward(request, response);
        else if (page != null && page.equals("1"))
            request.getRequestDispatcher("manageExams.jsp").forward(request, response);
        else if (page != null && page.equals("2"))
            request.getRequestDispatcher("manageQuestions.jsp").forward(request, response);
        else if (page != null && page.equals("examList"))
            request.getRequestDispatcher("examList.jsp").forward(request, response);
        else if (page != null && page.equals("adminScores"))
            request.getRequestDispatcher("adminScores.jsp").forward(request, response);
    }
}