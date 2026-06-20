<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="model.User, java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("userSession");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
        return;
    }
    List<Object[]> reportRows = (List<Object[]>) request.getAttribute("reportRows");
    String roleSessionVal = (String) session.getAttribute("roleSession");
    String role = roleSessionVal != null ? roleSessionVal.toLowerCase() 
        : (currentUser.getRole() != null ? currentUser.getRole().toLowerCase() : "tenant");
    String backUrl = "owner".equals(role)
            ? request.getContextPath() + "/pages/owner/dashboard_owner.jsp"
            : request.getContextPath() + "/landing";
    String backLabel = "owner".equals(role) ? "Kembali ke Dashboard Owner" : "Kembali ke Dashboard";
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riwayat Laporan - SewaIn</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=2" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tenant/report_history.css?v=2" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

    
    <div class="blur-blobs">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
        <div class="blob blob-3"></div>
    </div>

    <main class="rh-container">

        
        <div class="back-nav">
            <a href="<%= backUrl %>" class="btn-back">
                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
                <%= backLabel %>
            </a>
        </div>

        
        <div class="rh-header-card">
            <div class="rh-header-icon">
                <svg width="28" height="28" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                    <polyline points="14 2 14 8 20 8"/>
                    <line x1="16" y1="13" x2="8" y2="13"/>
                    <line x1="16" y1="17" x2="8" y2="17"/>
                    <polyline points="10 9 9 9 8 9"/>
                </svg>
            </div>
            <div>
                <h1>Riwayat Laporan</h1>
                <p>Daftar laporan properti yang telah kamu kirimkan</p>
            </div>
        </div>

        
        <div class="rh-table-card">
<%
    if (reportRows == null || reportRows.isEmpty()) {
%>
            
            <div class="rh-empty">
                <div class="rh-empty-icon">
                    <svg width="40" height="40" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" y1="8" x2="12" y2="12"/>
                        <line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                </div>
                <h3>Belum ada laporan</h3>
                <p>Kamu belum pernah mengirimkan laporan properti.</p>
            </div>
<%
    } else {
%>
            <div class="rh-table-wrapper">
                <table class="rh-table">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>Tanggal</th>
                            <th>Nama Properti</th>
                            <th>Jenis Pelanggaran</th>
                            <th>Kronologi</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
<%
    int no = 1;
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd MMM yyyy");
    for (Object[] row : reportRows) {
        
        String propName  = row[1] != null ? row[1].toString() : "-";
        String issueType = row[2] != null ? row[2].toString() : "-";
        String desc      = row[3] != null ? row[3].toString() : "-";
        String dateStr   = row[4] != null ? sdf.format(row[4]) : "-";
        String status    = row[5] != null ? row[5].toString() : "Pending";

        String badgeClass = "badge-pending";
        String statusIcon = "fa-clock";
        if ("Investigating".equalsIgnoreCase(status)) {
            badgeClass = "badge-investigating";
            statusIcon = "fa-magnifying-glass";
        } else if ("Resolved".equalsIgnoreCase(status)) {
            badgeClass = "badge-resolved";
            statusIcon = "fa-circle-check";
        } else if ("Rejected".equalsIgnoreCase(status)) {
            badgeClass = "badge-rejected";
            statusIcon = "fa-circle-xmark";
        }
%>
                        <tr class="rh-row">
                            <td class="td-no"><%= no++ %></td>
                            <td class="td-date"><%= dateStr %></td>
                            <td class="td-prop"><span class="prop-name-pill"><%= propName %></span></td>
                            <td class="td-issue"><%= issueType %></td>
                            <td class="td-desc">
                                <span class="desc-truncate" title="<%= desc %>"><%= desc %></span>
                            </td>
                            <td class="td-status">
                                <span class="status-badge <%= badgeClass %>" style="display: inline-flex; align-items: center; gap: 6px;">
                                    <i class="fa-solid <%= statusIcon %>"></i>
                                    <%= status %>
                                </span>
                            </td>
                        </tr>
<%
    }
%>
                    </tbody>
                </table>
            </div>
<%
    }
%>
        </div>
    </main>

</body>
</html>