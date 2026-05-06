package com.myapp.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import com.myapp.dao.UserDao;
import com.myapp.utils.User;

public class ManageStudentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static UserDao userDao = new UserDao();

    public ManageStudentsServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin check
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

        // Delete student
        if ("delete".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            userDao.deleteStudent(userId);
            response.sendRedirect("ManageStudentsServlet?success=deleted");
            return;
        }

        // Load all students and show page
        ArrayList<User> studentList = userDao.getAllStudents();
        request.setAttribute("studentList", studentList);
        request.getRequestDispatcher("manageStudents.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin check
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

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("ManageStudentsServlet?error=empty");
            return;
        }

        if (!password.equals(confirmPassword)) {
            response.sendRedirect("ManageStudentsServlet?error=passwordmismatch");
            return;
        }

        if (userDao.usernameExists(username)) {
            response.sendRedirect("ManageStudentsServlet?error=exists");
            return;
        }

        // Register new student
        User newStudent = new User();
        newStudent.setUsername(username);
        newStudent.setPassword(password);
        newStudent.setRole("student");
        userDao.registerUser(newStudent);

        response.sendRedirect("ManageStudentsServlet?success=added");
    }
}