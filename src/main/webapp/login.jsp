<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <html>

    <head>
        <title>Đăng Nhập</title>
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
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }

            h1 {
                font-size: 36px;
                color: #0d47a1;
                margin-bottom: 8px;
                font-weight: 700;
                letter-spacing: -0.5px;
            }

            h2 {
                font-size: 24px;
                color: #1976d2;
                margin-bottom: 24px;
                font-weight: 600;
            }

            form {
                background: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(13, 71, 161, 0.1);
                border: 1px solid #e1f5fe;
                width: 350px;
            }

            form table {
                width: 100%;
                border-collapse: collapse;
            }

            form table tr td:first-child {
                font-weight: 600;
                color: #1565c0;
                padding-right: 15px;
                padding-bottom: 15px;
                font-size: 14px;
            }
            
            form table tr td {
                padding-bottom: 15px;
            }

            input[type="text"],
            input[type="password"] {
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
            }

            input[type="text"]:focus,
            input[type="password"]:focus {
                border-color: #1565c0;
                box-shadow: 0 0 0 3px rgba(21, 101, 192, 0.1);
            }

            input[type="submit"] {
                width: 100%;
                background-color: #1976d2;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 15px;
                font-weight: 600;
                margin-top: 10px;
                transition: background-color 0.3s ease;
            }

            input[type="submit"]:hover {
                background-color: #0d47a1;
                box-shadow: 0 4px 12px rgba(13, 71, 161, 0.2);
            }

            p {
                color: #f44336;
                margin-bottom: 15px;
                text-align: center;
            }

            a {
                color: #1565c0;
                text-decoration: none;
                display: block;
                text-align: center;
                margin-top: 15px;
                font-size: 14px;
            }

            a:hover {
                text-decoration: underline;
            }
        </style>
    </head>

    <body>
        <h1>Library Management</h1>
        <h2>Login</h2>

        <p style="color:red;">${requestScope.errorMessage}</p>

        <form action="login" method="post">
            <table>
                <tr>
                    <td>Username:</td>
                    <td><input type="text" name="username" required></td>
                </tr>
                <tr>
                    <td>Password:</td>
                    <td><input type="password" name="password" required></td>
                </tr>
                <tr>
                    <td colspan="2"><input type="submit" value="Login"></td>
                </tr>
            </table>
        </form>
    </body>

    </html>