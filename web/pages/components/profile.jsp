<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="model.User" %>
        <% User currentUser=(User) session.getAttribute("userSession"); if (currentUser==null) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp" ); return; } String
            role=currentUser.getRole() !=null ? currentUser.getRole().toLowerCase() : "tenant" ; String backUrl="owner"
            .equals(role) ? request.getContextPath() + "/pages/owner/dashboard_owner.jsp" : request.getContextPath()
            + "/landing" ; String backLabel="owner" .equals(role) ? "Kembali ke Dashboard Owner"
            : "Kembali ke Dashboard" ; %>
            <!DOCTYPE html>
            <html lang="id">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Edit Profil - SewaIn</title>
                <link rel="preconnect" href="https://fonts.googleapis.com" />
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
                    rel="stylesheet" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=2" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tenant/profile.css?v=2" />
                <script>window.contextPath = "${pageContext.request.contextPath}";</script>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
            </head>

            <body>

                <div class="blur-blobs">
                    <div class="blob blob-1"></div>
                    <div class="blob blob-2"></div>
                    <div class="blob blob-3"></div>
                </div>

                <main class="profile-container">
                    <div class="back-nav">
                        <a href="<%= backUrl %>" class="btn-back">
                            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5"
                                viewBox="0 0 24 24">
                                <polyline points="15 18 9 12 15 6"></polyline>
                            </svg>
                            <%= backLabel %>
                        </a>
                    </div>
                    <div class="profile-card">
                        <div class="profile-avatar-section">
                            <div class="avatar-circle">
                                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="1.5">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                    <circle cx="12" cy="7" r="4" />
                                </svg>
                            </div>
                            <div class="avatar-info">
                                <h1 class="profile-name" id="displayName">
                                    <%= currentUser.getName() %>
                                </h1>
                                <span class="profile-role-badge">
                                    <%= currentUser.getRole() %>
                                </span>
                            </div>
                        </div>

                        <hr class="profile-divider" />
                        <form id="profileForm" class="profile-form" novalidate>

                            <div class="form-group">
                                <label for="nameInput">Nama Lengkap</label>
                                <div class="input-wrapper">
                                    <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2">
                                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                        <circle cx="12" cy="7" r="4" />
                                    </svg>
                                    <input type="text" id="nameInput" name="name" class="profile-input"
                                        value="<%= currentUser.getName() != null ? currentUser.getName() : "" %>"
                                        placeholder="Masukkan nama lengkap" required />
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="emailInput">Email</label>
                                <div class="input-wrapper">
                                    <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2">
                                        <path
                                            d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
                                        <polyline points="22,6 12,13 2,6" />
                                    </svg>
                                    <input type="email" id="emailInput" class="profile-input disabled-input"
                                        value="<%= currentUser.getEmail() != null ? currentUser.getEmail() : "" %>"
                                        disabled title="Email tidak dapat diubah" />
                                </div>
                                <span class="field-note">Email tidak dapat diubah</span>
                            </div>

                            <div class="form-group">
                                <label for="phoneInput">Nomor Telepon</label>
                                <div class="input-wrapper">
                                    <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor" stroke-width="2">
                                        <path
                                            d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12 19.79 19.79 0 0 1 1.61 3.37 2 2 0 0 1 3.61 1.18h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.96a16 16 0 0 0 6.13 6.13l.96-.96a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z" />
                                    </svg>
                                    <input type="tel" id="phoneInput" name="phone" class="profile-input"
                                        value="<%= currentUser.getPhone() != null ? currentUser.getPhone() : "" %>"
                                        placeholder="Masukkan nomor telepon" />
                                </div>
                            </div>
                            <div id="alertBox" class="alert-box" style="display:none;"></div>

                            <button type="submit" class="btn-save" id="saveBtn">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z" />
                                    <polyline points="17 21 17 13 7 13 7 21" />
                                    <polyline points="7 3 7 8 15 8" />
                                </svg>
                                Simpan Perubahan
                            </button>
                        </form>

                    </div>
                </main>

                <script src="${pageContext.request.contextPath}/assets/js/tenant/profile.js"></script>
            </body>

            </html>