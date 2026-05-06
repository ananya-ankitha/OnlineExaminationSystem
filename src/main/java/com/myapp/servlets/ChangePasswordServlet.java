package com.myapp.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.myapp.dao.UserDao;

public class ChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static UserDao userDao = new UserDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Check fields are not empty
        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect("ChangePasswordServlet?error=empty");
            return;
        }

        // Check new password and confirm password match
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("ChangePasswordServlet?error=mismatch");
            return;
        }

        // Check new password length
        if (newPassword.trim().isEmpty() || newPassword.length() < 6) {
            response.sendRedirect("ChangePasswordServlet?error=short");
            return;
        }

        // Verify user exists with old password
        com.myapp.utils.User user = userDao.getUser(username, oldPassword);
        if (user == null) {
            response.sendRedirect("ChangePasswordServlet?error=wrong");
            return;
        }

        // Change password
        boolean success = userDao.changePassword(user.getUserId(), oldPassword, newPassword);
        if (success) {
            response.sendRedirect("login.jsp?passChanged=1");
        } else {
            response.sendRedirect("ChangePasswordServlet?error=wrong");
        }
    }
}