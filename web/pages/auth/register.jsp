<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Create Account - SewaIn</title>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth/register.css?v=1.2" />
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
        <div class="login-card" role="region" aria-labelledby="reg-title">
          <h2 id="reg-title">Create Account</h2>
          <p class="sub">Join SewaIn — simple, fast, and secure.</p>

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
            id="registerForm"
            action="${pageContext.request.contextPath}/register"
            method="post"
            novalidate
          >
            <div class="field">
              <input
                id="fullname"
                name="username" type="text"
                required
                autocomplete="name"
              />
              <label for="fullname">Full Name</label>
            </div>

            <div class="field">
              <input
                id="email"
                name="email"
                type="email"
                required
                autocomplete="email"
              />
              <label for="email">Email Address</label>
            </div>

            <div class="field">
              <input
                id="phone"
                name="phone"
                type="tel"
                required
                autocomplete="tel"
              />
              <label for="phone">Phone Number</label>
            </div>

            <div class="field field-password">
              <input
                id="password"
                name="password"
                type="password"
                required
                autocomplete="new-password"
              />
              <label for="password">Password</label>
            </div>

            <button class="btn-login" type="submit">Create Account</button>
          </form>

          <p class="signup">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Log In</a>
          </p>
        </div>
      </section>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/auth/register.js"></script>
  </body>
</html>
