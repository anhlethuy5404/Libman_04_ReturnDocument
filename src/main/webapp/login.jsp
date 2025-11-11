<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <html>

    <head>
        <title>Đăng Nhập</title>
        <style>
            body {
              font-family: Arial, sans-serif;
              background-color: #fff;
              color: #000;
              display: flex;
              flex-direction: column;
              justify-content: center;
              align-items: center;
              height: 100vh;
              margin: 0;
            }

            form {
              background: #f9f9f9;
              border: 1px solid #ccc;
              padding: 30px;
              border-radius: 10px;
              box-shadow: 0 2px 6px rgba(0,0,0,0.1);
              width: 300px;
            }

            h2 {
              text-align: center;
              color: #3498db;
              margin-bottom: 20px;
            }

            input[type="text"],
            input[type="password"] {
              width: 100%;
              padding: 10px;
              margin: 8px 0;
              border: 1px solid #ccc;
              border-radius: 5px;
              outline: none;
            }

            input[type="text"]:focus,
            input[type="password"]:focus {
              border-color: #3498db;
            }

            input[type="submit"] {
              width: 100%;
              background-color: #3498db;
              color: white;
              border: none;
              padding: 10px;
              border-radius: 5px;
              cursor: pointer;
              font-size: 15px;
            }

            input[type="submit"]:hover {
              background-color: #217dbb;
            }

            a {
              color: #3498db;
              text-decoration: none;
              display: block;
              text-align: center;
              margin-top: 10px;
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