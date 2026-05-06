<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.myapp.utils.User"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student List</title>
<link rel="stylesheet" type="text/css" href="styles.css">
<style>
    .search-box {
        width: 100%;
        padding: 10px;
        margin-bottom: 20px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
        box-sizing: border-box;
    }
    .badge {
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: bold;
        color: white;
    }
    .badge-pass { background: #43a047; }
    .badge-fail { background: #e53935; }
    .badge-none { background: #9e9e9e; }
    .delete-btn {
        background: #e53935;
        color: white;
        border: none;
        padding: 6px 12px;
        border-radius: 4px;
        cursor: pointer;
        font-size: 13px;
    }
    .delete-btn:hover { background: #c62828; }
    .add-btn {
        background: #43a047;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        font-weight: bold;
        margin-bottom: 20px;
        width: auto;
    }
    .add-btn:hover { background: #388e3c; }
    .stats-summary {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 15px;
        margin-bottom: 25px;
    }
    .summary-card {
        background: #f9f9f9;
        border: 1px solid #ddd;
        border-radius: 10px;
        padding: 15px;
        text-align: center;
    }
    .summary-number {
        font-size: 28px;
        font-weight: bold;
        color: #1a73e8;
    }
    .summary-label {
        font-size: 13px;
        color: #666;
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
    .error-msg {
        background: #ffebee;
        color: #c62828;
        padding: 10px 14px;
        border-radius: 6px;
        font-size: 13px;
        margin-bottom: 15px;
        border-left: 4px solid #e53935;
    }
</style>
</head>
<body>
<%
HttpSession session1 = request.getSession(false);
ArrayList<User> studentList = (ArrayList<User>) request.getAttribute("studentList");
int[] totalExams = (int[]) request.getAttribute("totalExams");
int[] avgScores = (int[]) request.getAttribute("avgScores");
String success = request.getParameter("success");
String error = request.getParameter("error");
%>
    <div class="container">
        <%
        if (session1 != null && session1.getAttribute("userObject") != null) {
            User user = (User) session1.getAttribute("userObject");
            String username = user.getUsername();
            username = username.substring(0, 1).toUpperCase() + username.substring(1);
            if (user.getRole().equals("admin")) {
        %>
        <h2>Admin Dashboard</h2>
        <nav>
            <table>
                <tr>
                    <td><a href="adminDashboard.jsp">Dashboard</a></td>
                    <td><a href="LoadExamsServlet?page=1">Manage Exams</a></td>
                    <td><a href="LoadExamsServlet?page=2">Manage Questions</a></td>
                    <td><a href="LoadExamsServlet?page=adminScores">Admin Scores</a></td>
                    <td><a href="AttendanceServlet">Attendance</a></td>
                    <td><a href="StudentListServlet">Student List</a></td>
                    <td><a href="AdminReportsServlet">Reports</a></td>
                    <td class="logout-td"><a href="LogoutServlet">Logout</a></td>
                </tr>
            </table>
        </nav>

        <div class="content">
            <h3>Student List</h3>

            <%-- Success/Error messages --%>
            <%if ("added".equals(success)) {%>
            <div class="success-msg">✅ Student added successfully!</div>
            <%} else if ("deleted".equals(success)) {%>
            <div class="success-msg">✅ Student deleted successfully!</div>
            <%}%>
            <%if ("exists".equals(error)) {%>
            <div class="error-msg">❌ Username already exists! Please choose a different username.</div>
            <%} else if ("empty".equals(error)) {%>
            <div class="error-msg">❌ Username and Password cannot be empty!</div>
            <%}%>

            <!-- Summary Cards -->
            <div class="stats-summary">
                <div class="summary-card">
                    <div class="summary-number"><%=studentList != null ? studentList.size() : 0%></div>
                    <div class="summary-label">Total Students</div>
                </div>
                <div class="summary-card">
                    <div class="summary-number" style="color:#43a047;">
                        <%
                        int active = 0;
                        if (totalExams != null) {
                            for (int t : totalExams) if (t > 0) active++;
                        }
                        out.print(active);
                        %>
                    </div>
                    <div class="summary-label">Active Students</div>
                </div>
                <div class="summary-card">
                    <div class="summary-number" style="color:#9e9e9e;">
                        <%
                        int inactive = (studentList != null ? studentList.size() : 0) - active;
                        out.print(inactive);
                        %>
                    </div>
                    <div class="summary-label">Inactive Students</div>
                </div>
            </div>

            <!-- Add Student Button -->
            <button class="add-btn" onclick="showAddModal()">+ Add New Student</button>

            <!-- Search Box -->
            <input type="text" id="searchBox" class="search-box"
                placeholder="🔍 Search students by name..."
                onkeyup="searchStudents()">

            <!-- Student Table -->
            <table id="studentTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Exams Taken</th>
                        <th>Avg Score</th>
                        <th>Status</th>
                        <th>Delete</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    if (studentList != null && !studentList.isEmpty()) {
                        for (int k = 0; k < studentList.size(); k++) {
                            User student = studentList.get(k);
                            int exams = totalExams != null ? totalExams[k] : 0;
                            int avg = avgScores != null ? avgScores[k] : 0;
                            String badgeClass = exams == 0 ? "badge-none" : avg >= 50 ? "badge-pass" : "badge-fail";
                            String badgeLabel = exams == 0 ? "Inactive" : avg >= 50 ? "Passing" : "Failing";
                    %>
                    <tr>
                        <td><%=student.getUserId()%></td>
                        <td><%=student.getUsername()%></td>
                        <td><%=student.getRole()%></td>
                        <td><%=exams%></td>
                        <td><%=exams > 0 ? avg + "%" : "N/A"%></td>
                        <td><span class="badge <%=badgeClass%>"><%=badgeLabel%></span></td>
                        <td>
                            <form action="StudentListServlet" method="post"
                                onsubmit="return confirm('Are you sure you want to delete <%=student.getUsername()%>?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="userId" value="<%=student.getUserId()%>">
                                <button type="submit" class="delete-btn">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="7" style="text-align:center;">No students registered yet!</td>
                    </tr>
                    <%
                    }
                    %>
                </tbody>
            </table>
        </div>

        <%
            } else {
                response.sendRedirect("login.jsp");
            }
        } else {
            response.sendRedirect("login.jsp");
        }
        %>
    </div>
    <footer>&copy; 2026 Online Examination System</footer>

    <!-- Add Student Modal -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeAddModal()">&times;</span>
            <h3>Add New User</h3>
            <form action="StudentListServlet" method="post">
                <input type="hidden" name="action" value="add">

                <label>Username:</label>
                <input type="text" name="username" required placeholder="Enter username">

                <label>Password:</label>
                <input type="password" name="password" required placeholder="Enter password">

                <label>Role:</label>
                <select name="role">
                    <option value="student">Student</option>
                    <option value="admin">Admin</option>
                </select>

                <button type="submit">Add User</button>
            </form>
        </div>
    </div>

    <script>
        function searchStudents() {
            var input = document.getElementById('searchBox').value.toLowerCase();
            var rows = document.getElementById('studentTable').getElementsByTagName('tr');
            for (var i = 1; i < rows.length; i++) {
                var name = rows[i].getElementsByTagName('td')[1];
                if (name) {
                    rows[i].style.display = name.textContent.toLowerCase().includes(input) ? '' : 'none';
                }
            }
        }

        function showAddModal() {
            document.getElementById('addModal').style.display = 'block';
        }

        function closeAddModal() {
            document.getElementById('addModal').style.display = 'none';
        }
    </script>
</body>
</html>