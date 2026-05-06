<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Login - Online Examination System</title>
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

    .login-card {
        display: flex;
        width: 850px;
        min-height: 480px;
        background: white;
        border-radius: 20px;
        overflow: hidden;
        box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    }

    .login-left {
        flex: 1;
        background: linear-gradient(160deg, #a8edea, #3498db);
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 40px 30px;
        position: relative;
        overflow: hidden;
    }

    .login-left::after {
        content: '';
        position: absolute;
        bottom: -60px;
        right: -60px;
        width: 220px;
        height: 220px;
        background: rgba(255,255,255,0.2);
        border-radius: 50%;
    }

    .login-left::before {
        content: '';
        position: absolute;
        top: -40px;
        left: -40px;
        width: 160px;
        height: 160px;
        background: rgba(255,255,255,0.15);
        border-radius: 50%;
    }

    .illustration {
        width: 220px;
        height: 220px;
        margin-bottom: 20px;
        z-index: 1;
    }

    .login-left h3 {
        color: white;
        font-size: 18px;
        text-align: center;
        z-index: 1;
        text-shadow: 0 2px 4px rgba(0,0,0,0.2);
    }

    .login-left p {
        color: rgba(255,255,255,0.85);
        font-size: 13px;
        text-align: center;
        margin-top: 8px;
        z-index: 1;
    }

    .login-right {
        flex: 1;
        padding: 50px 40px;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }

    .login-right h2 {
        font-size: 24px;
        color: #333;
        margin-bottom: 8px;
        text-align: left;
    }

    .login-right p.subtitle {
        color: #999;
        font-size: 13px;
        margin-bottom: 30px;
    }

    .form-group {
        margin-bottom: 20px;
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
        transition: border-color 0.3s;
        outline: none;
    }

    .form-group input:focus {
        border-color: #3498db;
        box-shadow: 0 0 0 3px rgba(52,152,219,0.1);
    }

    .show-password {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 13px;
        color: #777;
        margin-bottom: 20px;
        cursor: pointer;
    }

    .login-btn {
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
        letter-spacing: 0.5px;
    }

    .login-btn:hover {
        opacity: 0.9;
    }

    .links {
        margin-top: 20px;
        text-align: center;
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

    @media (max-width: 700px) {
        .login-card {
            flex-direction: column;
            width: 95%;
        }
        .login-left {
            padding: 30px;
            min-height: 200px;
        }
        .illustration {
            width: 140px;
            height: 140px;
        }
    }
</style>
</head>
<body>

<div class="login-card">
    <!-- Left Side Illustration -->
    <div class="login-left">
        <svg class="illustration" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
            <!-- Desk -->
            <rect x="20" y="150" width="160" height="12" rx="4" fill="#8B5E3C"/>
            <rect x="30" y="162" width="12" height="30" rx="3" fill="#7a5230"/>
            <rect x="158" y="162" width="12" height="30" rx="3" fill="#7a5230"/>
            <!-- Books -->
            <rect x="25" y="130" width="18" height="22" rx="2" fill="#e53935"/>
            <rect x="44" y="133" width="16" height="19" rx="2" fill="#43a047"/>
            <rect x="61" y="136" width="14" height="16" rx="2" fill="#fb8c00"/>
            <!-- Laptop -->
            <rect x="85" y="118" width="70" height="45" rx="4" fill="#455a64"/>
            <rect x="89" y="122" width="62" height="37" rx="2" fill="#90caf9"/>
            <rect x="80" y="163" width="80" height="6" rx="3" fill="#37474f"/>
            <!-- Screen lines -->
            <rect x="95" y="128" width="40" height="3" rx="1" fill="white" opacity="0.7"/>
            <rect x="95" y="134" width="30" height="3" rx="1" fill="white" opacity="0.5"/>
            <rect x="95" y="140" width="35" height="3" rx="1" fill="white" opacity="0.5"/>
            <rect x="95" y="146" width="25" height="3" rx="1" fill="white" opacity="0.4"/>
            <!-- Body -->
            <ellipse cx="100" cy="108" rx="22" ry="15" fill="#e57373"/>
            <!-- Head -->
            <circle cx="100" cy="80" r="22" fill="#ffcc80"/>
            <!-- Hair -->
            <ellipse cx="100" cy="62" rx="22" ry="10" fill="#6d4c41"/>
            <rect x="78" y="62" width="8" height="18" rx="4" fill="#6d4c41"/>
            <!-- Glasses -->
            <circle cx="92" cy="80" r="7" fill="none" stroke="#e53935" stroke-width="2.5"/>
            <circle cx="108" cy="80" r="7" fill="none" stroke="#e53935" stroke-width="2.5"/>
            <line x1="99" y1="80" x2="101" y2="80" stroke="#e53935" stroke-width="2"/>
            <line x1="85" y1="80" x2="80" y2="78" stroke="#e53935" stroke-width="2"/>
            <line x1="115" y1="80" x2="120" y2="78" stroke="#e53935" stroke-width="2"/>
            <!-- Eyes -->
            <circle cx="92" cy="80" r="2.5" fill="#5d4037"/>
            <circle cx="108" cy="80" r="2.5" fill="#5d4037"/>
            <!-- Smile -->
            <path d="M 93 87 Q 100 93 107 87" stroke="#5d4037" stroke-width="2" fill="none"/>
        </svg>
        <h3>Online Examination System</h3>
        <p>Learn, Test &amp; Grow</p>
    </div>

    <!-- Right Side Form -->
    <div class="login-right">
        <h2>Welcome Back!</h2>
        <p class="subtitle">Please login to your account</p>

        <%
        String error = request.getParameter("error");
        String res = request.getParameter("registration");
        String passChanged = request.getParameter("passChanged");
        if (error != null && error.equals("1")) {
        %>
        <div class="error-msg">❌ Invalid Username or Password!</div>
        <%
        }
        if (res != null && res.equals("success")) {
        %>
        <div class="success-msg">✅ Registration Successful! Please Login.</div>
        <%
        }
        if (passChanged != null && passChanged.equals("1")) {
        %>
        <div class="success-msg">✅ Password changed successfully! Please login again.</div>
        <%
        }
        %>

        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username"
                    placeholder="Enter your username" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password"
                    placeholder="Enter your password" required>
            </div>

            <label class="show-password">
                <input type="checkbox" onclick="togglePassword()"> Show Password
            </label>

            <button type="submit" class="login-btn">Sign In →</button>
        </form>

        <div class="links">
            <p>Don't have an account? <a href="register.jsp">Register here</a></p>
            <p style="margin-top:8px;">Forgot password? <a href="ChangePasswordServlet">Change Password</a></p>
        </div>
    </div>
</div>

<footer>&copy; 2026 Online Examination System</footer>

<script>
    function togglePassword() {
        var passwordField = document.getElementById("password");
        if (passwordField.type === "password") {
            passwordField.type = "text";
        } else {
            passwordField.type = "password";
        }
    }
</script>
</body>
</html>