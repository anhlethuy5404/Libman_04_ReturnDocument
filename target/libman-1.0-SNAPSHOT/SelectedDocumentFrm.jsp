<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.libman.model.ReturnSlipDetail" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.library.libman.model.User, com.library.libman.model.Reader, com.library.libman.model.BorrowSlipDetail" %>
<%@ page import="com.library.libman.dao.ReaderDAO, com.library.libman.dao.BorrowSlipDetailDAO" %>
<%@ page import="java.util.ArrayList, java.util.List, java.util.Arrays" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Logic to prepare data for display --%>
<% 
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // session.removeAttribute("returnSlipDetailMap"); // Removed this line
    }

    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String readerCode = request.getParameter("readerCode");
    String[] selectedDetailsIds = request.getParameterValues("selectedDetails");

    ReaderDAO readerDAO = new ReaderDAO();
    Reader reader = null;
    List<BorrowSlipDetail> selectedDocuments = new ArrayList<>();

    // Try to get from request parameters first (initial POST from DocumentReturnFrm.jsp)
    if (readerCode != null && !readerCode.isEmpty() && selectedDetailsIds != null && selectedDetailsIds.length > 0) {
        reader = readerDAO.searchReaderByReaderCode(readerCode);
        if (reader != null) {
            BorrowSlipDetailDAO borrowSlipDetailDAO = new BorrowSlipDetailDAO();
            List<BorrowSlipDetail> allBorrowed = borrowSlipDetailDAO.getBorrowingList(reader.getId());
            List<String> selectedIdsList = Arrays.asList(selectedDetailsIds);

            for (BorrowSlipDetail detail : allBorrowed) {
                if (selectedIdsList.contains(String.valueOf(detail.getId()))) {
                    selectedDocuments.add(detail);
                }
            }
        }
        // Save to session for subsequent redirects
        session.setAttribute("selectedDocReader", reader);
        session.setAttribute("selectedDocDocuments", selectedDocuments);
    } else {
        // If not in request parameters, try to get from session (after redirect from SaveFineServlet)
        reader = (Reader) session.getAttribute("selectedDocReader");
        selectedDocuments = (List<BorrowSlipDetail>) session.getAttribute("selectedDocDocuments");
        if (selectedDocuments == null) {
            selectedDocuments = new ArrayList<>(); // Ensure it's not null
        }
    }
    pageContext.setAttribute("reader", reader);
    pageContext.setAttribute("selectedDocuments", selectedDocuments);
%>

<html>
<head>
    <title>Return Document</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        .modal {
            display: none; 
            position: fixed; 
            z-index: 1; 
            left: 0;
            top: 0;
            width: 100%; 
            height: 100%; 
            overflow: auto; 
            background-color: rgb(0,0,0); 
            background-color: rgba(0,0,0,0.4); 
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto; 
            padding: 20px;
            border: 1px solid #888;
            width: 80%; 
            max-width: 400px;
            text-align: center;
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Return Document</h1>

        <c:if test="${empty reader or empty selectedDocuments}">
            <p class="error">Could not process the return request. No documents were selected or the reader was not found.</p>
            <p><a href="DocumentReturnFrm.jsp">Go back and try again</a></p>
        </c:if>

        <c:if test="${not empty reader and not empty selectedDocuments}">
            <h3>Reader Information</h3>
            <div class="info-section">
                <p><strong>Code:</strong> ${reader.readerCode}</p>
                <p><strong>Name:</strong> ${reader.name}</p>
                <p><strong>Birthday:</strong> ${reader.birthday}</p>
                <p><strong>Phone Number:</strong> ${reader.phoneNumber}</p>
            </div>

            <h3>Selected Documents for Return</h3>
            <form action="/libman/create-return-slip" method="post">
                <input type="hidden" name="readerCode" value="<c:out value='${reader.readerCode}'/>">
                
                <table>
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>Document ID</th>
                            <th>Title</th>
                            <th>Status</th>
                            <th>Fine (VND)</th>
                            <th>Add Fine</th>
                        </tr>
                    </thead>
                    <tbody>
                        <jsp:useBean id="returnSlipDAO" class="com.library.libman.dao.ReturnSlipDAO" />
                        <c:set var="index" value="1" scope="page"/>
                        <c:set var="totalFine" value="0" scope="page"/>
                        <c:forEach var="detail" items="${selectedDocuments}">
                            <c:set var="returnSlipDetail" value="${returnSlipDAO.getReturnSlipDetailByBorrowSlipDetailId(detail.id)}"/>
                            <tr>
                                <td><c:out value="${index}"/></td>
                                <td><c:out value="${detail.document.id}"/></td>
                                <td><c:out value="${detail.document.title}"/></td>
                                <td>
                                    <c:if test="${not empty returnSlipDetail and not empty returnSlipDetail.fineDetails}">
                                        <c:forEach var="fineDetail" items="${returnSlipDetail.fineDetails}" varStatus="loop">
                                            <c:out value="${fineDetail.fine.type}"/>                                        
                                            <c:if test="${!loop.last}">
                                                <c:out value=", "/>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                </td> 
                                <td><c:out value="${not empty returnSlipDetail ? returnSlipDetail.totalFineDetail : '0'}"/></td>    
                                <td>
                                    <a href="/libman/fine?borrowSlipDetailId=${detail.id}">Add</a>
                                </td>
                            </tr>
                            <input type="hidden" name="selectedDetails" value="<c:out value='${detail.id}'/>">
                            <c:set var="index" value="${index + 1}" scope="page"/>
                            <c:set var="totalFine" value="${totalFine + (not empty returnSlipDetail ? returnSlipDetail.totalFineDetail : 0)}" scope="page"/>
                        </c:forEach>
                        <tr style="font-weight: bold;">
                            <td colspan="4" style="text-align: right;">Total Fine:</td>
                            <td><c:out value="${totalFine}"/></td>
                            <td></td>
                        </tr>
                    </tbody>
                </table>

                <div class="button-group">
                    <button type="button" class="button back" onclick="history.back()">Back</button>
                    
                    <button type="button" class="button confirm">Export Return Slip</button>
                </div>
            </form>
        </c:if>
    </div>
    <div id="confirmationModal" class="modal">
      <div class="modal-content">
        <span class="close">&times;</span>
        <p>Are you sure you want to export this return slip?</p>
        <button id="confirmBtn" class="button confirm">Confirm</button>
        <button id="cancelBtn" class="button back">Cancel</button>
      </div>
    </div>

    <script>
        var modal = document.getElementById("confirmationModal");
        var btn = document.querySelector(".button.confirm"); // Select the export button
        var span = document.getElementsByClassName("close")[0];
        var confirmBtn = document.getElementById("confirmBtn");
        var cancelBtn = document.getElementById("cancelBtn");
        var form = document.querySelector("form[action='/libman/create-return-slip']");

        btn.onclick = function(event) {
            event.preventDefault(); 
            modal.style.display = "block";
        }

        span.onclick = function() {
            modal.style.display = "none";
        }

        cancelBtn.onclick = function() {
            modal.style.display = "none";
        }

        confirmBtn.onclick = function() {
            form.submit();
        }

        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
</body>
</html>
