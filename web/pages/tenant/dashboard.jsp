<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<% 
    
    User currentUser = (User) session.getAttribute("userSession");
    if (currentUser == null) { 
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp"); 
        return;
    } 
%>
            <html lang="id">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Dashboard Tenant - SewaIn</title>

                <link rel="preconnect" href="https://fonts.googleapis.com" />
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
                    rel="stylesheet" />


                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.4" />
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.4" />
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/tenant/dashboard.css?v=1.4" />


                <script>
                    window.contextPath = "${pageContext.request.contextPath}";
                    window.serverProperties = <%= request.getAttribute("propertiesJson") != null ? request.getAttribute("propertiesJson") : "null" %>;
                    const CURRENT_USER_ID = "${not empty userSession.userId ? userSession.userId : userSession.id}";
                    const CURRENT_USER_ROLE = "${userSession.role}";
                    const WISHLIST_KEY = `sewain_favorites_${CURRENT_USER_ID}`;
                </script>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
            </head>

            <body>

                <div class="blur-blobs">
                    <div class="blob blob-1"></div>
                    <div class="blob blob-2"></div>
                    <div class="blob blob-3"></div>
                </div>


                <jsp:include page="../components/navbar.jsp" />


                <main class="dashboard-container">


                    <section class="main-explorer">
                        <div class="explorer-header">
                            <div class="explorer-greeting-box">
                                <h1>Temukan Hunian Terbaik Anda</h1>
                                <p class="explorer-greeting-desc">Jelajahi dan sewa tempat tinggal impian Anda dengan
                                    keamanan dan kemudahan bertransaksi.</p>
                            </div>
                        </div>


                        <form action="${pageContext.request.contextPath}/search" method="GET" class="search-filter-bar"
                            id="searchForm">

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


                            <input type="hidden" name="price" id="hiddenPrice" value="">
                            <input type="hidden" name="type" id="hiddenType" value="">


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


                            <button type="submit" id="searchSubmitBtn" class="search-submit-btn">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                Search
                            </button>
                        </form>


                        <div class="property-grid" id="propertyGrid">

                        </div>


                        <div class="pagination">
                            <a href="#" class="page-link disabled" aria-label="Previous page">&lt;</a>
                            <a href="#" class="page-link active">1</a>
                            <a href="#" class="page-link">2</a>
                            <a href="#" class="page-link">3</a>
                            <a href="#" class="page-link" aria-label="Next page">&gt;</a>
                        </div>
                    </section>

                </main>


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


                            <div id="upgradeModalOverlay" class="modal-overlay" style="display: none;">
                                <div class="glass-modal-card">
                                    <div class="modal-icon-container">
                                        <svg width="36" height="36" viewBox="0 0 24 24" fill="none"
                                            stroke="var(--primary)" stroke-width="2">
                                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                        </svg>
                                    </div>
                                    <h2>Mulai Sebagai Owner?</h2>
                                    <p>Dengan mengaktifkan mode Owner, Anda dapat mulai mendaftarkan, mengelola, dan
                                        menyewakan properti Anda sendiri di SewaIn.</p>

                                    <form id="upgradeForm" enctype="multipart/form-data" method="POST">
                                        <div class="form-group-modal" style="margin-top: 18px; text-align: left;">
                                            <label for="upgradeReason"
                                                style="display: block; font-weight: 600; font-size: 14px; margin-bottom: 8px; color: var(--deep);">Alasan
                                                ingin menjadi Owner</label>
                                            <textarea id="upgradeReason" name="reason" rows="3"
                                                placeholder="Ceritakan alasan Anda ingin menjadi Owner di SewaIn..."
                                                style="width: 100%; box-sizing: border-box; border-radius: 12px; padding: 12px 14px; border: 1.5px solid var(--border); font-family: inherit; font-size: 14px; outline: none; resize: vertical; transition: border-color 0.2s;"
                                                onfocus="this.style.borderColor='var(--primary)'"
                                                onblur="this.style.borderColor='var(--border)'" required></textarea>
                                        </div>

                                        <div class="form-group-modal" style="margin-top: 18px; text-align: left;">
                                            <label
                                                style="display: block; font-weight: 600; font-size: 14px; margin-bottom: 8px; color: var(--deep);">Upload
                                                Foto KTP</label>

                                            <div style="position: relative; border: 2px dashed rgba(124, 154, 146, 0.4); border-radius: 12px; padding: 24px; text-align: center; background: rgba(124, 154, 146, 0.03); transition: all 0.2s ease; cursor: pointer; box-sizing: border-box; width: 100%;"
                                                id="ktpUploadWrapper"
                                                onmouseover="this.style.borderColor='var(--primary)'; this.style.background='rgba(124, 154, 146, 0.08)'"
                                                onmouseout="this.style.borderColor='rgba(124, 154, 146, 0.4)'; this.style.background='rgba(124, 154, 146, 0.03)'"
                                                onclick="if(event.target.id !== 'changeKtpBtn' && event.target.tagName !== 'I') document.getElementById('ktpPhoto').click()">

                                                <input type="file" id="ktpPhoto" name="ktp_photo" accept="image/*"
                                                    style="display: none;" required>

                                                <div id="ktpUploadContent" style="display: block;">
                                                    <svg width="36" height="36" viewBox="0 0 24 24" fill="none"
                                                        stroke="var(--primary)" stroke-width="1.5"
                                                        style="margin-bottom: 10px; display: inline-block;">
                                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                                        <polyline points="17 8 12 3 7 8"></polyline>
                                                        <line x1="12" y1="3" x2="12" y2="15"></line>
                                                    </svg>
                                                    <p
                                                        style="font-size: 14.5px; font-weight: 600; color: var(--deep); margin: 0 0 6px 0;">
                                                        Klik untuk memilih file foto</p>
                                                    <p
                                                        style="font-size: 12px; color: var(--text-secondary); margin: 0;">
                                                        Format JPG/PNG, max verifikasi</p>
                                                </div>

                                                <div id="ktpPreviewContainer"
                                                    style="display: none; align-items: center; justify-content: space-between; background: var(--white); border-radius: 8px; padding: 10px 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); border: 1px solid var(--border); box-sizing: border-box; width: 100%;">
                                                    <div
                                                        style="display: flex; align-items: center; gap: 14px; overflow: hidden;">
                                                        <img id="ktpPreview"
                                                            style="width: 54px; height: 40px; object-fit: cover; border-radius: 6px; box-shadow: 0 1px 4px rgba(0,0,0,0.1);">
                                                        <div style="text-align: left; overflow: hidden;">
                                                            <p id="ktpFileName"
                                                                style="font-size: 13.5px; font-weight: 600; color: var(--deep); margin: 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 160px;">
                                                                KTP.jpg</p>
                                                            <p
                                                                style="font-size: 11.5px; color: var(--primary); margin: 2px 0 0 0; font-weight: 600;">
                                                                <i class="fa-solid fa-check-circle"></i> Berhasil
                                                                dipilih
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <button type="button" id="changeKtpBtn"
                                                        style="background: rgba(239, 68, 68, 0.1); border: none; width: 28px; height: 28px; border-radius: 50%; cursor: pointer; color: #ef4444; display: flex; align-items: center; justify-content: center; transition: all 0.2s;"
                                                        title="Hapus Foto">
                                                        <i class="fa-solid fa-trash-can" style="font-size: 13px;"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="modal-actions" style="margin-top: 24px;">
                                            <button type="button" id="cancelUpgradeBtn"
                                                class="btn-modal-secondary">Batal</button>
                                            <button type="submit" id="confirmUpgradeBtn" class="btn-modal-primary">Ya,
                                                Ajukan Mode Owner</button>
                                        </div>
                                    </form>
                                </div>
                            </div>


                            <script
                                src="${pageContext.request.contextPath}/assets/js/shared/ui-alerts.js?v=1.6"></script>
                            <script
                                src="${pageContext.request.contextPath}/assets/js/tenant/dashboard.js?v=1.6"></script>
            </body>

            </html>