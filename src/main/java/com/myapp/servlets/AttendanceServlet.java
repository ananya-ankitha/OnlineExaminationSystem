package com.myapp.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import com.myapp.dao.AttendanceDao;
import com.myapp.dao.ExamDao;
import com.myapp.dao.UserDao;
import com.myapp.utils.Attendance;
import com.myapp.utils.Exam;
import com.myapp.utils.User;

public class AttendanceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private static AttendanceDao attendanceDao = new AttendanceDao();
    private static ExamDao examDao = new ExamDao();
    private static UserDao userDao = new UserDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Only admin can access
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userObject") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User admin = (User) session.getAttribute("userObject");
        if (!admin.getRole().equals("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if (action != null && action.equals("viewStudent")) {
            // Admin selected a student — load all exams with their attendance
            int userId = Integer.parseInt(request.getParameter("userId"));
            User student = userDao.getUserById(userId);
            ArrayList<Exam> examList = examDao.getAllExams();

            // For each exam, get this student's attendance
            ArrayList<Attendance> attendanceList = new ArrayList<>();
            for (Exam exam : examList) {
                Attendance att = attendanceDao.getAttendance(userId, exam.getId());
                if (att == null) {
                    // No record yet — create empty one to show in form
                    att = new Attendance();
                    att.setUserId(userId);
                    att.setExamId(exam.getId());
                    att.setAttendedClasses(0);
                    att.setTotalClasses(0);
                }
                attendanceList.add(att);
            }

            request.setAttribute("student", student);
            request.setAttribute("examList", examList);
            request.setAttribute("attendanceList", attendanceList);
            request.getRequestDispatcher("manageAttendance.jsp").forward(request, response);

        } else {
            // Default — show all students list
            ArrayList<User> studentList = userDao.getAllStudents();
            request.setAttribute("studentList", studentList);
            request.getRequestDispatcher("manageAttendance.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Only admin can access
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userObject") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User admin = (User) session.getAttribute("userObject");
        if (!admin.getRole().equals("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Save attendance for all exams for this student
        int userId = Integer.parseInt(request.getParameter("userId"));
        ArrayList<Exam> examList = examDao.getAllExams();

        for (Exam exam : examList) {
            String attendedParam = request.getParameter("attended_" + exam.getId());
            String totalParam    = request.getParameter("total_" + exam.getId());

            if (attendedParam != null && totalParam != null &&
                !attendedParam.isEmpty() && !totalParam.isEmpty()) {
                int attended = Integer.parseInt(attendedParam);
                int total    = Integer.parseInt(totalParam);
                attendanceDao.saveAttendance(userId, exam.getId(), attended, total);
            }
        }

        // Redirect back to same student view with success message
        response.sendRedirect("AttendanceServlet?action=viewStudent&userId=" + userId + "&success=1");
    }

}
