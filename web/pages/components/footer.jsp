<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <footer class="footer">
        <div class="container">
            <div class="footer-simple" style="
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 16px;
        padding: 18px 0;
      ">
                <div>
                    <h3 class="footer-logo">SewaIn</h3>
                    <p style="
            margin: 4px 0;
            color: var(--text-secondary);
            font-size: 13px;
          ">
                        Temukan hunian impian Anda
                    </p>
                </div>
                <nav class="footer-nav" style="display: flex; gap: 18px; align-items: center">
                    <a href="${pageContext.request.contextPath}/login">Login</a>
                    <a href="${pageContext.request.contextPath}/register">Daftar</a>
                    <a href="#">Kontak</a>
                </nav>
            </div>
            <div class="footer-bottom" style="padding-top: 12px">
                <span style="color: var(--text-secondary); font-size: 13px">
                    &copy; 2026 SewaIn. All rights reserved.
                </span>
            </div>
        </div>
    </footer>