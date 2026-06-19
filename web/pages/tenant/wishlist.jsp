<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="model.User" %>
        <% 
            /* Ensure user session exists and role is tenant */
            User currentUser=(User) session.getAttribute("userSession");
            if (currentUser==null) { 
                response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp" ); 
                return;
            } 
        %>
            <!DOCTYPE html>
            <html lang="id">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Wishlist Properti - SewaIn</title>
                <!-- Fonts -->
                <link rel="preconnect" href="https://fonts.googleapis.com" />
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
                    rel="stylesheet" />

                <!-- CSS Stylesheets -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.5" />
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.5" />
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/tenant/dashboard.css?v=1.5" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tenant/wishlist.css?v=1.5" />

                <!-- Context Path Injection for External JavaScript -->
                <script>
                    window.contextPath = "${pageContext.request.contextPath}";
                    const CURRENT_USER_ID = "${not empty userSession.userId ? userSession.userId : userSession.id}";
                    const WISHLIST_KEY = `sewain_favorites_${CURRENT_USER_ID}`;
                </script>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
            </head>

            <body>

                <!-- ANIMATED BACKGROUND BLUR BLOBS -->
                <div class="blur-blobs">
                    <div class="blob blob-1"></div>
                    <div class="blob blob-2"></div>
                    <div class="blob blob-3"></div>
                </div>

                <!-- WISHLIST WORKSPACE -->
                <main class="wishlist-container" style="margin-top: 60px;">

                    <!-- Back Link -->
                    <div class="back-nav">
                        <a href="${pageContext.request.contextPath}/landing" class="btn-back">
                            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5"
                                viewBox="0 0 24 24">
                                <polyline points="15 18 9 12 15 6"></polyline>
                            </svg>
                            Kembali ke Dashboard
                        </a>
                    </div>

                    <!-- Header Panel -->
                    <div class="wishlist-header-panel" id="headerPanel">
                        <div class="wishlist-header-info">
                            <h1>Properti Impianmu</h1>
                            <p id="wishlist-subtitle" class="wishlist-subtitle">
                                Ada <span id="countHighlight">0 properti</span> yang siap kamu pinang
                            </p>
                        </div>
                    </div>

                    <!-- Property Cards Grid -->
                    <div class="property-grid" id="wishlistGrid">
                        <!-- Items rendered dynamically via wishlist.js -->
                    </div>

                    <!-- Empty State Panel -->
                    <div class="wishlist-empty-panel" id="emptyPanel">
                        <div class="empty-icon-wrapper">
                            <svg class="broken-heart" width="48" height="48" viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="1.5">
                                <!-- Broken Heart SVG -->
                                <path
                                    d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"
                                    fill="rgba(239, 68, 68, 0.1)"></path>
                                <path d="M12 5v6l-2-2 4 4-2-2v6" stroke="#ef4444" stroke-width="2"
                                    stroke-linecap="round" stroke-linejoin="round"></path>
                            </svg>
                        </div>
                        <h2>Belum ada hunian impian?</h2>
                        <p>Jelajahi berbagai pilihan properti terbaik dan simpan hunian favoritmu di sini agar tidak
                            kehilangan jejak.</p>
                        <a href="${pageContext.request.contextPath}/landing" class="btn-browse">
                            Cari Properti
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2.5">
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                <polyline points="12 5 19 12 12 19"></polyline>
                            </svg>
                        </a>
                    </div>

                </main>

                <!-- JavaScript Bundle -->
                <script src="${pageContext.request.contextPath}/assets/js/tenant/wishlist.js?v=1.6"></script>
            </body>

            </html>