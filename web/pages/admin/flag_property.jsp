<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
    <%@page import="model.User, model.Property" %>
        <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
            <% 
                /* Ensure user session exists and role is admin */
                User currentUser=(User) session.getAttribute("userSession"); 
                if (currentUser==null || !"admin".equalsIgnoreCase(currentUser.getRole())) { 
                    response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp" ); 
                    return; 
                } 
                /* Check if request attributes from servlet exist. If not, redirect to servlet. */
                if (request.getAttribute("flaggedProperties")==null) {
                    response.sendRedirect(request.getContextPath() + "/admin/flagged" ); 
                    return; 
                } 
            %>
                <!DOCTYPE html>
                <html lang="id">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Properti Bermasalah - SewaIn Admin</title>
                    
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
                        href="${pageContext.request.contextPath}/assets/css/admin/handle_report.css?v=3.2" />
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/admin/flag_property.css" />
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
                            
                            

                            
                            <section class="table-card">
                                <div class="card-header">
                                    <h3 class="table-card-title">Daftar Properti Ditandai (Flagged)</h3>
                                    <span id="flag-count-badge" class="table-subtitle">${not empty flaggedProperties ?
                                        flaggedProperties.size() : 0} Properti</span>
                                </div>
                                <div class="table-responsive">
                                    <table class="admin-table">
                                        <thead>
                                            <tr>
                                                <th style="width: 25%;">Nama Properti</th>
                                                <th style="width: 15%;">Tipe</th>
                                                <th style="width: 20%;">Pemilik (Owner)</th>
                                                <th style="width: 25%;">Alasan Pemberian Flag</th>
                                                <th class="text-center" style="width: 15%;">Aksi</th>
                                            </tr>
                                        </thead>
                                        <tbody id="flagged-table-body">
                                            <c:forEach var="p" items="${flaggedProperties}">
                                                <tr class="property-row" data-id="${p.propertyId}"
                                                    data-name="${p.name}">
                                                    <td class="font-bold text-danger-hover">${p.name}</td>
                                                    <td><span class="role-badge role-tenant">${p.propertyType}</span>
                                                    </td>
                                                    <td>${p.ownerName}</td>
                                                    <td class="text-muted text-sm"
                                                        title="${p.flagReason != null ? p.flagReason : 'Tidak ada keterangan'}">
                                                        ${p.flagReason != null ? p.flagReason : 'Tidak ada keterangan'}
                                                    </td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <button class="btn-action btn-unflag"
                                                                onclick="unflagProperty(${p.propertyId})"
                                                                title="Cabut Flag">
                                                                <i class="fa-solid fa-rotate-left"></i>
                                                            </button>
                                                            <button class="btn-action btn-delete-perm"
                                                                onclick="confirmDeletePermanent(${p.propertyId})"
                                                                title="Hapus Permanen">
                                                                <i class="fa-solid fa-trash-can"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty flaggedProperties}">
                                                <tr>
                                                    <td colspan="5" class="text-center text-muted py-8">
                                                        <i class="fa-solid fa-circle-check success-icon mb-2 block"></i>
                                                        Tidak ada properti bermasalah yang sedang ditangguhkan saat ini.
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </section>
                        </main>
                    </div>

                    
                    <div id="delete-modal" class="modal-overlay" style="display: none;">
                        <div class="modal-card modal-confirm">
                            <div class="modal-header header-warning">
                                <h3>Hapus Properti Permanen</h3>
                                <button class="modal-close" onclick="closeDeleteModal()">&times;</button>
                            </div>
                            <div class="modal-body">
                                <p>Apakah Anda yakin ingin <strong>menghapus secara permanen</strong> properti <strong
                                        id="delete-prop-name"></strong>?</p>
                                <p class="text-danger-warning text-xs mt-2"><i
                                        class="fa-solid fa-triangle-exclamation"></i> Aksi ini tidak dapat dibatalkan
                                    dan semua data terkait properti ini (termasuk wishlist dan laporan) akan dihapus
                                    selamanya.</p>
                            </div>
                            <div class="modal-footer">
                                <button class="btn-secondary" onclick="closeDeleteModal()">Batal</button>
                                <button id="btn-delete-confirm-execute" class="btn-primary btn-danger">Ya, Hapus
                                    Selamanya</button>
                            </div>
                        </div>
                    </div>

                    
                    <script src="${pageContext.request.contextPath}/assets/js/shared/ui-alerts.js"></script>
                    <script src="${pageContext.request.contextPath}/assets/js/admin/flag_property.js"></script>
                </body>

                </html>