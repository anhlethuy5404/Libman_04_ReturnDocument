<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.libman.model.User, com.library.libman.model.Reader, com.library.libman.model.ReturnSlip, com.library.libman.model.BorrowSlipDetail, com.library.libman.model.ReturnSlipDetail, com.library.libman.model.FineDetail" %>
<%@ page import="com.library.libman.dao.ReaderDAO, com.library.libman.dao.ReturnSlipDetailDAO" %>
<%@ page import="java.util.List, java.util.Date" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    ReturnSlip createdSlip = (ReturnSlip) request.getAttribute("createdReturnSlip");
    String readerCode = (String) request.getAttribute("readerCodeForExport");

    if (readerCode == null || readerCode.isEmpty() || createdSlip == null) {
        response.sendRedirect("DocumentReturnFrm.jsp");
        return;
    }

    // Fetch the reader by code
    ReaderDAO readerDAO = new ReaderDAO();
    Reader reader = readerDAO.searchReaderByReaderCode(readerCode);

    // If reader is not found, we cannot proceed.
    if (reader == null) {
        response.sendRedirect("DocumentReturnFrm.jsp");
        return;
    }
    
    // Fetch ReturnSlipDetails directly in JSP as requested
    ReturnSlipDetailDAO returnSlipDetailDAO = new ReturnSlipDetailDAO();
    List<ReturnSlipDetail> returnSlipDetails = returnSlipDetailDAO.getReturnSlipDetailsByReturnSlipId(createdSlip.getId());
    pageContext.setAttribute("returnSlipDetailsForJSP", returnSlipDetails);


    // Also get librarian name from session
    User librarian = (User) session.getAttribute("user");
    String librarianName = (librarian != null) ? librarian.getName() : "N/A";

    // Set attributes for JSTL to use
    pageContext.setAttribute("reader", reader);
    pageContext.setAttribute("returnSlip", createdSlip);
    pageContext.setAttribute("returnDate", createdSlip.getReturnDate()); 
    pageContext.setAttribute("librarianName", librarianName);
%>
<html>

<head>
    <title>Export Return Slip</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border: 1px solid #ccc;
        }

        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
        }

        .info-label {
            font-weight: bold;
            width: 150px;
            display: inline-block;
        }

        .slip-info {
            margin-bottom: 20px;
            line-height: 1.8;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th,
        td {
            border: 1px solid #000;
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        .total-row {
            font-weight: bold;
            text-align: right;
        }

        .button-group {
            margin-top: 30px;
            text-align: center;
        }

        .button {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 4px;
            font-size: 16px;
            margin: 0 10px;
        }

        .button.back {
            background-color: #95a5a6;
        }

        /* CSS cho việc in ấn */
        @media print {
            .button-group {
                display: none;
            }

            .container {
                box-shadow: none;
                border: none;
                padding: 0;
            }
        }
    </style>
</head>

<body>
    <div class="container">
        <h1>LIBRARY RETURN SLIP</h1>

        <%-- Toàn bộ phiếu trả là một khối thông tin --%>
            <div class="slip-info">
                <p><span class="info-label">Slip Date:</span>
                    <c:out value="${returnDate}" />
                </p>
                <p><span class="info-label">Librarian:</span>
                    <c:out value="${librarianName}" />
                </p>
                <p><span class="info-label">Reader Code:</span>
                    <c:out value="${reader.readerCode}" />
                </p>
                <p><span class="info-label">Reader Name:</span>
                    <c:out value="${reader.name}" />
                </p>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>No</th>
                        <th>Document ID</th>
                        <th>Title</th>
                        <th>Fine Type</th>
                        <th>Fine (VND)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="index" value="1" />
                    <c:set var="totalFine" value="0" />

                    <c:forEach var="returnSlipDetail" items="${returnSlipDetailsForJSP}">

                        <tr>
                            <td>
                                <c:out value="${index}" />
                            </td>
                            <td>
                                <c:out value="${returnSlipDetail.borrowSlipDetail.document.id}" />
                            </td>
                            <td>
                                <c:out value="${returnSlipDetail.borrowSlipDetail.document.title}" />
                            </td>

                            <td>
                                <c:if test="${not empty returnSlipDetail.fineDetails}">
                                    <c:forEach var="fineDetail" items="${returnSlipDetail.fineDetails}">

                                        <c:out value="${fineDetail.fine.type}" />
                                    </c:forEach>

                                </c:if>
                            </td>
                            <td>
                                <c:out value="${returnSlipDetail.totalFineDetail}" />

                                <c:set var="totalFine" value="${totalFine + returnSlipDetail.totalFineDetail}" />
                            </td>
                        </tr>

                        <c:set var="index" value="${index + 1}" />
                    </c:forEach>

                    <tr class="total-row">
                        <td colspan="4">TOTAL FINE:</td>

                        <td>
                            <c:out value="${totalFine}" />
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="button-group">
                <button type="button" class="button print" onclick="printAndMarkAsPrinted(${returnSlip.id})">Print
                    Slip</button>
                <button type="button" class="button back" onclick="window.location.href='DocumentReturnFrm.jsp'">Done /
                    Go Back</button>
            </div>
    </div>
    <script>
        function printAndMarkAsPrinted(returnSlipId) {
            window.print();

            fetch('/libman/update-return-slip-status', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'returnSlipId=' + returnSlipId + '&status=Printed'
            })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.text();
                })
                .then(data => {
                    console.log('Status update successful:', data);
                })
                .catch(error => {
                    console.error('Error updating status:', error);
                });
        }
    </script>
</body>

</html>