<%-- Document : login Created on : Jun 3, 2026, 8:46:11 AM Author : Lenovo --%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Log In - SewaIn</title>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth/login.css?v=1.2" />
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
  <body>
    <a class="back-link" href="${pageContext.request.contextPath}/index.jsp">← Back to Home</a>

    <main class="login-split">
      <section class="split-left" aria-hidden="true">
        <div class="left-overlay"></div>
        <div class="left-content">
          <h1>Elevate Your Living Experience</h1>
          <p>
            Discover curated spaces designed for comfort, trust, and modern
            living.
          </p>
        </div>
      </section>

      <section class="split-right">
        <div class="login-card" role="region" aria-labelledby="login-title">
          <h2 id="login-title">Log In</h2>
          <p class="sub">Enter your details to join SewaIn.</p>

          <% if (request.getAttribute("errorMsg") != null) { %>
              <div class="alert alert-danger" style="color: #e53e3e; background-color: #fff5f5; padding: 12px; border-radius: 8px; margin-bottom: 16px; border: 1px solid #fed7d7; font-size: 14px; text-align: left;">
                  <%= request.getAttribute("errorMsg") %>
              </div>
          <% } %>
          <% if (request.getAttribute("successMsg") != null) { %>
              <div class="alert alert-success" style="color: #38a169; background-color: #f0fff4; padding: 12px; border-radius: 8px; margin-bottom: 16px; border: 1px solid #c6f6d5; font-size: 14px; text-align: left;">
                  <%= request.getAttribute("successMsg") %>
              </div>
          <% } %>

          <form
            id="loginForm"
            action="${pageContext.request.contextPath}/login"
            method="post"
            novalidate
          >
            <div class="field">
              <input
                id="email"
                name="email_or_username"
                type="email"
                required
                autocomplete="email"
              />
              <label for="email">Email Address</label>
            </div>

            <div class="field field-password">
              <input
                id="password"
                name="password"
                type="password"
                required
                autocomplete="current-password"
              />
              <label for="password">Password</label>
              <button
                type="button"
                class="toggle-pass"
                aria-label="Show password"
              >
                <svg
                  width="20"
                  height="20"
                  viewBox="0 0 24 24"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M12 5C7 5 2.73 8.11 1 12c1.73 3.89 6 7 11 7s9.27-3.11 11-7c-1.73-3.89-6-7-11-7z"
                    stroke="currentColor"
                    stroke-width="1.2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  />
                  <circle
                    cx="12"
                    cy="12"
                    r="3"
                    stroke="currentColor"
                    stroke-width="1.2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  />
                </svg>
              </button>
            </div>

            <button class="btn-login" type="submit">Login</button>
          </form>

          <p class="signup">
            Don't have an account? <a href="${pageContext.request.contextPath}/register">Sign Up</a>
          </p>
        </div>
      </section>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/auth/login.js"></script>
  </body>
</html>
