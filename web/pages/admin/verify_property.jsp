<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
    <%@page import="model.User, model.Property" %>
        <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
        <%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% 
    User currentUser = (User) session.getAttribute("userSession"); 
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) { 
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp" ); 
        return; 
    } 
    if (request.getAttribute("pendingProperties") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/verify" ); 
        return; 
    } 
%>
                <!DOCTYPE html>
                <html lang="id">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Verifikasi Properti - SewaIn Admin</title>
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
                        href="${pageContext.request.contextPath}/assets/css/admin/verify_property.css?v=3.3" />
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

                    <script>
                        window.contextPath = "${pageContext.request.contextPath}";
                    </script>
                </head>

                <body>
                    
                    <div id="ajax-loader" class="loader-overlay" style="display: none;">
                        <div class="loader-spinner"></div>
                    </div>

                    <!-- MAIN CONTAINER -->
                    <div class="admin-container">

                        
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

                        
                        <main class="admin-main">
                            <section class="cards-section" style="margin-top: 20px;">
                                <div class="section-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; padding-bottom: 16px; border-bottom: 1px solid var(--border);">
                                    <div style="display: flex; align-items: center; gap: 12px;">
                                        <h2 style="font-size: 20px; font-weight: 700; color: var(--text); margin: 0;">Properti Menunggu Persetujuan</h2>
                                        <span id="pending-count" style="background: #fef08a; color: #854d0e; font-size: 13px; font-weight: 700; padding: 4px 12px; border-radius: 999px;">${not empty pendingProperties ? pendingProperties.size() : 0} Pengajuan</span>
                                    </div>
                                    <p style="color: var(--text-secondary); font-size: 14px; margin: 0;">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: -2px; margin-right: 4px;">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <line x1="12" y1="16" x2="12" y2="12"></line>
                                            <line x1="12" y1="8" x2="12.01" y2="8"></line>
                                        </svg>
                                        Tinjau dengan saksama sebelum menyetujui
                                    </p>
                                </div>

                                <div class="properties-grid" id="properties-container">
                                    <c:forEach var="p" items="${pendingProperties}">
                                        <div class="prop-card">
                                            
                                            <div class="prop-thumb">
                                                <c:set var="photosParts" value="${fn:split(p.photos, ',')}" />
                                                <c:set var="photoUrl" value="${fn:trim(photosParts[0])}" />
                                                <img src="${photoUrl}" alt="${p.name}" 
                                                     style="width:180px;height:140px;object-fit:cover;
                                                            border-radius:10px;flex-shrink:0;"
                                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                                <div class="prop-thumb-fallback" style="display:none; width:180px; height:140px; justify-content:center; align-items:center; background:#f3f4f6; border-radius:10px; color:#9ca3af; font-size:2rem; flex-shrink:0;">
                                                    <i class="fa-solid fa-image"></i>
                                                </div>
                                                <span class="prop-type-badge">${p.propertyType}</span>
                                            </div>

                                            
                                            <div class="prop-info">
                                                <h3 class="prop-name">${p.name}</h3>
                                                <p class="prop-location">
                                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none"
                                                         stroke="currentColor" stroke-width="2"
                                                         stroke-linecap="round" stroke-linejoin="round" style="margin-right: 4px; vertical-align: -1px;">
                                                      <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
                                                      <circle cx="12" cy="10" r="3"/>
                                                    </svg>
                                                    ${p.location}
                                                </p>
                                                <p class="prop-price">Rp <fmt:formatNumber value="${p.price}" pattern="#,###" /> / bln</p>
                                                <p class="prop-desc">${p.description}</p>
                                                <div class="prop-owner">
                                                    <span class="owner-avatar">
                                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                                             stroke="currentColor" stroke-width="2"
                                                             stroke-linecap="round" stroke-linejoin="round" style="vertical-align: middle;">
                                                          <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                                          <circle cx="12" cy="7" r="4"/>
                                                        </svg>
                                                    </span>
                                                    <span>Owner: ${p.ownerName}</span>
                                                </div>
                                            </div>

                                            
                                            <div class="prop-actions">
                                                <form method="POST" action="${pageContext.request.contextPath}/admin/verify">
                                                    <input type="hidden" name="propertyId" value="${p.propertyId}" />
                                                    <input type="hidden" name="action" value="approve" />
                                                    <button type="submit" class="btn-approve">
                                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                                             stroke="currentColor" stroke-width="2.5"
                                                             stroke-linecap="round" stroke-linejoin="round" style="margin-right: 4px; vertical-align: -2px;">
                                                          <polyline points="20 6 9 17 4 12"/>
                                                        </svg>
                                                        Setujui
                                                    </button>
                                                </form>
                                                <form method="POST" action="${pageContext.request.contextPath}/admin/verify">
                                                    <input type="hidden" name="propertyId" value="${p.propertyId}" />
                                                    <input type="hidden" name="action" value="reject" />
                                                    <button type="submit" class="btn-reject">
                                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                                             stroke="currentColor" stroke-width="2.5"
                                                             stroke-linecap="round" stroke-linejoin="round" style="margin-right: 4px; vertical-align: -2px;">
                                                          <line x1="18" y1="6" x2="6" y2="18"/>
                                                          <line x1="6" y1="6" x2="18" y2="18"/>
                                                        </svg>
                                                        Tolak
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <c:if test="${empty pendingProperties}">
                                        <div class="no-pending-state">
                                            <i class="fa-solid fa-shield-check success-icon" style="font-size: 4.5rem; margin-bottom: 12px; background: -webkit-linear-gradient(135deg, #0f766e, #10b981); -webkit-background-clip: text; -webkit-text-fill-color: transparent;"></i>
                                            <h3 style="font-size: 1.75rem; font-weight: 800; color: #0f172a; margin: 0;">Antrean Bersih!</h3>
                                            <p style="color: #64748b; font-size: 1.05rem; margin-top: 8px;">Semua pengajuan properti telah selesai ditinjau.</p>
                                        </div>
                                    </c:if>
                                </div>
                            </section>
                        </main>
                    </div>

                    
                    <div id="reject-modal" class="modal-overlay" style="display: none;">
                        <div class="modal-card">
                            <div class="modal-header header-warning">
                                <h3>Tolak Pengajuan Properti</h3>
                                <button class="modal-close" onclick="closeRejectModal()">&times;</button>
                            </div>
                            <div class="modal-body">
                                <form id="reject-form" onsubmit="executeReject(event)">
                                    <input type="hidden" id="reject-property-id">
                                    <p class="form-instruction">Harap berikan alasan penolakan properti secara rinci
                                        agar owner dapat merevisi data mereka.</p>
                                    <div class="form-group">
                                        <label for="reject-reason">Alasan Penolakan:</label>
                                        <textarea id="reject-reason" rows="4" required
                                            placeholder="Contoh: Deskripsi kurang jelas atau gambar tidak relevan..."></textarea>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button class="btn-secondary" onclick="closeRejectModal()">Batal</button>
                                <button type="submit" form="reject-form" class="btn-primary btn-danger">Ya, Tolak
                                    Pengajuan</button>
                            </div>
                        </div>
                    </div>

                    
                    <script src="${pageContext.request.contextPath}/assets/js/shared/ui-alerts.js"></script>
                    <script src="${pageContext.request.contextPath}/assets/js/property-utils.js"></script>
                    <script src="${pageContext.request.contextPath}/assets/js/admin/verify_property.js"></script>
                </body>

                </html>