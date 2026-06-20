<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User, model.OwnerRequest" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% 
    User currentUser = (User) session.getAttribute("userSession"); 
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) { 
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp" ); 
        return; 
    } 
    if (request.getAttribute("requestList") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/owner-requests" ); 
        return; 
    } 
%>
<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Permintaan Jadi Owner - SewaIn Admin</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.4" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/dashboard_admin.css?v=2.2" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/verify_property.css?v=3.3" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/owner_requests.css?v=1.0" />
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
            <section class="cards-section" style="margin-top: 20px;">
                <div class="section-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; padding-bottom: 16px; border-bottom: 1px solid var(--border);">
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <h2 style="font-size: 20px; font-weight: 700; color: var(--text); margin: 0;">Permintaan Jadi Owner</h2>
                    </div>
                    
                    <div class="filter-tabs">
                        <a href="${pageContext.request.contextPath}/admin/owner-requests?filter=pending" class="filter-tab ${filter == 'pending' || empty filter ? 'active' : ''}">Pending</a>
                        <a href="${pageContext.request.contextPath}/admin/owner-requests?filter=all" class="filter-tab ${filter == 'all' ? 'active' : ''}">Semua Riwayat</a>
                    </div>
                </div>

                <div class="properties-grid" id="requests-container">
                    <c:forEach var="req" items="${requestList}">
                        <div class="prop-card">
                            
                            <div class="prop-thumb" style="cursor: pointer;" onclick="viewKtpFull('${req.ktpPhotoUrl}')">
                                <img src="${req.ktpPhotoUrl}" alt="KTP Photo" 
                                     style="width:180px;height:140px;object-fit:cover;
                                            border-radius:10px;flex-shrink:0;"
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                <div class="prop-thumb-fallback" style="display:none; width:180px; height:140px; justify-content:center; align-items:center; background:#f3f4f6; border-radius:10px; color:#9ca3af; font-size:2rem; flex-shrink:0;">
                                    <i class="fa-solid fa-id-card"></i>
                                </div>
                                
                                <c:choose>
                                    <c:when test="${req.status == 'pending'}">
                                        <span class="badge-status status-pending">Pending</span>
                                    </c:when>
                                    <c:when test="${req.status == 'approved'}">
                                        <span class="badge-status status-approved">Approved</span>
                                    </c:when>
                                    <c:when test="${req.status == 'rejected'}">
                                        <span class="badge-status status-rejected">Rejected</span>
                                    </c:when>
                                </c:choose>
                            </div>

                            <div class="prop-info">
                                <h3 class="prop-name">${req.tenant.name}</h3>
                                <p class="prop-location">
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 4px; vertical-align: -1px;">
                                        <rect x="3" y="5" width="18" height="14" rx="2" ry="2"></rect>
                                        <polyline points="3 7 12 13 21 7"></polyline>
                                    </svg>
                                    ${req.tenant.email}
                                </p>
                                <p class="prop-desc" style="margin-top: 8px;"><strong>Alasan:</strong> ${req.reason}</p>
                                <p class="prop-location" style="margin-top: 4px;">
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 4px; vertical-align: -1px;">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                    Diajukan: <fmt:formatDate value="${req.date}" pattern="dd MMM yyyy HH:mm"/>
                                </p>
                                
                                <c:if test="${req.status == 'rejected' && not empty req.rejectReason}">
                                    <div style="margin-top: 10px; padding: 8px 12px; background: #fef2f2; border-left: 3px solid #ef4444; border-radius: 4px; font-size: 12.5px; color: #b91c1c;">
                                        <strong>Alasan Penolakan:</strong> ${req.rejectReason}
                                    </div>
                                </c:if>
                            </div>

                            <c:if test="${req.status == 'pending'}">
                                <div class="prop-actions">
                                    <button type="button" class="btn-approve" onclick="approveRequest('${req.requestId}')">
                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 4px; vertical-align: -2px;">
                                            <polyline points="20 6 9 17 4 12"/>
                                        </svg>
                                        Setujui
                                    </button>
                                    <button type="button" class="btn-reject" onclick="openRejectModal('${req.requestId}')">
                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 4px; vertical-align: -2px;">
                                            <line x1="18" y1="6" x2="6" y2="18"/>
                                            <line x1="6" y1="6" x2="18" y2="18"/>
                                        </svg>
                                        Tolak
                                    </button>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>

                    <c:if test="${empty requestList}">
                        <div class="no-pending-state">
                            <i class="fa-solid fa-file-circle-check success-icon"></i>
                            <h3>Tidak ada permintaan saat ini</h3>
                            <p>Semua permintaan menjadi Owner telah selesai ditinjau atau kosong.</p>
                        </div>
                    </c:if>
                </div>
            </section>
        </main>
    </div>

    
    <div id="reject-modal" class="modal-overlay" style="display: none; align-items: center; justify-content: center; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px); z-index: 1000;">
        <div class="glass-modal-card" style="background: var(--white); width: 400px; max-width: 90%; border-radius: 16px; padding: 24px; box-shadow: 0 20px 40px rgba(0,0,0,0.2);">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                <h3 style="margin: 0; font-size: 18px; font-weight: 700; color: var(--deep);">Alasan Penolakan</h3>
                <button type="button" onclick="closeRejectModal()" style="background: none; border: none; font-size: 20px; cursor: pointer; color: var(--text-secondary);">&times;</button>
            </div>
            <form onsubmit="executeReject(event)">
                <input type="hidden" id="reject-request-id" value="">
                <textarea id="reject-reason" rows="4" placeholder="Masukkan alasan mengapa permintaan ini ditolak..." required style="width: 100%; box-sizing: border-box; padding: 12px; border: 1px solid var(--border); border-radius: 8px; font-family: inherit; font-size: 14px; outline: none; margin-bottom: 20px;"></textarea>
                <div style="display: flex; gap: 12px; justify-content: flex-end;">
                    <button type="button" class="btn-reject" onclick="closeRejectModal()" style="border: 1px solid var(--border); color: var(--text); background: var(--white);">Batal</button>
                    <button type="submit" class="btn-reject" style="background: #ef4444; color: white; border: none;">Kirim Penolakan</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/shared/ui-alerts.js?v=1.6"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin/owner_requests.js?v=1.0"></script>
</body>

</html>
