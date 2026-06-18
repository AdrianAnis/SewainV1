<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User, model.ActivityLog" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% 
    // Ensure user session exists and role is admin 
    User currentUser = (User) session.getAttribute("userSession");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) { 
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp"); 
        return;
    } 

    // Check if request attributes from servlet exist. If not, redirect to servlet.
    if (request.getAttribute("logs") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/activity");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log Aktivitas - SewaIn Admin</title>
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    
    <!-- CSS Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/dashboard_admin.css?v=2.1" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/activity_log.css" />
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
            <!-- HEADER -->
            <header class="main-header">
                <div class="header-title-container">
                    <h1 class="main-title">Log Aktivitas</h1>
                    <ul class="breadcrumb">
                        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
                        <li><i class="fa-solid fa-chevron-right separator"></i></li>
                        <li class="active">Log Aktivitas</li>
                    </ul>
                </div>
            </header>

            <!-- FILTER BAR -->
            <section class="filter-card">
                <form id="filter-form" method="GET" action="${pageContext.request.contextPath}/admin/activity" class="filter-form-layout">
                    <div class="filter-group">
                        <label for="action-filter"><i class="fa-solid fa-bolt"></i> Tipe Aksi:</label>
                        <select id="action-filter" name="actionType" onchange="this.form.submit()">
                            <option value="all" ${param.actionType == 'all' ? 'selected' : ''}>Semua Aksi</option>
                            <option value="LOGIN" ${param.actionType == 'LOGIN' ? 'selected' : ''}>LOGIN</option>
                            <option value="REGISTER" ${param.actionType == 'REGISTER' ? 'selected' : ''}>REGISTER</option>
                            <option value="ADD PROPERTY" ${param.actionType == 'ADD PROPERTY' ? 'selected' : ''}>ADD PROPERTY</option>
                            <option value="UPDATE PROPERTY" ${param.actionType == 'UPDATE PROPERTY' ? 'selected' : ''}>UPDATE PROPERTY</option>
                            <option value="DELETE PROPERTY" ${param.actionType == 'DELETE PROPERTY' ? 'selected' : ''}>DELETE PROPERTY</option>
                            <option value="VERIFY PROPERTY" ${param.actionType == 'VERIFY PROPERTY' ? 'selected' : ''}>VERIFY PROPERTY</option>
                            <option value="SUBMIT REPORT" ${param.actionType == 'SUBMIT REPORT' ? 'selected' : ''}>SUBMIT REPORT</option>
                            <option value="RESOLVE REPORT" ${param.actionType == 'RESOLVE REPORT' ? 'selected' : ''}>RESOLVE REPORT</option>
                            <option value="FLAG PROPERTY" ${param.actionType == 'FLAG PROPERTY' ? 'selected' : ''}>FLAG PROPERTY</option>
                            <option value="UNFLAG PROPERTY" ${param.actionType == 'UNFLAG PROPERTY' ? 'selected' : ''}>UNFLAG PROPERTY</option>
                            <option value="SUSPEND USER" ${param.actionType == 'SUSPEND USER' ? 'selected' : ''}>SUSPEND USER</option>
                            <option value="ACTIVATE USER" ${param.actionType == 'ACTIVATE USER' ? 'selected' : ''}>ACTIVATE USER</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label for="date-filter"><i class="fa-solid fa-calendar"></i> Tanggal:</label>
                        <input type="date" id="date-filter" name="date" value="${param.date}" onchange="this.form.submit()">
                    </div>

                    <div class="filter-buttons">
                        <a href="${pageContext.request.contextPath}/admin/activity" class="btn-clear"><i class="fa-solid fa-rotate-left"></i> Reset</a>
                    </div>
                </form>
            </section>

            <!-- LOG TABLE CARD -->
            <section class="table-card">
                <div class="card-header">
                    <h3 class="table-card-title">Histori Aktivitas Sistem</h3>
                    <span id="log-count-badge" class="table-subtitle">${not empty logs ? logs.size() : 0} Entri Log</span>
                </div>
                <div class="table-responsive">
                    <table class="admin-table" id="log-table">
                        <thead>
                            <tr>
                                <th style="width: 20%;">Timestamp</th>
                                <th style="width: 20%;">Pengguna</th>
                                <th style="width: 20%;">Aksi</th>
                                <th style="width: 40%;">Keterangan</th>
                            </tr>
                        </thead>
                        <tbody id="log-table-body">
                            <c:forEach var="log" items="${logs}">
                                <tr class="log-row">
                                    <td class="timestamp-col">
                                        <fmt:formatDate value="${log.timestamp}" pattern="dd MMM yyyy, HH:mm:ss"/>
                                    </td>
                                    <td class="font-bold">${log.userName}</td>
                                    <td>
                                        <span class="action-badge action-${log.action.toLowerCase().replace(' ', '-')}">
                                            ${log.action}
                                        </span>
                                    </td>
                                    <td class="text-muted text-sm">${log.description}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty logs}">
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-8">
                                        <i class="fa-regular fa-folder-open text-4xl mb-2 block"></i>
                                        Tidak ada entri log aktivitas yang sesuai filter.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- PAGINATION CONTROLS -->
                <div class="pagination-container" id="pagination-controls" style="display: none;">
                    <button class="btn-pagination" id="btn-prev"><i class="fa-solid fa-chevron-left"></i> Sebelumnya</button>
                    <span class="pagination-info" id="pagination-info">Halaman 1 dari 10</span>
                    <button class="btn-pagination" id="btn-next">Selanjutnya <i class="fa-solid fa-chevron-right"></i></button>
                </div>
            </section>
        </main>
    </div>

    <!-- JS Scripts -->
    <script src="${pageContext.request.contextPath}/assets/js/admin/activity_log.js"></script>
</body>
</html>
