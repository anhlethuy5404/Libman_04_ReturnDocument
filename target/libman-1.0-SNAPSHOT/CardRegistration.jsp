<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Reader Card Registration</title>
    <link rel="stylesheet" type="text/css" href="style.css">
<style>
    .registration-form table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0 10px;
    }

    .registration-form td:first-child {
        font-weight: bold;
        padding-right: 15px;
        white-space: nowrap;
    }

    .registration-form td input[type="text"],
    .registration-form td input[type="date"],
    .registration-form td select {
        width: 100%;
        max-width: none;
    }

    .submit-row {
        text-align: center;
        padding-top: 10px;
    }
</style>
</head>
<body>
    <div class="container">
    <h2>Reader Card Registration</h2>
    <div class="message">${message}</div>

    <script>
        (function() {
            var messageDiv = document.querySelector('.message');
            var messageText = messageDiv.textContent.trim();
            if (messageText) {
                if (messageText.toLowerCase().includes('success')) {
                    messageDiv.classList.add('success');
                } else {
                    messageDiv.classList.add('error');
                }
            }
        })();
    </script>

    <form action="reader-card-register" method="post" class="registration-form">


            <p>Enter information:</p>
        <table>
            <tr>
                <td>Name:</td>
                <td><input type="text" name="name" required></td>
            </tr>
            <tr>
                <td>Birthday:</td>
                <td><input type="date" name="birthday" required></td>
            </tr>
            <tr>
                <td>Card Type:</td>
                <td>
                    <select name="cardType">
                        <option value="student">Student</option>
                        <option value="teacher">Teacher</option>
                        <option value="guest">Guest</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>Duration (year):</td>
                <td>
                    <select name="duration">
                        <option value="1">1 year</option>
                        <option value="2">2 year</option>
                        <option value="3">3 year</option>
                        <option value="4">4 year</option>
                        <option value="5">5 year</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2"><input type="submit" value="Register"></td>
            </tr>
        </table>
    </form>
    <br>
    <button type="button" class="button back" onclick="history.back()">Back</button>
    </div>
</body>
</html>
