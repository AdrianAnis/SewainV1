<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="model.User" %>
        <% 
            // Ensure user session exists and role is tenant 
            User currentUser = (User) session.getAttribute("userSession");
            if (currentUser == null) { 
                response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp"); 
                return;
            } 
        %>
            <!DOCTYPE html>
            <html lang="id">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Dashboard Tenant - SewaIn</title>
                <!-- Fonts -->
                <link rel="preconnect" href="https://fonts.googleapis.com" />
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
                    rel="stylesheet" />

                <!-- CSS Stylesheets -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.4" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.4" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tenant/dashboard.css?v=1.4" />

                <!-- Context Path Injection for External JavaScript -->
                <script>
                    window.contextPath = "${pageContext.request.contextPath}";
                    window.serverProperties = <%= request.getAttribute("propertiesJson") != null ? request.getAttribute("propertiesJson") : "null" %>;
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

                <!-- NAVBAR (Consistent with index.jsp but minimal) -->
                <jsp:include page="../components/navbar.jsp" />

                <!-- DASHBOARD CONTAINER -->
                <main class="dashboard-container">

                    <!-- MAIN CONTENT AREA -->
                    <section class="main-explorer">
                        <div class="explorer-header">
                            <div class="explorer-greeting-box">
                                <h1>Temukan Hunian Terbaik Anda</h1>
                                <p class="explorer-greeting-desc">Jelajahi dan sewa tempat tinggal impian Anda dengan
                                    keamanan dan kemudahan bertransaksi.</p>
                            </div>
                        </div>

                        <!-- HORIZONTAL SEARCH & FILTER BAR -->
                        <form action="${pageContext.request.contextPath}/search" method="GET" class="search-filter-bar"
                            id="searchForm">
                            <!-- Search Input -->
                            <div class="search-input-wrapper autocomplete-wrapper" style="position: relative;">
                                <svg class="search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <input type="text" name="search_property_name" id="mainSearchInput"
                                    placeholder="Where do you want to live?" autocomplete="off">
                                <div class="autocomplete-suggestions" id="nameSuggestions"></div>
                            </div>

                            <!-- Lokasi Autocomplete Input -->
                            <div class="search-input-wrapper autocomplete-wrapper"
                                style="flex: 1; min-width: 150px; position: relative;">
                                <svg class="search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2">
                                    <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"
                                        stroke="currentColor" fill="none" stroke-width="2" />
                                    <circle cx="12" cy="9" r="2.5" stroke="currentColor" fill="none" stroke-width="2" />
                                </svg>
                                <input type="text" name="search_location" id="searchLocationInput" placeholder="Lokasi"
                                    autocomplete="off" style="padding-left: 42px;">
                                <div class="autocomplete-suggestions" id="locationSuggestions"></div>
                            </div>

                            <!-- Hidden inputs for drop-down filter values -->
                            <input type="hidden" name="price" id="hiddenPrice" value="">
                            <input type="hidden" name="type" id="hiddenType" value="">

                            <!-- Harga Custom Dropdown -->
                            <div class="custom-dropdown" id="priceDropdown">
                                <div class="dropdown-trigger">
                                    <span class="trigger-label">Harga</span>
                                    <svg class="chevron-icon" width="12" height="12" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2.5">
                                        <polyline points="6 9 12 15 18 9"></polyline>
                                    </svg>
                                </div>
                                <div class="dropdown-menu">
                                    <div class="dropdown-option selected" data-value="">Semua Harga</div>
                                    <div class="dropdown-option" data-value="under-2">&lt; Rp 2 Juta</div>
                                    <div class="dropdown-option" data-value="2-5">Rp 2 Juta - Rp 5 Juta</div>
                                    <div class="dropdown-option" data-value="5-10">Rp 5 Juta - Rp 10 Juta</div>
                                    <div class="dropdown-option" data-value="10-20">Rp 10 Juta - Rp 20 Juta</div>
                                    <div class="dropdown-option" data-value="over-20">&gt; Rp 20 Juta</div>
                                </div>
                            </div>

                            <!-- Tipe Properti Custom Dropdown -->
                            <div class="custom-dropdown" id="typeDropdown">
                                <div class="dropdown-trigger">
                                    <span class="trigger-label">Tipe Properti</span>
                                    <svg class="chevron-icon" width="12" height="12" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2.5">
                                        <polyline points="6 9 12 15 18 9"></polyline>
                                    </svg>
                                </div>
                                <div class="dropdown-menu">
                                    <div class="dropdown-option selected" data-value="">Semua Tipe</div>
                                    <div class="dropdown-option" data-value="Kost">Kost</div>
                                    <div class="dropdown-option" data-value="Rumah">Rumah</div>
                                    <div class="dropdown-option" data-value="Kontrakan">Kontrakan</div>
                                    <div class="dropdown-option" data-value="Apartemen">Apartemen</div>
                                </div>
                            </div>

                            <!-- Search Button -->
                            <button type="submit" id="searchSubmitBtn" class="search-submit-btn">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                Search
                            </button>
                        </form>

                        <!-- PROPERTY LIST GRID (Renders cards using index.jsp structures) -->
                        <div class="property-grid" id="propertyGrid">
                            <!-- Items are dynamically rendered via javascript -->
                        </div>

                        <!-- PAGINATION -->
                        <div class="pagination">
                            <a href="#" class="page-link disabled" aria-label="Previous page">&lt;</a>
                            <a href="#" class="page-link active">1</a>
                            <a href="#" class="page-link">2</a>
                            <a href="#" class="page-link">3</a>
                            <a href="#" class="page-link" aria-label="Next page">&gt;</a>
                        </div>
                    </section>

                </main>

                <!-- TOAST ALERTS (Success/Error session messages) -->
                <% if (session.getAttribute("errorMsg") !=null) { %>
                    <div class="alert-overlay">
                        <div class="toast-alert error">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#ef4444"
                                stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                            <p>
                                <%= session.getAttribute("errorMsg") %>
                            </p>
                        </div>
                    </div>
                    <% session.removeAttribute("errorMsg"); %>
                        <% } %>

                            <!-- UPGRADE MODAL OVERLAY -->
                            <div id="upgradeModalOverlay" class="modal-overlay" style="display: none;">
                                <div class="glass-modal-card">
                                    <div class="modal-icon-container">
                                        <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2">
                                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                        </svg>
                                    </div>
                                    <h2>Mulai Langkah Anda Sebagai Owner?</h2>
                                    <p>Dengan mengaktifkan mode Owner, Anda dapat mulai mendaftarkan, mengelola, dan menyewakan properti Anda sendiri di SewaIn.</p>
                                    <div class="modal-actions">
                                        <button id="cancelUpgradeBtn" class="btn-modal-secondary">Batal</button>
                                        <button id="confirmUpgradeBtn" class="btn-modal-primary">Ya, Aktifkan Mode Owner</button>
                                    </div>
                                </div>
                            </div>

                            <!-- JavaScript Bundle -->
                            <script src="${pageContext.request.contextPath}/assets/js/shared/ui-alerts.js"></script>
                            <script src="${pageContext.request.contextPath}/assets/js/tenant/dashboard.js?v=1.5"></script>
            </body>

            </html>