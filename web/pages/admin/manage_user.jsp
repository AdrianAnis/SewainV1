<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% 
    // Ensure user session exists and role is admin 
    User currentUser = (User) session.getAttribute("userSession");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) { 
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp"); 
        return;
    } 

    // Check if request attributes from servlet exist. If not, redirect to servlet.
    if (request.getAttribute("users") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/users");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola User - SewaIn Admin</title>
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    
    <!-- CSS Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/dashboard_admin.css?v=2.1" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/manage_user.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
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
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-item ${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}">
                    <i class="fa-solid fa-table-cells-large"></i> <span>Dashboard</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/verify" class="menu-item ${pageContext.request.requestURI.contains('verify') ? 'active' : ''}">
                    <i class="fa-solid fa-shield-halved"></i> <span>Verification</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="menu-item ${pageContext.request.requestURI.contains('users') || pageContext.request.requestURI.contains('manage_user') ? 'active' : ''}">
                    <i class="fa-solid fa-user-gear"></i> <span>User Management</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/reports" class="menu-item ${pageContext.request.requestURI.contains('reports') || pageContext.request.requestURI.contains('flagged') ? 'active' : ''}">
                    <i class="fa-solid fa-triangle-exclamation"></i> <span>Reports & Flagging</span>
                </a>
            </nav>
            <div class="sidebar-footer">
                <div class="user-profile-sidebar" style="display: flex; align-items: center; gap: 12px; margin-bottom: 24px; padding: 16px; background-color: var(--bg-soft); border-radius: 16px;">
                    <div class="avatar-circle" style="width: 42px; height: 42px; background-color: #FFFFFF; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--primary-dark); font-size: 1.2rem; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">
                        <i class="fa-solid fa-user-shield"></i>
                    </div>
                    <div class="user-info-text" style="display: flex; flex-direction: column;">
                        <span style="font-weight: 700; font-size: 0.95rem; color: var(--text-main);"><%= currentUser.getName() %></span>
                        <span style="font-size: 0.75rem; color: var(--text-muted); font-weight: 600;">Administrator</span>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout-minimal" style="width: 100%; justify-content: center; background-color: #FDF3F2; color: #D9534F;">
                    <i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span>
                </a>
            </div>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="admin-main">


            <!-- USERS TABLE CARD -->
            <section class="table-card">
                <div class="card-header">
                    <h3 class="table-card-title">Daftar Pengguna</h3>
                    <span id="user-count-badge" class="table-subtitle">Memuat data...</span>
                </div>
                <div class="table-responsive">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Nama</th>
                                <th>Email</th>
                                <th>No. Telepon</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody id="user-table-body">
                            <c:forEach var="u" items="${users}">
                                <tr class="user-row" 
                                    data-id="${u.userId}" 
                                    data-name="${u.name}" 
                                    data-email="${u.email}" 
                                    data-phone="${u.phone != null ? u.phone : '-'}" 
                                    data-role="${u.role}" 
                                    data-status="${u.status != null ? u.status : 'Active'}">
                                    <td class="font-bold">${u.name}</td>
                                    <td>${u.email}</td>
                                    <td>${u.phone != null ? u.phone : '-'}</td>
                                    <td>
                                        <span class="role-badge role-${u.role.toLowerCase()}">
                                            ${u.role}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="status-badge status-${u.status != null ? u.status.toLowerCase() : 'active'}">
                                            ${u.status != null ? u.status : 'Active'}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn-action btn-detail" onclick="showUserDetail('${u.userId}')" title="Detail Pengguna">
                                                <i class="fa-solid fa-eye"></i>
                                            </button>
                                            <c:if test="${!u.role.equalsIgnoreCase('admin')}">
                                                <c:choose>
                                                    <c:when test="${u.status.equalsIgnoreCase('suspended')}">
                                                        <button class="btn-action btn-activate" onclick="confirmToggleStatus('${u.userId}', 'Active')" title="Aktifkan Akun">
                                                            <i class="fa-solid fa-user-check"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn-action btn-suspend" onclick="confirmToggleStatus('${u.userId}', 'Suspended')" title="Tangguhkan Akun">
                                                            <i class="fa-solid fa-user-minus"></i>
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty users}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-8">
                                        <i class="fa-regular fa-folder-open text-4xl mb-2 block"></i>
                                        Tidak ada data pengguna yang ditemukan.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <!-- DETAIL USER MODAL -->
    <div id="detail-modal" class="modal-overlay" style="display: none;">
        <div class="modal-card">
            <div class="modal-header">
                <h3>Detail Profil Pengguna</h3>
                <button class="modal-close" onclick="closeDetailModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div class="detail-avatar-container">
                    <div class="detail-avatar"><i class="fa-solid fa-user"></i></div>
                    <h4 id="detail-name">Nama Lengkap</h4>
                    <span id="detail-role-badge" class="role-badge">Tenant</span>
                </div>
                <div class="detail-grid">
                    <div class="detail-item">
                        <span class="detail-label">User ID</span>
                        <span id="detail-id" class="detail-val">-</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Email</span>
                        <span id="detail-email" class="detail-val">-</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">No. Telepon</span>
                        <span id="detail-phone" class="detail-val">-</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Status Akun</span>
                        <span id="detail-status" class="status-badge">Aktif</span>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeDetailModal()">Tutup</button>
            </div>
        </div>
    </div>

    <!-- CONFIRMATION MODAL (GENERIC FOR DESTRUCTIVE ACTIONS) -->
    <div id="confirm-modal" class="modal-overlay" style="display: none;">
        <div class="modal-card modal-confirm">
            <div class="modal-header header-warning">
                <h3 id="confirm-title">Konfirmasi Aksi</h3>
                <button class="modal-close" onclick="closeConfirmModal()">&times;</button>
            </div>
            <div class="modal-body">
                <p id="confirm-message">Apakah Anda yakin ingin melakukan aksi ini?</p>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeConfirmModal()">Batal</button>
                <button id="confirm-submit-btn" class="btn-primary btn-danger">Ya, Lanjutkan</button>
            </div>
        </div>
    </div>

    <!-- JS Scripts -->
    <script src="${pageContext.request.contextPath}/assets/js/shared/ui-alerts.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin/manage_user.js"></script>
</body>
</html>
