<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<%
    User adminUser = (User) session.getAttribute("userSession");
    if (adminUser == null || !"admin".equalsIgnoreCase(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
        return;
    }
%>
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
        <a href="${pageContext.request.contextPath}/admin/owner-requests" class="menu-item ${pageContext.request.requestURI.contains('owner-requests') || pageContext.request.requestURI.contains('owner_requests') ? 'active' : ''}">
            <i class="fa-solid fa-id-card"></i> <span>Permintaan Owner</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports" class="menu-item ${pageContext.request.requestURI.contains('reports') || pageContext.request.requestURI.contains('handle_report') ? 'active' : ''}">
            <i class="fa-solid fa-triangle-exclamation"></i> <span>Laporan Masuk</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/flagged" class="menu-item ${pageContext.request.requestURI.contains('flagged') || pageContext.request.requestURI.contains('flag_property') ? 'active' : ''}">
            <i class="fa-solid fa-flag"></i> <span>Properti Di-Flag</span>
        </a>
    </nav>
    <div class="sidebar-footer">
        <div class="user-profile-sidebar" style="display: flex; align-items: center; gap: 12px; margin-bottom: 24px; padding: 16px; background-color: var(--bg-soft); border-radius: 16px;">
            <div class="avatar-circle" style="width: 42px; height: 42px; background-color: #FFFFFF; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--primary-dark); font-size: 1.2rem; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">
                <i class="fa-solid fa-user-shield"></i>
            </div>
            <div class="user-info-text" style="display: flex; flex-direction: column;">
                <span style="font-weight: 700; font-size: 0.95rem; color: var(--text-main);"><%= adminUser.getName() %></span>
                <span style="font-size: 0.75rem; color: var(--text-muted); font-weight: 600;">Administrator</span>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout-minimal" style="width: 100%; justify-content: center; background-color: #FDF3F2; color: #D9534F;">
            <i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span>
        </a>
    </div>
</aside>
