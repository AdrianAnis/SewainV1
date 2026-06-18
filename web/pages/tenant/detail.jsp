<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="model.User" %>
        <%@page import="model.Property" %>
            <%@page import="DAO.PropertyDAO" %>
                <%@page import="java.util.List" %>
                    <% // Ensure user session exists and role is tenant User currentUser=(User)
                        session.getAttribute("userSession"); if (currentUser==null) {
                        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp" ); return; } %>
                        <!DOCTYPE html>
                        <html lang="id">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Detail Properti - SewaIn</title>
                            <!-- Fonts -->
                            <link rel="preconnect" href="https://fonts.googleapis.com" />
                            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
                            <link
                                href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
                                rel="stylesheet" />

                            <!-- CSS Stylesheets -->
                            <link rel="stylesheet"
                                href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.6" />
                            <link rel="stylesheet"
                                href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.6" />
                            <link rel="stylesheet"
                                href="${pageContext.request.contextPath}/assets/css/tenant/dashboard.css?v=1.6" />
                            <link rel="stylesheet"
                                href="${pageContext.request.contextPath}/assets/css/tenant/detail.css?v=1.6" />

                            <!-- Context Path Injection & Properties Data for External JavaScript -->
                            <script>
                                window.contextPath = "${pageContext.request.contextPath}";
                                const CURRENT_USER_ID = "${not empty userSession.userId ? userSession.userId : userSession.id}";
                                const WISHLIST_KEY = `sewain_favorites_${CURRENT_USER_ID}`;

                                window.properties = [
            <%
                                    List < Property > list = (List < Property >) request.getAttribute("propertiesList");
                if (list == null) {
                    String pId = request.getParameter("id");
                                    response.sendRedirect(request.getContextPath() + "/property/detail" + (pId != null ? "?id=" + pId : ""));
                                    return;
                                }
                                for (int i = 0; i < list.size(); i++) {
                                    out.print(list.get(i).toJson());
                                    if (i < list.size() - 1) {
                                        out.print(",");
                                    }
                                }
            %>
        ];
                            </script>
                            <script src="${pageContext.request.contextPath}/assets/js/property-utils.js?v=1.6"></script>
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
                        </head>

                        <body>

                            <!-- ANIMATED BACKGROUND BLUR BLOBS -->
                            <div class="blur-blobs">
                                <div class="blob blob-1"></div>
                                <div class="blob blob-2"></div>
                                <div class="blob blob-3"></div>
                            </div>
                            <!-- PROPERTY DETAIL WORKSPACE -->
                            <main class="detail-container" id="detailContainer" style="margin-top: 60px;">
                                <!-- Rendered Dynamically via detail.js -->
                            </main>

                            <!-- Modal Pelaporan Penipuan -->
                            <div id="reportModal" class="report-modal">
                                <div class="report-modal-content">
                                    <div class="report-modal-header">
                                        <h3>Laporkan Properti / Penipuan</h3>
                                        <button class="close-modal-btn" onclick="closeReportModal()">
                                            <svg width="18" height="18" fill="none" stroke="currentColor"
                                                stroke-width="2" viewBox="0 0 24 24">
                                                <path d="M6 18L18 6M6 6l12 12" />
                                            </svg>
                                        </button>
                                    </div>
                                    <div class="report-modal-body">
                                        <form id="reportForm" onsubmit="submitReportForm(event)">
                                            <input type="hidden" name="propertyId" id="reportPropertyId">
                                            <div class="form-group-modal">
                                                <label>Jenis Pelanggaran</label>
                                                <input type="hidden" name="issueType" id="issueType"
                                                    value="Harga Tidak Sesuai" required>
                                                <div class="custom-dropdown-modal" id="reportIssueDropdown">
                                                    <div class="dropdown-trigger-modal">
                                                        <span class="trigger-label-modal">Harga di web tidak sesuai saat
                                                            bertemu</span>
                                                        <svg class="chevron-icon-modal" width="16" height="16"
                                                            fill="none" stroke="currentColor" stroke-width="2"
                                                            viewBox="0 0 24 24">
                                                            <path stroke-linecap="round" stroke-linejoin="round"
                                                                d="M19 9l-7 7-7-7" />
                                                        </svg>
                                                    </div>
                                                    <div class="dropdown-menu-modal">
                                                        <div class="dropdown-option-modal selected"
                                                            data-value="Harga Tidak Sesuai">Harga di web tidak sesuai
                                                            saat bertemu</div>
                                                        <div class="dropdown-option-modal"
                                                            data-value="Gambar Tidak Sesuai">Gambar/Foto properti tidak
                                                            sesuai aslinya</div>
                                                        <div class="dropdown-option-modal"
                                                            data-value="Indikasi Penipuan/Scam">Sudah bayar tetapi tidak
                                                            ada informasi lanjut (Scam)</div>
                                                        <div class="dropdown-option-modal" data-value="Lainnya">Lainnya
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group-modal" style="margin-top: 16px;">
                                                <label for="reportDescription">Deskripsi Kronologi</label>
                                                <textarea id="reportDescription" name="description" rows="4"
                                                    placeholder="Jelaskan secara rinci tentang pelanggaran atau penipuan yang terjadi..."
                                                    required></textarea>
                                            </div>
                                            <button type="submit" class="report-submit-btn">Kirim Laporan</button>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- PHOTO GALLERY LIGHTBOX MODAL -->
                            <div id="photoLightbox" class="photo-lightbox-overlay">
                                <button class="lightbox-close-btn" id="lightboxClose" aria-label="Close Gallery">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5">
                                        <path d="M18 6L6 18M6 6l12 12"></path>
                                    </svg>
                                </button>

                                <div class="lightbox-top-bar">
                                    <div class="lightbox-prop-name" id="lightboxPropName">Property Name</div>
                                    <div class="lightbox-counter" id="lightboxCounter">Photo 1 of 5</div>
                                </div>

                                <button class="lightbox-nav-btn prev" id="lightboxPrev" aria-label="Previous Photo">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5">
                                        <polyline points="15 18 9 12 15 6"></polyline>
                                    </svg>
                                </button>

                                <div class="lightbox-slider-wrapper">
                                    <div class="lightbox-slider" id="lightboxSlider">
                                        <!-- Slides dynamically injected -->
                                    </div>
                                </div>

                                <button class="lightbox-nav-btn next" id="lightboxNext" aria-label="Next Photo">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5">
                                        <polyline points="9 18 15 12 9 6"></polyline>
                                    </svg>
                                </button>

                                <div class="lightbox-bottom-bar">
                                    <div class="lightbox-caption" id="lightboxCaption">Main Photo</div>
                                    <div class="lightbox-thumbnails" id="lightboxThumbs">
                                        <!-- Thumbnails dynamically injected -->
                                    </div>
                                </div>
                            </div>

                            <!-- JavaScript Bundle -->
                            <script src="${pageContext.request.contextPath}/assets/js/shared/ui-alerts.js"></script>
                            <script src="${pageContext.request.contextPath}/assets/js/tenant/detail.js?v=1.6"></script>
                        </body>

                        </html>