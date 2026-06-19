<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page
        import="model.User, model.Property, model.Kost, model.Rumah, model.Kontrakan, model.Apartement, DAO.PropertyDAO"
        %>
        <% User currentUser=(User) session.getAttribute("userSession"); if (currentUser==null ||
            !("Owner".equalsIgnoreCase(currentUser.getRole()) || "Admin" .equalsIgnoreCase(currentUser.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp" ); return; } int ownerId=1; try {
            ownerId=Integer.parseInt(currentUser.getUserId()); } catch(Exception e) {} Property p=(Property)
            request.getAttribute("property"); if (p==null) { response.sendRedirect(request.getContextPath()
            + "/pages/owner/dashboard_owner.jsp" ); return; } %>
            <!DOCTYPE html>
            <html lang="id">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Detail Properti - Owner - SewaIn</title>

                <!-- Fonts -->
                <link rel="preconnect" href="https://fonts.googleapis.com" />
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
                    rel="stylesheet" />

                <!-- CSS Stylesheets -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shared/global.css?v=1.6" />
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/shared/components.css?v=1.6" />
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/owner/dashboard_owner.css?v=1.8" />
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/owner/detail_owner.css?v=1.6" />

                <!-- JavaScript Utils and Shared Logic -->
                <script src="${pageContext.request.contextPath}/assets/js/property-utils.js"></script>


                <script>
                    window.contextPath = "${pageContext.request.contextPath}";
                    window.propertyData = <%= p.toJson() %>;
                </script>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

            </head>

            <body>


                <div class="blur-blobs">
                    <div class="blob blob-1"></div>
                    <div class="blob blob-2"></div>
                    <div class="blob blob-3"></div>
                </div>



                <main class="detail-container" id="detailContainer">

                </main>

                <!-- DELETE CONFIRMATION MODAL -->
                <div id="deleteModal" class="delete-modal">
                    <div class="delete-modal-content">
                        <div class="delete-icon-container">
                            <svg width="32" height="32" fill="none" stroke="currentColor" stroke-width="2.5"
                                viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                    d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                            </svg>
                        </div>
                        <h3>Delete Property</h3>
                        <p>Are you sure you want to delete this property? This action is permanent and cannot be undone.
                        </p>

                        <form id="deleteForm" action="${pageContext.request.contextPath}/owner/delete" method="POST">
                            <input type="hidden" name="propertyId" id="deletePropertyId">
                            <div class="delete-modal-actions">
                                <button type="button" class="btn-cancel-delete"
                                    onclick="closeDeleteModal()">Cancel</button>
                                <button type="submit" class="btn-confirm-delete">Delete</button>
                            </div>
                        </form>
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

                <!-- External detail owner page logic script -->
                <script src="${pageContext.request.contextPath}/assets/js/owner/detail_owner.js?v=1.6"></script>
            </body>

            </html>