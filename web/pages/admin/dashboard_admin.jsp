<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User, model.ActivityLog, java.util.List" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% 
    
    User currentUser = (User) session.getAttribute("userSession");
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) { 
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp"); 
        return;
    } 

    
    if (request.getAttribute("totalUsers") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - SewaIn</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/dashboard_admin.css?v=2.2" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/activity_log.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <script>
        window.contextPath = "${pageContext.request.contextPath}";
    </script>
</head>
<body>
    
    <div id="ajax-loader" class="loader-overlay" style="display: none;">
        <div class="loader-spinner"></div>
    </div>

    
    <div class="admin-container">
        
        
        <jsp:include page="../components/sidebar_admin.jsp" />

        
        <main class="admin-main">

            
            <section class="dashboard-content">
                
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

                    
                    <div class="pagination-container" id="pagination-controls" style="display: none;">
                        <button class="btn-pagination" id="btn-prev"><i class="fa-solid fa-chevron-left"></i> Sebelumnya</button>
                        <span class="pagination-info" id="pagination-info">Halaman 1 dari 10</span>
                        <button class="btn-pagination" id="btn-next">Selanjutnya <i class="fa-solid fa-chevron-right"></i></button>
                    </div>
                </div>
            </section>
        </main>
    </div>

    
    <script src="${pageContext.request.contextPath}/assets/js/admin/dashboard_admin.js"></script>
</body>
</html>