<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:choose>
    <c:when test="${not empty borrowingList}">
        <form action="select-documents" method="post">
            <table border="1" cellpadding="5">
                <thead>
                    <tr>
                        <th>Chọn</th>
                        <th>Tên tài liệu</th>
                        <th>Ngày mượn</th>
                        <th>Ngày hết hạn</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${borrowingList}">
                        <tr>
                            <td><input type="checkbox" name="selectedDocs" value="${item.id}"></td>
                            <td><c:out value="${item.document.title}" /></td>
                            <td><fmt:formatDate value="${item.borrowSlip.borrowDate}" pattern="dd-MM-yyyy" /></td>
                            <td><fmt:formatDate value="${item.borrowSlip.dueDate}" pattern="dd-MM-yyyy" /></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <br>
            <input type="submit" value="Tiếp theo">
        </form>
    </c:when>
    <c:otherwise>
        <p><em>Bạn đọc này không có tài liệu nào đang mượn.</em></p>
    </c:otherwise>
</c:choose>
