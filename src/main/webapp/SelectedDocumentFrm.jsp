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
    <style>
        * {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
  background-color: #f0f7ff;
  color: #1a3a52;
  line-height: 1.6;
}

.container {
  max-width: 1000px;
  margin: 0 auto;
  padding: 20px;
}

/* Header Styles */
.header {
  background: linear-gradient(135deg, #0d47a1 0%, #1976d2 100%);
  color: white;
  padding: 24px 32px;
  border-bottom: 4px solid #0d3f8f;
  box-shadow: 0 2px 8px rgba(13, 71, 161, 0.1);
  margin-bottom: 40px;
}

.header div {
  font-size: 18px;
  font-weight: 500;
  letter-spacing: 0.5px;
}

.header strong {
  font-weight: 700;
  color: #e3f2fd;
}

/* Typography */
h1 {
  font-size: 36px;
  color: #0d47a1;
  margin-bottom: 32px;
  padding: 0 32px;
  font-weight: 700;
  letter-spacing: -0.5px;
}

h3 {
  font-size: 20px;
  color: #1565c0;
  margin-bottom: 20px;
  padding: 0 32px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 1px;
  font-size: 14px;
}

/* List Styles */
ul {
  list-style: none;
  padding: 0 32px;
  margin-bottom: 40px;
}

li {
  background: white;
  margin-bottom: 12px;
  border-left: 4px solid #1976d2;
  padding: 16px 20px;
  border-radius: 4px;
  transition: all 0.3s ease;
  box-shadow: 0 1px 3px rgba(13, 71, 161, 0.08);
}

li:hover {
  box-shadow: 0 4px 12px rgba(13, 71, 161, 0.15);
  transform: translateX(4px);
  border-left-color: #0d47a1;
}

/* Link Styles */
a {
  color: #1565c0;
  text-decoration: none;
  font-weight: 600;
  font-size: 16px;
  transition: color 0.2s ease;
}

a:hover {
  color: #0d47a1;
  text-decoration: underline;
}

li a {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

li a::after {
  content: "→";
  margin-left: 12px;
  opacity: 0;
  transition: opacity 0.2s ease;
}

li:hover a::after {
  opacity: 1;
}

/* Info Section Styles */
.info-section {
  background: white;
  padding: 24px;
  border-left: 4px solid #1976d2;
  border-radius: 4px;
  margin-bottom: 32px;
  box-shadow: 0 1px 3px rgba(13, 71, 161, 0.08);
}

.info-section p {
  margin-bottom: 12px;
  font-size: 15px;
}

.info-section strong {
  color: #0d47a1;
  font-weight: 600;
}

/* Table Styles */
table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  border-radius: 4px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(13, 71, 161, 0.08);
  margin-bottom: 24px;
}

thead {
  background: linear-gradient(135deg, #0d47a1 0%, #1565c0 100%);
  color: white;
}

th {
  padding: 16px;
  text-align: left;
  font-weight: 600;
  letter-spacing: 0.5px;
}

td {
  padding: 14px 16px;
  border-bottom: 1px solid #e8f1f8;
}

tbody tr {
  transition: all 0.3s ease;
}

tbody tr:hover {
  background-color: #f0f7ff;
}

tbody tr:last-child td {
  border-bottom: none;
}

/* Form Styles */
form {
  padding: 0 32px;
  margin-bottom: 24px;
}

select,
input[type="text"],
input[type="number"],
textarea {
  width: 100%;
  max-width: 400px;
  padding: 12px;
  margin-bottom: 12px;
  border: 2px solid #e8f1f8;
  border-radius: 4px;
  font-size: 14px;
  font-family: inherit;
  transition: all 0.3s ease;
}

select:focus,
input:focus,
textarea:focus {
  outline: none;
  border-color: #1976d2;
  background-color: #f0f7ff;
  box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.1);
}

/* Button Styles */
.button {
  display: inline-block;
  padding: 12px 24px;
  margin: 8px 12px 8px 0;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  text-decoration: none;
  vertical-align: middle;
}

.button.add {
  background-color: #1976d2;
  color: white;
}

.button.add:hover {
  background-color: #0d47a1;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(13, 71, 161, 0.2);
}

.button.confirm {
  background-color: #43a047;
  color: white;
}

.button.confirm:hover {
  background-color: #2e7d32;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(46, 125, 50, 0.2);
}

.button.delete {
  background-color: #e53935;
  color: white;
  padding: 8px 16px;
  font-size: 12px;
}

.button.delete:hover {
  background-color: #c62828;
}

.button.back {
  background-color: #757575;
  color: white;
}

.button.back:hover {
  background-color: #616161;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(97, 97, 97, 0.2);
}

.button.print {
  background-color: #1976d2;
  color: white;
}

.button.print:hover {
  background-color: #0d47a1;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(13, 71, 161, 0.2);
}

/* Button Group */
.button-group {
  margin-top: 24px;
  padding: 0 32px;
  text-align: center;
}

.button-group form {
  display: inline-block;
  padding: 0;
  margin: 0;
}

.button-group button {
  display: inline-block;
}

/* Error Message */
.error {
  background-color: #ffebee;
  color: #c62828;
  padding: 16px;
  border-left: 4px solid #e53935;
  border-radius: 4px;
  margin-bottom: 24px;
  padding: 0 32px;
}

.error a {
  color: #c62828;
  font-weight: 700;
}

.error a:hover {
  text-decoration: underline;
}

/* Total Fine Display */
.total-fine {
  padding: 0 32px;
  margin-bottom: 24px;
  font-size: 18px;
  font-weight: 600;
  color: #0d47a1;
}

/* Modal Styles */
.modal {
  display: none;
  position: fixed;
  z-index: 1000;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  overflow: auto;
  background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
  background-color: white;
  margin: 15% auto;
  padding: 30px;
  border: none;
  border-radius: 8px;
  width: 90%;
  max-width: 400px;
  text-align: center;
  box-shadow: 0 8px 24px rgba(13, 71, 161, 0.2);
}

.close {
  color: #bdbdbd;
  float: right;
  font-size: 28px;
  font-weight: bold;
  cursor: pointer;
  transition: color 0.3s ease;
}

.close:hover,
.close:focus {
  color: #0d47a1;
}

.modal-content p {
  margin-bottom: 24px;
  color: #1a3a52;
  font-size: 16px;
}

    </style>
</head>
<body>
        <div class="header">
            <div>Hello, <strong>
                    <%= user.getName() %>
                </strong>!</div>
        </div>
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
                    
                    <button type="button" class="button print">Export Return Slip</button>
                </div>
            </form>
        </c:if>
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
        var btn = document.querySelector(".button.print"); 
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
