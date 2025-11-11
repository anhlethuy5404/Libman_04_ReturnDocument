<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.library.libman.model.User" %>
<% User user=(User) session.getAttribute("user"); if (user==null) { response.sendRedirect("login.jsp");
        return; } %>
<html>
<head>
    <title>Reader Card Registration</title>
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

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }

        h2 {
            font-size: 36px;
            color: #0d47a1;
            margin-bottom: 32px;
            padding: 0 32px;
            font-weight: 700;
            letter-spacing: -0.5px;
        }
        
        .message {
            padding: 12px 32px;
            margin: 0 32px 20px 32px;
            border-radius: 4px;
            font-weight: 600;
            border: 1px solid transparent;
            font-size: 14px;
        }

        .message.success {
            background-color: #e8f5e9; 
            color: #2e7d32;
            border-color: #a5d6a7;
        }

        .message.error {
            background-color: #ffebee;
            color: #c62828;
            border-color: #ef9a9a;
        }

        .registration-form {
            background: white;
            padding: 30px 32px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(13, 71, 161, 0.1);
            max-width: 100%;
            margin: 0 32px 32px 32px; 
            border: 1px solid #e1f5fe;
        }
        
        .registration-form p {
            font-weight: 600;
            color: #1565c0;
            margin-bottom: 15px;
            font-size: 15px;
        }

        .registration-form table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
        }

        .registration-form td:first-child {
            font-weight: 600; 
            color: #1a3a52;
            padding-right: 15px;
            white-space: nowrap;
            width: 120px; 
            padding-top: 10px;
            padding-bottom: 10px;
            vertical-align: top;
        }

        .registration-form td input[type="text"],
        .registration-form td input[type="date"],
        .registration-form td select {
            width: 100%;
            padding: 10px 12px;
            margin: 0;
            border: 2px solid #90caf9;
            border-radius: 4px;
            font-size: 14px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            transition: all 0.3s ease;
            outline: none;
            background-color: #f8f8f8;
            color: #1a3a52;
            box-sizing: border-box; 
        }
        
        .registration-form td input[type="date"]:focus,
        .registration-form td input[type="text"]:focus,
        .registration-form td select:focus {
            border-color: #1565c0;
            box-shadow: 0 0 0 3px rgba(21, 101, 192, 0.1);
        }
        
        input[type="submit"] {
            background-color: #1976d2;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
            display: inline-block;
            width: auto; 
        }

        input[type="submit"]:hover {
            background-color: #0d47a1;
            box-shadow: 0 4px 12px rgba(13, 71, 161, 0.2);
        }

        .submit-row {
            text-align: center;
            padding-top: 20px;
        }
        
        button.button {
            background-color: #757575;
            color: white;
            border: none;
            font-weight: 600;
            cursor: pointer;
            padding: 12px 24px;
            border-radius: 4px;
            font-size: 15px;
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
            margin: 0 32px;
        }

        button.button:hover {
            background-color: #616161;
            box-shadow: 0 4px 8px rgba(97, 97, 97, 0.2);
        }
</style>
</head>
<body>
    <div class="header">
            <div>Hello, <strong>
                    <%= user.getName() %>
                </strong>!</div>
        </div>
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
