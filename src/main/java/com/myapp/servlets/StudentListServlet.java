package com.myapp.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import com.myapp.dao.ResultDao;
import com.myapp.dao.UserDao;
import com.myapp.utils.User;

public class StudentListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static UserDao userDao = new UserDao();
    private static ResultDao resultDao = new ResultDao();

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
        if (!user.getRole().equals("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        // Handle DELETE student
        if (action != null && action.equals("delete")) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            userDao.deleteStudent(userId);
            response.sendRedirect("StudentListServlet?success=deleted");
            return;
        }

        // Handle ADD student
        if (action != null && action.equals("add")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            // Check if username already exists
            if (userDao.getUserId(username) != -1) {
                response.sendRedirect("StudentListServlet?error=exists");
                return;
            }

            // Validate fields
            if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                response.sendRedirect("StudentListServlet?error=empty");
                return;
            }

            User newUser = new User();
            newUser.setUsername(username.trim());
            newUser.setPassword(password.trim());
            newUser.setRole(role != null ? role : "student");
            userDao.registerUser(newUser);
            response.sendRedirect("StudentListServlet?success=added");
            return;
        }

        // Load all students with their stats
        ArrayList<User> studentList = userDao.getAllStudents();
        int[] totalExams = new int[studentList.size()];
        int[] avgScores = new int[studentList.size()];
        for (int i = 0; i < studentList.size(); i++) {
            totalExams[i] = resultDao.getTotalExamsTaken(studentList.get(i).getUserId());
            avgScores[i] = resultDao.getAverageScore(studentList.get(i).getUserId());
        }

        request.setAttribute("studentList", studentList);
        request.setAttribute("totalExams", totalExams);
        request.setAttribute("avgScores", avgScores);
        request.getRequestDispatcher("studentList.jsp").forward(request, response);
    }
}