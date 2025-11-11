<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.libman.model.BorrowSlipDetail, com.library.libman.model.Fine, com.library.libman.model.FineDetail, java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Add Fine</title>
    <link rel="stylesheet" type="text/css" href="style.css">
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
<div class="container">
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
            <form action="/libman/save-fine" method="post">
                 <input type="hidden" name="borrowSlipDetailId" value="${borrowSlipDetail.id}">
                 <input type="hidden" id="totalFineInput" name="totalFine" value="0">
                 <button type="submit" class="button confirm">Save</button>
            </form>
            <button type="button" class.="button back" onclick="history.back()">Back</button>
        </div>
    </c:if>
</div>
</body>
</html>