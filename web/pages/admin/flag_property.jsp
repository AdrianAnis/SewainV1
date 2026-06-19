<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
    <%@page import="model.User, model.Property" %>
        <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
            <% 
                /* Ensure user session exists and role is admin */
                User currentUser=(User) session.getAttribute("userSession"); 
                if (currentUser==null || !"admin".equalsIgnoreCase(currentUser.getRole())) { 
                    response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp" ); 
                    return; 
                } 
                /* Check if request attributes from servlet exist. If not, redirect to servlet. */
                if (request.getAttribute("flaggedProperties")==null) {
                    response.sendRedirect(request.getContextPath() + "/admin/flagged" ); 
                    return; 
                } 
            %>
                <!DOCTYPE html>
                <html lang="id">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Properti Bermasalah - SewaIn Admin</title>
                    <!-- Fonts -->
                    <link rel="preconnect" href="https://fonts.googleapis.com" />
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
                    <link
                        href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
                        rel="stylesheet" />

                    <!-- CSS Stylesheets -->
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.4" />
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.4" />
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/admin/dashboard_admin.css?v=2.1" />
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/admin/flag_property.css" />
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

                    <script>
                        window.contextPath = "${pageContext.request.contextPath}";
                    </script>
                </head>

                <body>
                    <!-- AJAX Loader Spinner -->
                    <div id="ajax-loader" class="loader-overlay" style="display: none;">
                        <div class="loader-spinner"></div>
                    </div>

                    <!-- MAIN CONTAINER -->
                    <div class="admin-container">

                        <!-- SIDEBAR -->
                        <aside class="admin-sidebar-floating">
                            <div class="sidebar-header">
                                <span class="brand-title">Sewa<span class="logo-highlight">In</span></span>
                            </div>
                            <nav class="sidebar-menu">
                                <a href="${pageContext.request.contextPath}/admin/dashboard"
                                    class="menu-item ${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}">
                                    <i class="fa-solid fa-table-cells-large"></i> <span>Dashboard</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/verify"
                                    class="menu-item ${pageContext.request.requestURI.contains('verify') ? 'active' : ''}">
                                    <i class="fa-solid fa-shield-halved"></i> <span>Verification</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/users"
                                    class="menu-item ${pageContext.request.requestURI.contains('users') ? 'active' : ''}">
                                    <i class="fa-solid fa-user-gear"></i> <span>User Management</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/reports"
                                    class="menu-item ${pageContext.request.requestURI.contains('reports') || pageContext.request.requestURI.contains('flagged') ? 'active' : ''}">
                                    <i class="fa-solid fa-triangle-exclamation"></i> <span>Reports & Flagging</span>
                                </a>
                            </nav>
                            <div class="sidebar-footer">
                                <div class="user-profile-sidebar"
                                    style="display: flex; align-items: center; gap: 12px; margin-bottom: 24px; padding: 16px; background-color: var(--bg-soft); border-radius: 16px;">
                                    <div class="avatar-circle"
                                        style="width: 42px; height: 42px; background-color: #FFFFFF; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--primary-dark); font-size: 1.2rem; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">
                                        <i class="fa-solid fa-user-shield"></i>
                                    </div>
                                    <div class="user-info-text" style="display: flex; flex-direction: column;">
                                        <span style="font-weight: 700; font-size: 0.95rem; color: var(--text-main);">
                                            <%= currentUser.getName() %>
                                        </span>
                                        <span
                                            style="font-size: 0.75rem; color: var(--text-muted); font-weight: 600;">Administrator</span>
                                    </div>
                                </div>
                                <a href="${pageContext.request.contextPath}/logout" class="btn-logout-minimal"
                                    style="width: 100%; justify-content: center; background-color: #FDF3F2; color: #D9534F;">
                                    <i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span>
                                </a>
                            </div>
                        </aside>

                        <!-- MAIN CONTENT -->
                        <main class="admin-main">
                            <!-- HEADER -->
                            <header class="main-header">
                                <div class="header-title-container">
                                    <h1 class="main-title">Properti Bermasalah</h1>
                                    <ul class="breadcrumb">
                                        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
                                        <li><i class="fa-solid fa-chevron-right separator"></i></li>
                                        <li class="active">Properti Bermasalah</li>
                                    </ul>
                                </div>
                            </header>

                            <!-- FLAGGED LIST -->
                            <section class="table-card">
                                <div class="card-header">
                                    <h3 class="table-card-title">Daftar Properti Ditandai (Flagged)</h3>
                                    <span id="flag-count-badge" class="table-subtitle">${not empty flaggedProperties ?
                                        flaggedProperties.size() : 0} Properti</span>
                                </div>
                                <div class="table-responsive">
                                    <table class="admin-table">
                                        <thead>
                                            <tr>
                                                <th style="width: 25%;">Nama Properti</th>
                                                <th style="width: 15%;">Tipe</th>
                                                <th style="width: 20%;">Pemilik (Owner)</th>
                                                <th style="width: 25%;">Alasan Pemberian Flag</th>
                                                <th class="text-center" style="width: 15%;">Aksi</th>
                                            </tr>
                                        </thead>
                                        <tbody id="flagged-table-body">
                                            <c:forEach var="p" items="${flaggedProperties}">
                                                <tr class="property-row" data-id="${p.propertyId}"
                                                    data-name="${p.name}">
                                                    <td class="font-bold text-danger-hover">${p.name}</td>
                                                    <td><span class="role-badge role-tenant">${p.propertyType}</span>
                                                    </td>
                                                    <td>${p.ownerName}</td>
                                                    <td class="text-muted text-sm"
                                                        title="${p.flagReason != null ? p.flagReason : 'Tidak ada keterangan'}">
                                                        ${p.flagReason != null ? p.flagReason : 'Tidak ada keterangan'}
                                                    </td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <button class="btn-action btn-unflag"
                                                                onclick="unflagProperty(${p.propertyId})"
                                                                title="Cabut Flag">
                                                                <i class="fa-solid fa-flag-slash"></i>
                                                            </button>
                                                            <button class="btn-action btn-delete-perm"
                                                                onclick="confirmDeletePermanent(${p.propertyId})"
                                                                title="Hapus Permanen">
                                                                <i class="fa-solid fa-trash-can"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty flaggedProperties}">
                                                <tr>
                                                    <td colspan="5" class="text-center text-muted py-8">
                                                        <i class="fa-solid fa-circle-check success-icon mb-2 block"></i>
                                                        Tidak ada properti bermasalah yang sedang ditangguhkan saat ini.
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </section>
                        </main>
                    </div>

                    <!-- DELETE CONFIRMATION MODAL -->
                    <div id="delete-modal" class="modal-overlay" style="display: none;">
                        <div class="modal-card modal-confirm">
                            <div class="modal-header header-warning">
                                <h3>Hapus Properti Permanen</h3>
                                <button class="modal-close" onclick="closeDeleteModal()">&times;</button>
                            </div>
                            <div class="modal-body">
                                <p>Apakah Anda yakin ingin <strong>menghapus secara permanen</strong> properti <strong
                                        id="delete-prop-name"></strong>?</p>
                                <p class="text-danger-warning text-xs mt-2"><i
                                        class="fa-solid fa-triangle-exclamation"></i> Aksi ini tidak dapat dibatalkan
                                    dan semua data terkait properti ini (termasuk wishlist dan laporan) akan dihapus
                                    selamanya.</p>
                            </div>
                            <div class="modal-footer">
                                <button class="btn-secondary" onclick="closeDeleteModal()">Batal</button>
                                <button id="btn-delete-confirm-execute" class="btn-primary btn-danger">Ya, Hapus
                                    Selamanya</button>
                            </div>
                        </div>
                    </div>

                    <!-- JS Scripts -->
                    <script src="${pageContext.request.contextPath}/assets/js/shared/ui-alerts.js"></script>
                    <script src="${pageContext.request.contextPath}/assets/js/admin/flag_property.js"></script>
                </body>

                </html>