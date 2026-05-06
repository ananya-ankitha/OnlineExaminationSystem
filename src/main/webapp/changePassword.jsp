<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Change Password</title>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Helvetica Neue', Arial, sans-serif;
    }

    body {
        background: linear-gradient(135deg, #6a11cb, #2575fc);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
    }

    .page-title {
        color: white;
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 20px;
        text-align: center;
        text-shadow: 0 2px 4px rgba(0,0,0,0.2);
    }

    .card {
        background: white;
        border-radius: 16px;
        padding: 40px;
        width: 420px;
        box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    }

    .card h3 {
        text-align: center;
        font-size: 22px;
        color: #333;
        margin-bottom: 25px;
    }

    .form-group {
        margin-bottom: 18px;
    }

    .form-group label {
        display: block;
        font-size: 13px;
        font-weight: bold;
        color: #555;
        margin-bottom: 6px;
    }

    .form-group input {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 14px;
        color: #333;
        outline: none;
        transition: border-color 0.3s;
        box-sizing: border-box;
    }

    .form-group input:focus {
        border-color: #3498db;
        box-shadow: 0 0 0 3px rgba(52,152,219,0.1);
    }

    .submit-btn {
        width: 100%;
        padding: 13px;
        background: linear-gradient(135deg, #3498db, #2575fc);
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 15px;
        font-weight: bold;
        cursor: pointer;
        transition: opacity 0.3s;
        margin-top: 5px;
    }

    .submit-btn:hover {
        opacity: 0.9;
    }

    .links {
        text-align: center;
        margin-top: 18px;
        font-size: 13px;
        color: #777;
    }

    .links a {
        color: #3498db;
        text-decoration: none;
        font-weight: bold;
    }

    .links a:hover {
        text-decoration: underline;
    }

    .error-msg {
        background: #ffebee;
        color: #c62828;
        padding: 10px 14px;
        border-radius: 6px;
        font-size: 13px;
        margin-bottom: 15px;
        border-left: 4px solid #e53935;
    }

    .success-msg {
        background: #e8f5e9;
        color: #2e7d32;
        padding: 10px 14px;
        border-radius: 6px;
        font-size: 13px;
        margin-bottom: 15px;
        border-left: 4px solid #43a047;
    }

    footer {
        text-align: center;
        color: rgba(255,255,255,0.6);
        font-size: 12px;
        margin-top: 20px;
    }
</style>
</head>
<body>

<p class="page-title">Online Examination System</p>

<div class="card">
    <h3>Change Password</h3>

    <%
    String error = request.getParameter("error");
    if (error != null) {
        if (error.equals("wrong")) {
    %>
    <div class="error-msg">❌ Invalid username or current password!</div>
    <%  } else if (error.equals("mismatch")) { %>
    <div class="error-msg">❌ New passwords do not match!</div>
    <%  } else if (error.equals("short")) { %>
    <div class="error-msg">❌ Password must be at least 6 characters!</div>
    <%  } else if (error.equals("empty")) { %>
    <div class="error-msg">❌ All fields are required!</div>
    <%  }
    }
    %>

    <form action="ChangePasswordServlet" method="post">
        <div class="form-group">
            <label>Username:</label>
            <input type="text" name="username" required placeholder="Enter your username">
        </div>

        <div class="form-group">
            <label>Current Password:</label>
            <input type="password" name="oldPassword" required placeholder="Enter current password">
        </div>

        <div class="form-group">
            <label>New Password:</label>
            <input type="password" name="newPassword" required placeholder="Enter new password (min 6 chars)">
        </div>

        <div class="form-group">
            <label>Confirm New Password:</label>
            <input type="password" name="confirmPassword" required placeholder="Confirm new password">
        </div>

        <button type="submit" class="submit-btn">Change Password</button>
    </form>

    <div class="links">
        <p><a href="login.jsp">← Back to Login</a></p>
    </div>
</div>

<footer>&copy; 2026 Online Examination System</footer>

</body>
</html>