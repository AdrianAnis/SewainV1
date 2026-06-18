<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="model.User, model.Report" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% 
    // Ensure user session exists and role is owner or admin
    User currentUser = (User) session.getAttribute("userSession");
    if (currentUser == null || !("Owner".equalsIgnoreCase(currentUser.getRole()) || "Admin".equalsIgnoreCase(currentUser.getRole()))) { 
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp"); 
        return;
    } 
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laporan Properti - SewaIn</title>
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />

    <!-- CSS Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.6" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.6" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owner/report_owner.css" />
</head>
<body>

    <!-- ANIMATED BACKGROUND BLUR BLOBS -->
    <div class="blur-blobs">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
        <div class="blob blob-3"></div>
    </div>

    <div class="container">

        <!-- Back Navigation -->
        <div class="back-nav">
            <a href="${pageContext.request.contextPath}/pages/owner/dashboard_owner.jsp" class="btn-back">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Kembali ke Dashboard
            </a>
        </div>

        <!-- Header Title -->
        <div class="header-title">
            <h1>Laporan Properti</h1>
            <p>Daftar keluhan atau laporan dari Tenant mengenai properti Anda.</p>
        </div>

        <!-- Content -->
        <c:choose>
            <c:when test="${empty reports}">
                <!-- Empty State -->
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fa-regular fa-bell-slash"></i>
                    </div>
                    <h3>Belum Ada Laporan</h3>
                    <p>Semua properti Anda bersih dari laporan keluhan tenant.</p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Report List -->
                <div class="report-list">
                    <c:forEach var="report" items="${reports}">
                        <div class="report-card">
                            
                            <!-- Card Header -->
                            <div class="report-header">
                                <div>
                                    <h2 class="report-property-name">${report.propertyName}</h2>
                                    <div class="report-tenant">
                                        Dilaporkan oleh: <strong>${report.tenantName}</strong>
                                    </div>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${report.status == 'Resolved'}">
                                            <span class="badge badge-resolved">
                                                <i class="fa-solid fa-circle-check"></i> Resolved
                                            </span>
                                        </c:when>
                                        <c:when test="${report.status == 'Investigating'}">
                                            <span class="badge badge-investigating">
                                                <i class="fa-solid fa-magnifying-glass"></i> Investigating
                                            </span>
                                        </c:when>
                                        <c:when test="${report.status == 'Rejected'}">
                                            <span class="badge badge-rejected">
                                                <i class="fa-solid fa-circle-xmark"></i> Rejected
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-pending">
                                                <i class="fa-solid fa-clock"></i> Pending
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Card Body -->
                            <div class="report-body">
                                <div class="report-issue-type">
                                    <i class="fa-solid fa-triangle-exclamation"></i>
                                    Kategori: ${report.issueType}
                                </div>
                                <p class="report-description">${report.description}</p>
                            </div>

                            <!-- Card Footer -->
                            <div class="report-footer">
                                <i class="fa-regular fa-calendar-days"></i>
                                Tanggal Laporan: <fmt:formatDate value="${report.reportDate}" pattern="dd MMMM yyyy" />
                            </div>

                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>

</body>
</html>