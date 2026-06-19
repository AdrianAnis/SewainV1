<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User, DAO.ActivityLogDAO, model.ActivityLog, java.util.List" %>
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
    if (request.getAttribute("totalUsers") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }

    // Populate activity logs directly for dashboard overview
    ActivityLogDAO logDAO = new ActivityLogDAO();
    List<ActivityLog> activityLogs = logDAO.getLogs(null, null);
    request.setAttribute("activityLogs", activityLogs);
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - SewaIn</title>
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

            <!-- DASHBOARD SECTION (Hanya menampilkan Activity Log sesuai UML class) -->
            <section class="dashboard-content">
                <!-- LOG TABLE CARD -->
                <div class="table-card activity-log-section">
                    <div class="card-header">
                        <h3 class="table-card-title">Activity Log (monitorActivity)</h3>
                        <span id="log-count-badge" class="table-subtitle">${not empty activityLogs ? activityLogs.size() : 0} Entri Log</span>
                    </div>
                    <div class="table-responsive">
                        <table class="admin-table" id="log-table">
                            <thead>
                                <tr>
                                    <th style="width: 15%;">Log ID</th>
                                    <th style="width: 20%;">Timestamp</th>
                                    <th style="width: 20%;">User</th>
                                    <th style="width: 15%;">Action</th>
                                    <th style="width: 30%;">Description</th>
                                </tr>
                            </thead>
                            <tbody id="log-table-body">
                                <c:forEach var="log" items="${activityLogs}">
                                    <tr class="log-row">
                                        <td class="font-bold">#LOG-${log.logId}</td>
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
                                <c:if test="${empty activityLogs}">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-8">
                                            <i class="fa-regular fa-folder-open text-4xl mb-2 block"></i>
                                            Tidak ada entri log aktivitas.
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
                </div>
            </section>
        </main>
    </div>

    <!-- JS Scripts -->
    <script src="${pageContext.request.contextPath}/assets/js/admin/dashboard_admin.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin/activity_log.js"></script>
</body>
</html>