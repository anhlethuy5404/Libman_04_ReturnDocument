<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.libman.model.BorrowSlipDetail, com.library.libman.model.Fine, com.library.libman.model.FineDetail, java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.library.libman.model.User" %>
<% User user=(User) session.getAttribute("user"); if (user==null) { response.sendRedirect("login.jsp");
        return; } %>
<html>
<head>
    <title>Add Fine</title>
    <style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f0f7ff;
        color: #1a3a52;
        line-height: 1.6;
    }

    .container {
        max-width: 1000px;
        margin: 0 auto;
        padding: 20px;
    }

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

    h1 {
        font-size: 36px;
        color: #0d47a1;
        margin-bottom: 32px;
        padding: 0 32px;
        font-weight: 700;
        letter-spacing: -0.5px;
    }

    h3 {
        font-size: 14px;
        color: #1565c0;
        margin-bottom: 20px;
        margin-top: 32px;
        padding: 0 32px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    hr {
        border: none;
        border-top: 2px solid #e1f5fe;
        margin: 32px 0;
    }

    /* Form Styling */
    form {
        padding: 0 32px;
        margin-bottom: 24px;
    }

    label {
        display: inline-block;
        font-weight: 600;
        color: #1565c0;
        margin-right: 16px;
        margin-bottom: 12px;
        font-size: 14px;
    }

    input[type="text"],
    input[type="submit"],
    select,
    input[type="number"],
    button.button { 
        padding: 12px 16px;
        border: 2px solid #90caf9;
        border-radius: 4px;
        font-size: 14px;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        transition: all 0.3s ease;
        margin-right: 8px;
    }
    
    input[type="number"] {
        width: 80px; 
        text-align: center;
    }

    input[type="text"],
    input[type="number"] {
        background-color: white;
        color: #1a3a52;
        width: 250px;
    }

    input[type="text"]:focus,
    input[type="number"]:focus {
        outline: none;
        border-color: #1565c0;
        box-shadow: 0 0 0 3px rgba(21, 101, 192, 0.1);
    }

    input[type="submit"],
    button.button {
        background-color: #1976d2;
        color: white;
        border: none;
        font-weight: 600;
        cursor: pointer;
        padding: 12px 24px;
    }
    
    button.button.add {
        background-color: #4caf50; 
    }

    input[type="submit"]:hover,
    button.button:hover {
        background-color: #0d47a1;
        box-shadow: 0 4px 12px rgba(13, 71, 161, 0.2);
    }
    
    button.button.add:hover {
        background-color: #388e3c; 
        box-shadow: 0 4px 12px rgba(56, 142, 60, 0.2);
    }
    button.button.back {
        background-color: #757575;
        color: white;
    }

    button.button.back:hover {
        background-color: #616161;
        box-shadow: 0 4px 8px rgba(97, 97, 97, 0.2);
    }
    
    a.button.delete {
        display: inline-block;
        background-color: #f44336; 
        color: white;
        border: none;
        font-weight: 600;
        cursor: pointer;
        padding: 8px 16px; 
        border-radius: 4px;
        text-decoration: none;
        font-size: 12px;
        transition: all 0.3s ease;
    }
    
    a.button.delete:hover {
        background-color: #d32f2f;
        box-shadow: 0 2px 8px rgba(211, 47, 47, 0.2);
    }

    button.button.confirm {
        background-color: #1976d2;
        color: white;
    }
    
    button.button.confirm:hover {
        background-color: #0d47a1;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(13, 71, 161, 0.2);
    }


    .info-section {
        background: white;
        padding: 24px 32px;
        border-left: 4px solid #1976d2;
        border-radius: 4px;
        box-shadow: 0 2px 4px rgba(13, 71, 161, 0.08);
        margin-bottom: 32px;
    }

    .info-section p {
        margin-bottom: 12px;
        font-size: 15px;
        line-height: 1.8;
    }

    .info-section strong {
        color: #0d47a1;
        font-weight: 600;
    }

    table {
        width: calc(100% - 64px);
        margin: 24px 32px;
        border-collapse: collapse;
        background: white;
        box-shadow: 0 2px 8px rgba(13, 71, 161, 0.1);
        border-radius: 4px;
        overflow: hidden;
    }

    thead {
        background: linear-gradient(135deg, #0d47a1 0%, #1565c0 100%);
        color: white;
    }

    th {
        padding: 16px;
        text-align: left;
        font-weight: 600;
        font-size: 14px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    td {
        padding: 14px 16px;
        border-bottom: 1px solid #e3f2fd;
        font-size: 14px;
        color: #1a3a52;
    }

    tbody tr {
        transition: background-color 0.2s ease;
    }

    tbody tr:hover {
        background-color: #f0f7ff;
    }

    tbody tr:last-child td {
        border-bottom: none;
    }

    p {
        padding: 0 32px;
        color: #666;
    }
    
    p strong {
        color: #0d47a1;
    }
    
    .button-group {
        text-align: center; 
        padding: 20px 32px 0 32px;
        display: flex; 
        justify-content: center; 
        gap: 16px; 
        margin-bottom: 20px;
    }
    
    .button-group form {
        padding: 0;
        margin-bottom: 0;
        display: inline-block; 
    }
    
    #fineForm {
        padding: 0 32px;
        margin-bottom: 24px;
        display: flex;
        gap: 10px;
        align-items: center;
    }
    
</style>
    <script>
        function onFineChange() {
            var fineSelect = document.getElementById("fineSelect");
            var selectedOption = fineSelect.options[fineSelect.selectedIndex];
            var fineType = selectedOption.getAttribute("data-type");
            var quantityInput = document.getElementById("quantity");

            if (fineType === 'Miss Page' || fineType === 'Dirty') {
                quantityInput.style.display = 'inline-block';
            } else {
                quantityInput.style.display = 'none';
            }
        }

        function calculateTotalFine() {
            var table = document.getElementById("fineListTable").getElementsByTagName('tbody')[0];
            var totalFine = 0;
            for (var i = 0; i < table.rows.length; i++) {
                totalFine += parseFloat(table.rows[i].cells[2].innerHTML);
            }
            document.getElementById("totalFine").innerHTML = totalFine.toFixed(2);
            document.getElementById("totalFineInput").value = totalFine.toFixed(2);
        }

        window.onload = function() {
            calculateTotalFine();
        };
    </script>
</head>
<body>
    <div class="header">
            <div>Hello, <strong>
                    <%= user.getName() %>
                </strong>!</div>
        </div>
    <h1>Add Fine</h1>

    <c:if test="${not empty borrowSlipDetail}">
        <h3>Document Information</h3>
        <div class="info-section">
            <p><strong>Document ID:</strong> ${borrowSlipDetail.document.id}</p>
            <p><strong>Title:</strong> ${borrowSlipDetail.document.title}</p>
            <p><strong>Author:</strong> ${borrowSlipDetail.document.author}</p>
            <p><strong>Price:</strong> ${borrowSlipDetail.document.price}</p>
            <input type="hidden" id="documentPrice" value="${borrowSlipDetail.document.price}">
        </div>

        <h3>Fine List</h3>
        <table id="fineListTable">
            <thead>
            <tr>
                <th>No</th>
                <th>Status</th>
                <th>Fine (VND)</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="fineDetail" items="${fineDetails}" varStatus="status">
                <tr>
                    <td>${status.count}</td>
                    <td>
                        ${fineDetail.fine.type}
                        <c:if test="${fineDetail.quantity > 1}">
                            (x${fineDetail.quantity})
                        </c:if>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${fineDetail.fine.type == 'Late Return'}">
                                <fmt:parseDate value="${borrowSlipDetail.borrowSlip.dueDate}" pattern="yyyy-MM-dd" var="dueDate"/>
                                <jsp:useBean id="now" class="java.util.Date"/>
                                <c:set var="overdueDays" value="${Math.ceil((now.time - dueDate.time) / (1000 * 60 * 60 * 24))}"/>
                                <c:if test="${overdueDays < 0}"><c:set var="overdueDays" value="0"/></c:if>
                                ${fineDetail.fine.amount * overdueDays}
                            </c:when>
                            <c:otherwise>
                                ${fineDetail.fine.amount * fineDetail.quantity}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="/libman/delete-fine-detail?fineDetailId=${fineDetail.id}&borrowSlipDetailId=${borrowSlipDetail.id}" class="button delete">Delete</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <p><strong>Total Fine:</strong> <span id="totalFine">0</span></p>

        <h3>Add Fine</h3>
        <form id="fineForm" action="/libman/add-fine-detail" method="post">
            <input type="hidden" name="borrowSlipDetailId" value="${borrowSlipDetail.id}">
            <select id="fineSelect" name="fineId" onchange="onFineChange()">
                <c:forEach var="fine" items="${fines}">
                    <option value="${fine.id}" data-amount="${fine.amount}" data-type="${fine.type}">${fine.type}</option>
                </c:forEach>
            </select>
            <input type="number" id="quantity" name="quantity" min="1" value="1" style="display: none;">
            <button type="submit" class="button add">Add Fine</button>
        </form>

        <div class="button-group">            
            <button type="button" class="button back" onclick="history.back()">Back</button>
            <form action="/libman/save-fine" method="post">
                 <input type="hidden" name="borrowSlipDetailId" value="${borrowSlipDetail.id}">
                 <input type="hidden" id="totalFineInput" name="totalFine" value="0">
                 <button type="submit" class="button confirm">Save</button>
            </form>
        </div>
    </c:if>

</body>
</html>