<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.myapp.utils.User"%>
<%@ page import="com.myapp.utils.Exam"%>
<%@ page import="com.myapp.utils.Question"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Manage Questions - Online Examination System</title>
<link rel="stylesheet" href="styles.css">
</head>
<body>
<%
// Declare selectedExamId at TOP before any if blocks
String selectedExamId = request.getParameter("examId");
if (selectedExamId == null) {
    Object attr = request.getAttribute("examId");
    selectedExamId = (attr != null) ? String.valueOf(attr) : "";
}
%>
    <div class="container">
        <%
        HttpSession session1 = request.getSession(false);
        if (session1 != null && session1.getAttribute("userObject") != null) {
            User user = (User) session1.getAttribute("userObject");
            String username = user.getUsername();
            username = username.substring(0, 1).toUpperCase() + username.substring(1);
            if (user.getRole().equals("admin")) {
        %>
        <h2>Manage Questions</h2>
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
            <td><a href="ProfileServlet">Profile</a></td>
            <td class="logout-td"><a href="LogoutServlet">Logout</a></td>
        </tr>
    </table>
</nav>
        <div class="content">
            <h3>Select Exam</h3>
            <form action="LoadQuestionsServlet" method="post">
                <select id="examSelect" name="examId" onchange="this.form.submit()">
                    <option value="" disabled <%=selectedExamId.isEmpty() ? "selected" : ""%>>Select Exam</option>
                    <%
                    ArrayList<Exam> examList = (ArrayList<Exam>) request.getAttribute("examList");
                    if (examList != null) {
                        for (Exam exam : examList) {
                    %>
                    <option value="<%=exam.getId()%>" <%=String.valueOf(exam.getId()).equals(selectedExamId) ? "selected" : ""%>>
                        <%=exam.getExamName()%>
                    </option>
                    <%
                        }
                    }
                    %>
                </select>
            </form>

            <h3>Question List</h3>
            <table>
                <thead>
                    <tr>
                        <th>Question ID</th>
                        <th>Question Text</th>
                        <th>Edit</th>
                        <th>Delete</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    ArrayList<Question> questionList = (ArrayList<Question>) request.getAttribute("questionList");
                    if (questionList != null) {
                        for (Question question : questionList) {
                    %>
                    <tr>
                        <td><%=question.getQuestionId()%></td>
                        <td><%=question.getQuestion()%></td>
                        <td>
                            <button type="button" onclick="showEditForm(
                                '<%=question.getQuestionId()%>',
                                '<%=question.getQuestion().replace("'", "\\'")%>',
                                '<%=question.getOptionA().replace("'", "\\'")%>',
                                '<%=question.getOptionB().replace("'", "\\'")%>',
                                '<%=question.getOptionC().replace("'", "\\'")%>',
                                '<%=question.getOptionD().replace("'", "\\'")%>',
                                '<%=question.getCorrectOpt()%>'
                            )">Edit</button>
                        </td>
                        <td>
                            <form action="QuestionServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="questionId" value="<%=question.getQuestionId()%>">
                                <input type="hidden" name="examId" value="<%=selectedExamId%>">
                                <button type="submit">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <%
                        }
                    }
                    %>
                </tbody>
            </table>

            <% if (!selectedExamId.isEmpty()) { %>
            <button onclick="showAddQuestionForm()">Add New Question</button>
            <% } %>
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

    <!-- Add Question Modal -->
    <div id="questionModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h3>Add New Question</h3>
            <form action="QuestionServlet" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="examId" value="<%=selectedExamId%>">
                <label>Question:</label>
                <textarea name="questionText" required></textarea>
                <label>Option A:</label>
                <input type="text" name="optionA" required>
                <label>Option B:</label>
                <input type="text" name="optionB" required>
                <label>Option C:</label>
                <input type="text" name="optionC" required>
                <label>Option D:</label>
                <input type="text" name="optionD" required>
                <label>Correct Option:</label>
                <select name="correctOption">
                    <option value="A">A</option>
                    <option value="B">B</option>
                    <option value="C">C</option>
                    <option value="D">D</option>
                </select>
                <button type="submit">Save</button>
            </form>
        </div>
    </div>

    <!-- Edit Question Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeEditModal()">&times;</span>
            <h3>Edit Question</h3>
            <form action="QuestionServlet" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="examId" value="<%=selectedExamId%>">
                <input type="hidden" name="questionId" id="editQuestionId">
                <label>Question:</label>
                <textarea id="editQuestionText" name="questionText" required></textarea>
                <label>Option A:</label>
                <input type="text" id="editOptionA" name="optionA" required>
                <label>Option B:</label>
                <input type="text" id="editOptionB" name="optionB" required>
                <label>Option C:</label>
                <input type="text" id="editOptionC" name="optionC" required>
                <label>Option D:</label>
                <input type="text" id="editOptionD" name="optionD" required>
                <label>Correct Option:</label>
                <select id="editCorrectOption" name="correctOption">
                    <option value="A">A</option>
                    <option value="B">B</option>
                    <option value="C">C</option>
                    <option value="D">D</option>
                </select>
                <button type="submit">Update</button>
            </form>
        </div>
    </div>

    <script>
        function showAddQuestionForm() {
            document.getElementById('questionModal').style.display = 'block';
        }
        function closeModal() {
            document.getElementById('questionModal').style.display = 'none';
        }
        function showEditForm(id, question, optA, optB, optC, optD, correct) {
            document.getElementById('editQuestionId').value = id;
            document.getElementById('editQuestionText').value = question;
            document.getElementById('editOptionA').value = optA;
            document.getElementById('editOptionB').value = optB;
            document.getElementById('editOptionC').value = optC;
            document.getElementById('editOptionD').value = optD;
            document.getElementById('editCorrectOption').value = correct;
            document.getElementById('editModal').style.display = 'block';
        }
        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }
    </script>
</body>
</html>