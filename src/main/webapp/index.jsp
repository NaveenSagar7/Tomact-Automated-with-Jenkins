<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Cricket World</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #1e3c72, #2a5298);
            color: #fff;
            text-align: center;
        }
        header {
            padding: 40px;
            background-color: rgba(0,0,0,0.4);
        }
        h1 {
            font-size: 3em;
            margin: 0;
            animation: fadeIn 2s ease-in-out;
        }
        p {
            font-size: 1.2em;
            margin-top: 10px;
        }
        #clock {
            font-size: 1.5em;
            margin-top: 20px;
            font-weight: bold;
        }
        .quote {
            margin-top: 30px;
            font-style: italic;
            font-size: 1.3em;
            color: #f1c40f;
        }
        .btn {
            display: inline-block;
            margin-top: 30px;
            padding: 12px 25px;
            font-size: 1em;
            color: #1e3c72;
            background-color: #fff;
            border-radius: 25px;
            text-decoration: none;
            transition: 0.3s;
        }
        .btn:hover {
            background-color: #f1c40f;
            color: #000;
        }
        footer {
            margin-top: 50px;
            padding: 20px;
            font-size: 0.9em;
            background-color: rgba(0,0,0,0.3);
        }
        @keyframes fadeIn {
            from {opacity: 0;}
            to {opacity: 1;}
        }
    </style>
    <script>
        function updateClock() {
            const now = new Date();
            document.getElementById('clock').innerText = now.toLocaleTimeString();
        }
        setInterval(updateClock, 1000);
    </script>
</head>
<body onload="updateClock()">
    <header>
        <h1>🏏 Cricket World Application is UP!</h1>
        <p>Welcome to the ultimate cricket experience — stay tuned for scores, stats, and more.</p>
        <div id="clock"></div>
        <div class="quote">"Cricket is not just a game, it’s a way of life." – Anonymous</div>
        <a href="home.jsp" class="btn">Enter Application</a>
    </header>

    <footer>
        &copy; <%= java.time.Year.now() %> Cricket World. All rights reserved.
    </footer>
</body>
</html>