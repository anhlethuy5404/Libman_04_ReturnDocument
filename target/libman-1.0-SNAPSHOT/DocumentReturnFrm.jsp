<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.library.libman.model.User" %>

<html>
<head>
    <title>Return Document</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="container">
        <h1>Return Document</h1>
        <%
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>
        <div class="header">
            <div>Hello, <strong><%= user.getName() %></strong>!</div>
            <a href="logout">Logout</a>
        </div>
        <hr>

        <%-- Search for a reader --%>
        <h3>Find Reader</h3>
        <form action="search-reader" method="get">
            <label for="readerCode">Enter Reader Code:</label>
            <input type="text" id="readerCode" name="readerCode" value="${param.readerCode}" required>
            <input type="submit" value="Search">
        </form>

        <%-- Display borrowed list --%>
        <c:if test="${not empty foundReader}">
            <hr>
            <h3>Reader Information</h3>
            <div class="info-section">
                <p><strong>Code:</strong> ${foundReader.readerCode}</p>
                <p><strong>Name:</strong> ${foundReader.name}</p>
                <p><strong>Birthday:</strong> ${foundReader.birthday}</p>
                <p><strong>Phone Number:</strong> ${foundReader.phoneNumber}</p>
            </div>

            <h3>Borrowing Document List</h3>
            <c:import url="/borrow-slip">
                <c:param name="readerId" value="${foundReader.id}"/>
            </c:import>
            <c:if test="${not empty borrowingList}">
                <form action="SelectedDocumentFrm.jsp" method="post">
                    <table>
                        <thead>
                            <th>No</th>
                            <th>Document Title</th>
                            <th>Author</th>
                            <th>Borrow Date</th>
                            <th>Due Date</th>
                            <th>Select</th>
                        </thead>
                        <tbody>
                            <c:forEach var="detail" items="${borrowingList}" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>${detail.document.title}</td>
                                    <td>${detail.document.author}</td>
                                    <td>${detail.borrowSlip.borrowDate}</td>
                                    <td>${detail.borrowSlip.dueDate}</td>
                                    <td>
                                        <input type="checkbox" name="selectedDetails" value="${detail.id}">
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <input type="hidden" name="readerCode" value="${foundReader.readerCode}">
                    <input type="submit" value="Next">
                </form>
            </c:if>
            <c:if test="${empty borrowingList}">
                <p>No documents currently borrowed by this reader.</p>
            </c:if>
        </c:if>
        
                    <button type="button" class="button back" onclick="history.back()">Back</button>
    </div>
</body>
</html>
