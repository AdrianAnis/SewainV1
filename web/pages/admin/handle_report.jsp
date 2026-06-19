<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User, model.Report" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% 
    // Ensure user session exists and role is admin 
    User currentUser = (User) session.getAttribute("userSession");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) { 
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp"); 
        return;
    } 

    // Check if request attributes from servlet exist. If not, redirect to servlet.
    if (request.getAttribute("reports") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/reports");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Laporan - SewaIn Admin</title>
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    
    <!-- CSS Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/dashboard_admin.css?v=2.1" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/handle_report.css?v=3.2" />
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
                <a href="${pageContext.request.contextPath}/admin/users" class="menu-item ${pageContext.request.requestURI.contains('users') ? 'active' : ''}">
                    <i class="fa-solid fa-user-gear"></i> <span>User Management</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/reports" class="menu-item ${pageContext.request.requestURI.contains('reports') || pageContext.request.requestURI.contains('handle_report') || pageContext.request.requestURI.contains('flagged') ? 'active' : ''}">
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


            <!-- REPORTS TABLE -->
            <section class="table-card">
                <div class="card-header">
                    <h3 class="table-card-title">Daftar Laporan Pelanggaran</h3>
                    <span id="report-count-badge" class="table-subtitle">Memuat...</span>
                </div>
                <div class="table-responsive">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th style="width: 15%;">Tanggal</th>
                                <th style="width: 20%;">Properti</th>
                                <th style="width: 15%;">Pelapor</th>
                                <th style="width: 15%;">Pelanggaran</th>
                                <th style="width: 20%;">Keterangan</th>
                                <th style="width: 15%;">Status</th>
                                <th class="text-center" style="width: 20%;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody id="report-table-body">
                            <c:forEach var="r" items="${reports}">
                                <tr class="report-row" 
                                    data-id="${r.reportId}" 
                                    data-prop-id="${r.propertyId}" 
                                    data-prop-name="${r.propertyName}"
                                    data-tenant-name="${r.tenantName}"
                                    data-issue="${r.issueType}"
                                    data-desc="${r.description}"
                                    data-status="${r.status}">
                                    <td>
                                        <fmt:formatDate value="${r.reportDate}" pattern="dd MMM yyyy"/>
                                    </td>
                                    <td class="font-bold">${r.propertyName}</td>
                                    <td>${r.tenantName}</td>
                                    <td>
                                        <span class="issue-badge">${r.issueType}</span>
                                    </td>
                                    <td class="text-muted text-sm desc-cell" title="${r.description}">${r.description}</td>
                                    <td>
                                        <span class="status-badge status-${r.status.toLowerCase()}">
                                            <c:choose>
                                                <c:when test="${r.status.equalsIgnoreCase('resolved')}">
                                                    <i class="fa-solid fa-circle-check"></i> Resolved
                                                </c:when>
                                                <c:when test="${r.status.equalsIgnoreCase('investigating')}">
                                                    <i class="fa-solid fa-magnifying-glass"></i> Investigating
                                                </c:when>
                                                <c:when test="${r.status.equalsIgnoreCase('rejected')}">
                                                    <i class="fa-solid fa-circle-xmark"></i> Rejected
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fa-solid fa-clock"></i> Pending
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <c:if test="${r.status.equalsIgnoreCase('pending')}">
                                                <button class="btn-action btn-reject" onclick="resolveReport('${r.reportId}')" title="Tolak Laporan">
                                                    <i class="fa-solid fa-xmark"></i>
                                                </button>
                                                <button class="btn-action btn-flag" onclick="openFlagModal('${r.propertyId}', '${fn:escapeXml(r.propertyName)}', '${r.reportId}')" title="Flag Properti">
                                                    <i class="fa-solid fa-flag"></i> </button>
                                                    <i class="fa-solid fa-flag"></i>
                                                </button>
                                            </c:if>
                                            <c:if test="${r.status.equalsIgnoreCase('resolved')}">
                                                <span class="text-success text-xs font-bold"><i class="fa-solid fa-circle-check"></i> Selesai</span>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty reports}">
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-8">
                                        <i class="fa-regular fa-folder-open text-4xl mb-2 block"></i>
                                        Tidak ada laporan pelanggaran yang masuk.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <!-- FLAG PROPERTY MODAL -->
    <div id="flag-modal" class="modal-overlay" style="display: none;">
        <div class="modal-card">
            <div class="modal-header header-warning">
                <h3>Flag Iklan Properti</h3>
                <button class="modal-close" onclick="closeFlagModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="flag-form" onsubmit="executeFlag(event)">
                    <input type="hidden" id="flag-property-id">
                    <input type="hidden" id="flag-report-id">
                    <p class="form-instruction">Menandai properti <strong><span id="flag-prop-display-name"></span></strong> akan menangguhkan iklan ini sehingga tidak terlihat di hasil pencarian tenant. Harap masukkan alasan pemberian flag.</p>
                    <div class="form-group">
                        <label for="flag-reason">Alasan Pemberian Flag:</label>
                        <textarea id="flag-reason" rows="4" required placeholder="Contoh: Iklan palsu, gambar menipu, pemilik tidak dapat dihubungi..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeFlagModal()">Batal</button>
                <button type="submit" form="flag-form" class="btn-primary btn-danger">Tandai (Flag)</button>
            </div>
        </div>
    </div>

    <!-- JS Scripts -->
    <script src="${pageContext.request.contextPath}/assets/js/shared/ui-alerts.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin/handle_report.js?v=3.2"></script>
</body>
</html>