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

                    <link rel="preconnect" href="https://fonts.googleapis.com" />
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
                    <link
                        href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
                        rel="stylesheet" />

                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.4" />
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.4" />
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/admin/dashboard_admin.css?v=2.2" />
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

                    
                    <div class="admin-container">

                        
                        <jsp:include page="../components/sidebar_admin.jsp" />

                        
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
                                            
                                            <c:set var="photosParts" value="${fn:split(p.photos, ',')}" />
                                            <c:set var="photoUrl" value="${fn:trim(photosParts[0])}" />
                                            <div class="prop-thumb" onclick="viewPropertyImage('${photoUrl}')">
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
                                                <button type="button" class="btn-approve" onclick="approveProperty(${p.propertyId})">
                                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                                         stroke="currentColor" stroke-width="2.5"
                                                         stroke-linecap="round" stroke-linejoin="round" style="margin-right: 4px; vertical-align: -2px;">
                                                      <polyline points="20 6 9 17 4 12"/>
                                                    </svg>
                                                    Setujui
                                                </button>
                                                <button type="button" class="btn-reject" onclick="openRejectModal(${p.propertyId})">
                                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                                         stroke="currentColor" stroke-width="2.5"
                                                         stroke-linecap="round" stroke-linejoin="round" style="margin-right: 4px; vertical-align: -2px;">
                                                      <line x1="18" y1="6" x2="6" y2="18"/>
                                                      <line x1="6" y1="6" x2="18" y2="18"/>
                                                    </svg>
                                                    Tolak
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <c:if test="${empty pendingProperties}">
                                        <div class="no-pending-state">
                                            <i class="fa-solid fa-shield-check success-icon"></i>
                                            <h3>Antrean Bersih!</h3>
                                            <p>Semua pengajuan properti telah selesai ditinjau.</p>
                                        </div>
                                    </c:if>
                                </div>
                            </section>
                        </main>
                    </div>

                    
                    <div id="reject-modal" class="sewain-modal-overlay" style="display: none; align-items: center; justify-content: center; opacity: 1;">
                        <div class="sewain-modal-card" style="width: 450px; max-width: 90%; transform: scale(1) translateY(0);">
                            <div class="sewain-modal-icon warning">
                                <i class="fa-solid fa-exclamation"></i>
                            </div>
                            <h3 class="sewain-modal-title">Tolak Pengajuan Properti</h3>
                            
                            <form id="reject-form" onsubmit="executeReject(event)" style="width: 100%; text-align: left; margin-bottom: 0;">
                                <input type="hidden" id="reject-property-id">
                                <p class="sewain-modal-text" style="text-align: center; margin-bottom: 16px;">
                                    Harap berikan alasan penolakan secara rinci agar owner dapat merevisi data mereka.
                                </p>
                                <div style="margin-bottom: 24px;">
                                    <textarea id="reject-reason" rows="4" required 
                                        style="width: 100%; border-radius: 12px; padding: 12px; border: 1px solid var(--border); font-family: inherit; font-size: 14px; outline: none; resize: vertical;" 
                                        placeholder="Contoh: Deskripsi kurang jelas atau gambar tidak relevan..."></textarea>
                                </div>
                            </form>

                            <div class="sewain-modal-actions">
                                <button type="button" class="sewain-btn-secondary" onclick="closeRejectModal()">Batal</button>
                                <button type="submit" form="reject-form" class="sewain-btn-primary danger">Ya, Tolak Pengajuan</button>
                            </div>
                        </div>
                    </div>

                    
                    <script src="${pageContext.request.contextPath}/assets/js/shared/ui-alerts.js"></script>
                    <script src="${pageContext.request.contextPath}/assets/js/property-utils.js"></script>
                    <script src="${pageContext.request.contextPath}/assets/js/admin/verify_property.js"></script>
                </body>

                </html>