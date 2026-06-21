<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% 
    User currentUser = (User) session.getAttribute("userSession");
    if (currentUser == null || !("Owner".equalsIgnoreCase(currentUser.getRole()) || "Admin".equalsIgnoreCase(currentUser.getRole()))) { 
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp"); 
        return;
    }
    if (request.getAttribute("ownerProperties") == null) {
        response.sendRedirect(request.getContextPath() + "/owner/dashboard");
        return;
    }

    int pendingReportsCount = 0;
    if (request.getAttribute("pendingReportsCount") != null) {
        pendingReportsCount = (Integer) request.getAttribute("pendingReportsCount");
    }
    pageContext.setAttribute("pendingReportsCount", pendingReportsCount);
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Owner Dashboard - SewaIn</title>
    
    
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />

    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.6" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.6" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owner/dashboard_owner.css?v=1.8" />
    
    <script>
        window.contextPath = "${pageContext.request.contextPath}";
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .report-badge-notification {
            background: #ef4444;
            color: white;
            font-size: 10px;
            font-weight: 700;
            padding: 2px 6px;
            border-radius: 999px;
            line-height: 1;
            margin-left: auto;
        }
    </style>
</head>
<body>

    
    <div class="blur-blobs">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
        <div class="blob blob-3"></div>
    </div>

    <jsp:include page="../components/navbar.jsp" />

    
    <main class="dashboard-container">
        
        
        <div class="owner-header">
            <div class="greeting-box">
                <h1>Hello, <%= currentUser.getName().split(" ")[0] %>!</h1>
                <p>Here is what's happening with your properties today.</p>
            </div>
            <div class="add-btn-box">
                <a href="${pageContext.request.contextPath}/pages/owner/add_property.jsp" class="btn-add-property">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="16"></line>
                        <line x1="8" y1="12" x2="16" y2="12"></line>
                    </svg>
                    Add New Property
                </a>
            </div>
        </div>

        
        <div class="property-grid">
            <c:choose>
                <c:when test="${empty ownerProperties}">
                    <div style="grid-column: 1/-1; text-align: center; padding: 40px; background: white; border-radius: 16px; border: 1px solid var(--border);">
                        <i class="fa-solid fa-house-chimney-crack" style="font-size: 48px; color: var(--text-secondary); margin-bottom: 16px;"></i>
                        <h3>Belum Ada Properti</h3>
                        <p style="color: var(--text-secondary);">Anda belum mendaftarkan properti apa pun. Klik tombol "Add New Property" untuk memulai.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="prop" items="${ownerProperties}">
                        <div class="property-card">
                            <div class="property-img-wrapper">
                                <c:choose>
                                    <c:when test="${prop.verificationStatus == 'Approved'}">
                                        <c:choose>
                                            <c:when test="${prop.displayBadge == 'VERIFIED'}">
                                                <div class="badge-verification badge-approved" style="background: rgba(16, 185, 129, 0.9); color: white; border: none;">
                                                    <i class="fa-solid fa-circle-check"></i> VERIFIED
                                                </div>
                                            </c:when>
                                            <c:when test="${prop.displayBadge == 'Dalam Peninjauan'}">
                                                <div class="badge-verification" style="background: rgba(234, 179, 8, 0.95); color: white; border: none;">
                                                    <i class="fa-regular fa-clock"></i> Dalam Peninjauan
                                                </div>
                                            </c:when>
                                            <c:when test="${prop.displayBadge == 'Tidak Disarankan'}">
                                                <div class="badge-verification" style="background: rgba(249, 115, 22, 0.95); color: white; border: none;">
                                                    <i class="fa-solid fa-triangle-exclamation"></i> Tidak Disarankan
                                                </div>
                                            </c:when>
                                        </c:choose>
                                    </c:when>
                                    <c:when test="${prop.verificationStatus == 'Rejected'}">
                                        <div class="badge-verification badge-rejected">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg> Rejected
                                        </div>
                                        <c:if test="${not empty prop.rejectionReason}">
                                            <div style="position: absolute; top: 44px; left: 12px; z-index: 10; background: rgba(254, 242, 242, 0.95); border: 1px solid #fecaca; color: #ef4444; padding: 6px 8px; border-radius: 6px; font-size: 11px; font-weight: 500; max-width: calc(100% - 24px); word-wrap: break-word; line-height: 1.3; backdrop-filter: blur(4px);">
                                                ${prop.rejectionReason}
                                            </div>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="badge-verification badge-pending">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg> Pending Verification
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${prop.flagCount == 1}">
                                  <span class="badge-flag badge-flag-1" style="position:absolute; top:12px; right:12px; z-index:10;">⚠ 1/3</span>
                                  <div style="position: absolute; top: 44px; left: 12px; right: 12px; z-index: 10; background: rgba(254, 252, 232, 0.95); border: 1px solid #fef08a; color: #a16207; padding: 6px 8px; border-radius: 6px; font-size: 11px; font-weight: 500; word-wrap: break-word; line-height: 1.3; backdrop-filter: blur(4px);">
                                      <div><i class="fa-solid fa-triangle-exclamation"></i> Peringatan 1/3</div>
                                      <div style="margin-top: 2px; font-weight: 400;">${prop.flagReason}</div>
                                  </div>
                                </c:if>
                                <c:if test="${prop.flagCount == 2}">
                                  <span class="badge-flag badge-flag-2" style="position:absolute; top:12px; right:12px; z-index:10;">⚠ 2/3</span>
                                  <div style="position: absolute; top: 44px; left: 12px; right: 12px; z-index: 10; background: rgba(254, 252, 232, 0.95); border: 1px solid #fef08a; color: #a16207; padding: 6px 8px; border-radius: 6px; font-size: 11px; font-weight: 500; word-wrap: break-word; line-height: 1.3; backdrop-filter: blur(4px);">
                                      <div><i class="fa-solid fa-triangle-exclamation"></i> Peringatan 2/3</div>
                                      <div style="margin-top: 2px; font-weight: 400;">${prop.flagReason}</div>
                                  </div>
                                </c:if>
                                <c:if test="${prop.flagCount >= 3}">
                                  <span class="badge-flag badge-flag-banned" style="position:absolute; top:12px; right:12px; z-index:10;">🔴 DIBLOKIR</span>
                                  <div style="position: absolute; top: 44px; left: 12px; right: 12px; z-index: 10; background: rgba(254, 242, 242, 0.95); border: 1px solid #fecaca; color: #ef4444; padding: 6px 8px; border-radius: 6px; font-size: 11px; font-weight: 500; word-wrap: break-word; line-height: 1.3; backdrop-filter: blur(4px);">
                                      <div><i class="fa-solid fa-circle-xmark"></i> Properti Diblokir Permanen</div>
                                      <div style="margin-top: 2px; font-weight: 400;">${prop.flagReason}</div>
                                  </div>
                                </c:if>
                                
                                <c:if test="${prop.availability}">
                                    <div class="property-available">AVAILABLE NOW</div>
                                </c:if>
                                
                                <c:set var="coverPhoto" value="${pageContext.request.contextPath}/assets/images/default-property.jpg" />
                                <c:if test="${not empty prop.photos && prop.photos != 'null' && prop.photos.trim() != ''}">
                                    <c:set var="firstPhoto" value="${prop.photos.split(',')[0].trim()}" />
                                    <c:if test="${not empty firstPhoto && firstPhoto != 'null' && firstPhoto.trim() != ''}">
                                        <c:choose>
                                             <c:when test="${firstPhoto.startsWith('http')}">
                                                 <c:set var="coverPhoto" value="${firstPhoto}" />
                                             </c:when>
                                             <c:when test="${firstPhoto.startsWith('/uploads/')}">
                                                 <c:set var="coverPhoto" value="${pageContext.request.contextPath}${firstPhoto}" />
                                             </c:when>
                                             <c:when test="${firstPhoto.startsWith('/')}">
                                                 <c:set var="coverPhoto" value="${firstPhoto}" />
                                             </c:when>
                                            <c:otherwise>
                                                <c:set var="coverPhoto" value="${pageContext.request.contextPath}/uploads/${firstPhoto}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </c:if>
                                <img src="${coverPhoto}" alt="${prop.name}">
                            </div>
                            <div class="property-content">
                                <div class="property-top-row">
                                    <h3 class="property-name">${prop.name}</h3>
                                    <span class="property-price">Rp <fmt:formatNumber value="${prop.price}" type="number" groupingUsed="true" /></span>
                                </div>

                                <p class="property-location" style="display: flex; align-items: center; gap: 4px; color: var(--text-secondary); font-size: 13px; margin: 8px 0 16px 0;">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                                    ${prop.location}
                                </p>
                                <div class="property-meta" style="display: flex; gap: 16px; border-top: 1px solid var(--border); padding-top: 16px; font-size: 13.5px; font-weight: 500; color: var(--deep);">
                                    <c:choose>
                                        <c:when test="${prop.propertyType == 'Apartement' || prop.propertyType == 'Apartemen'}">
                                            <span style="display: flex; align-items: center; gap: 6px;"><i class="fa-solid fa-layer-group"></i> Lantai ${prop.lantai}</span>
                                            <span style="display: flex; align-items: center; gap: 6px;"><i class="fa-solid fa-door-closed"></i> Unit ${prop.nomorUnit}</span>
                                            <span style="display: flex; align-items: center; gap: 6px;"><i class="fa-solid fa-shapes"></i> ${prop.tipeUnit}</span>
                                        </c:when>
                                        <c:when test="${prop.propertyType == 'Kost'}">
                                            <span style="display: flex; align-items: center; gap: 6px;"><i class="fa-solid fa-venus-mars"></i> ${prop.gender}</span>
                                            <span style="display: flex; align-items: center; gap: 6px;"><i class="fa-solid fa-door-closed"></i> ${prop.roomType}</span>
                                        </c:when>
                                        <c:when test="${prop.propertyType == 'Kontrakan'}">
                                            <span style="display: flex; align-items: center; gap: 6px;"><i class="fa-solid fa-calendar-days"></i> Min. ${prop.durasiMinimum} Bln</span>
                                            <span style="display: flex; align-items: center; gap: 6px;"><i class="fa-solid fa-bed"></i> ${prop.jumlahKamar} Kamar</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="display: flex; align-items: center; gap: 6px;"><i class="fa-solid fa-bed"></i> ${prop.jumlahKamar} Kamar</span>
                                            <span style="display: flex; align-items: center; gap: 6px;"><i class="fa-solid fa-maximize"></i> ${prop.luasTanah} m²</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="property-footer-actions">
                                    <a href="${pageContext.request.contextPath}/owner/detail?propertyId=${prop.propertyId}" class="btn-view-details">View Details</a>
                                    <c:if test="${prop.flagCount < 3}">
                                        <a href="${pageContext.request.contextPath}/owner/edit?propertyId=${prop.propertyId}" class="btn-action-icon edit" title="Edit" style="display: flex; align-items: center; justify-content: center; text-decoration: none;">
                                            <i class="fa-solid fa-pen"></i>
                                        </a>
                                        <button type="button"
                                                class="btn-action-icon delete"
                                                title="Hapus"
                                                onclick="openDashboardDeleteModal('${prop.propertyId}', '${prop.name}')"
                                                style="display: flex; align-items: center; justify-content: center; border: none; cursor: pointer; background: transparent;">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        
        <div class="pagination" id="ownerPagination"></div>

    </main>

    
    <div id="dashboardDeleteModal" 
         style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.5); z-index:9999; align-items:center; justify-content:center;">
        <div style="background:white; border-radius:16px; padding:32px; max-width:420px; width:90%; box-shadow:0 20px 60px rgba(0,0,0,0.2);">
            <h3 style="margin:0 0 12px; font-size:18px; font-weight:700; color:var(--deep);">Hapus Properti?</h3>
            <p style="margin:0 0 24px; color:var(--text-secondary); font-size:14px; line-height:1.6;">
                Tindakan ini tidak bisa dibatalkan. Properti 
                <strong id="dashboardDeleteName"></strong> 
                akan dihapus permanen.
            </p>
            <div style="display:flex; gap:10px;">
                <button onclick="document.getElementById('dashboardDeleteModal').style.display='none'"
                        style="flex:1; padding:12px; border-radius:10px; border:1px solid var(--border); background:white; font-weight:600; cursor:pointer; font-size:14px;">
                    Batal
                </button>
                <form id="dashboardDeleteForm" 
                      action="${pageContext.request.contextPath}/owner/delete" 
                      method="POST" 
                      style="flex:1; margin:0;">
                    <input type="hidden" name="propertyId" id="dashboardDeletePropertyId">
                    <button type="submit" 
                            style="width:100%; padding:12px; border-radius:10px; border:none; background:#ef4444; color:white; font-weight:600; cursor:pointer; font-size:14px;">
                        Ya, Hapus
                    </button>
                </form>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/profile-dropdown.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/owner/dashboard_owner.js"></script>
</body>
</html>