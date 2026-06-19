<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="model.User" %>
        <% 
            /* Ensure user session exists and role is owner or admin */
            User currentUser=(User) session.getAttribute("userSession"); 
            if (currentUser==null || !("Owner".equalsIgnoreCase(currentUser.getRole()) || "Admin" .equalsIgnoreCase(currentUser.getRole()))) {
                response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp" ); 
                return; 
            } 
            /* Check if form is in Edit Mode */
            boolean isEditMode=request.getAttribute("property") !=null || request.getParameter("id") !=null;
        %>
            <!DOCTYPE html>
            <html lang="id">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Add New Property - SewaIn</title>

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
                    href="${pageContext.request.contextPath}/assets/css/owner/dashboard_owner.css?v=1.6" />
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/owner/add_property.css?v=1.0" />

                <script>
                    window.contextPath = "${pageContext.request.contextPath}";
                </script>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/owner/add_property_loader.css?v=1.0" />
            </head>

            <body>

                <!-- LOADING OVERLAY -->
                <div class="loading-overlay" id="loadingOverlay">
                    <div class="spinner"></div>
                    <div class="loading-text">Sedang memproses dan mengunggah gambar...</div>
                </div>

                <!-- HEADER / BACK BUTTON -->
                <div style="max-width: 800px; margin: 40px auto 0; padding: 0 24px;">
                    <a href="${pageContext.request.contextPath}/pages/owner/dashboard_owner.jsp" class="btn-back"
                        style="display: inline-flex; align-items: center; gap: 8px; text-decoration: none;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        Kembali ke Dashboard
                    </a>
                </div>

                <!-- PROGRESS INDICATOR -->
                <div class="progress-container">
                    <div class="step-indicator active" id="ind-1">
                        <div class="step-circle">1</div>
                        <span>Basic Info</span>
                    </div>
                    <div class="step-line"></div>
                    <div class="step-indicator" id="ind-2">
                        <div class="step-circle">2</div>
                        <span>Facilities</span>
                    </div>
                    <div class="step-line"></div>
                    <div class="step-indicator" id="ind-3">
                        <div class="step-circle">3</div>
                        <span>Photos</span>
                    </div>
                </div>

                <!-- MAIN FORM -->
                <form id="propertyForm" action="${pageContext.request.contextPath}/addProperty" method="POST"
                    enctype="multipart/form-data">

                    <!-- ==============================================
             STEP 1: BASIC INFO
             ============================================== -->
                    <div id="step1" class="form-step-container step-content" style="display: block;">
                        <div class="step-header">
                            <h1>Basic Information</h1>
                            <p>Let's start with the essential details of your property.</p>
                        </div>

                        <!-- Card 1: General Info -->
                        <div class="form-card">
                            <h2>General Info</h2>
                            <div class="form-group">
                                <label class="form-label">Property Name</label>
                                <input type="text" name="name" class="form-control"
                                    placeholder="e.g. Exclusive Kost for Men in Tebet" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Property Description</label>
                                <textarea name="description" class="form-control"
                                    placeholder="Describe the key features and atmosphere..." required></textarea>
                            </div>
                            <% if (isEditMode) { %>
                                <div class="grid-2">
                                    <% } %>
                                        <div class="form-group">
                                            <label class="form-label">Rental Price (IDR)</label>
                                            <div class="input-with-icon">
                                                <span class="input-icon-left">Rp</span>
                                                <input type="number" name="price" class="form-control" placeholder="0"
                                                    required>
                                            </div>
                                        </div>
                                        <% if (isEditMode) { %>
                                            <div class="form-group">
                                                <label class="form-label">Availability Status</label>
                                                <div class="custom-select-container">
                                                    <input type="hidden" name="status" value="Available" required>
                                                    <div class="custom-select-trigger has-value"
                                                        onclick="toggleDropdown(this)">
                                                        <span>Available</span>
                                                        <i class="fa-solid fa-chevron-down"></i>
                                                    </div>
                                                    <div class="custom-select-options">
                                                        <div class="custom-select-option selected"
                                                            onclick="selectOption(this, 'Available')">Available</div>
                                                        <div class="custom-select-option"
                                                            onclick="selectOption(this, 'Unavailable')">Unavailable
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                </div>
                                <% } else { %>
                                    <input type="hidden" name="status" value="Available">
                                    <% } %>
                        </div>

                        <!-- Card 2: Property Type & Specs -->
                        <div class="form-card">
                            <h2>Property Type & Specs</h2>
                            <label class="form-label">Select Type</label>
                            <input type="hidden" name="type" id="propertyTypeInput" value="">

                            <div class="type-selector">
                                <div class="type-btn" onclick="selectType('Rumah')">
                                    <i class="fa-solid fa-house" style="font-size: 24px;"></i>
                                    Rumah
                                </div>
                                <div class="type-btn" onclick="selectType('Apartement')">
                                    <i class="fa-solid fa-building" style="font-size: 24px;"></i>
                                    Apartement
                                </div>
                                <div class="type-btn" onclick="selectType('Kost')">
                                    <i class="fa-solid fa-bed" style="font-size: 24px;"></i>
                                    Kost
                                </div>
                                <div class="type-btn" onclick="selectType('Kontrakan')">
                                    <i class="fa-solid fa-door-open" style="font-size: 24px;"></i>
                                    Kontrakan
                                </div>
                            </div>

                            <!-- Dynamic Fields Container -->
                            <div id="specificFields" style="display: none;">
                                <!-- Filled by JavaScript -->
                            </div>
                        </div>

                        <!-- Card 3: Location -->
                        <div class="form-card">
                            <h2>Location</h2>
                            <div class="form-group">
                                <label class="form-label">Full Address</label>
                                <textarea name="location" class="form-control"
                                    placeholder="Enter complete property address" required></textarea>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="form-actions end">
                            <button type="button" class="btn-next" onclick="goToStep(2)">Continue to Details
                                &rarr;</button>
                        </div>
                    </div>

                    <!-- ==============================================
             STEP 2: FACILITIES
             ============================================== -->
                    <div id="step2" class="form-step-container step-content">
                        <div class="step-header">
                            <h1>Property Details & Facilities</h1>
                            <p>Specify the amenities to make your listing stand out to potential tenants.</p>
                        </div>

                        <!-- Card 1: Core Facilities -->
                        <div class="form-card">
                            <h2>Core Facilities</h2>
                            <input type="hidden" name="facilities" id="facilitiesInput">

                            <div class="fac-grid">
                                <div class="fac-card" onclick="toggleFacility(this)" data-value="AC">
                                    <i class="fa-solid fa-snowflake"></i>
                                    <span>AC</span>
                                </div>
                                <div class="fac-card" onclick="toggleFacility(this)" data-value="Wi-Fi / Internet">
                                    <i class="fa-solid fa-wifi"></i>
                                    <span>Wi-Fi / Internet</span>
                                </div>
                                <div class="fac-card" onclick="toggleFacility(this)" data-value="Kamar Mandi Dalam">
                                    <i class="fa-solid fa-shower"></i>
                                    <span>Kamar Mandi Dalam</span>
                                </div>
                                <div class="fac-card" onclick="toggleFacility(this)" data-value="Kasur / Bed">
                                    <i class="fa-solid fa-bed"></i>
                                    <span>Kasur / Bed</span>
                                </div>
                                <div class="fac-card" onclick="toggleFacility(this)" data-value="Lemari Pakaian">
                                    <i class="fa-solid fa-door-closed"></i>
                                    <span>Lemari Pakaian</span>
                                </div>
                                <div class="fac-card" onclick="toggleFacility(this)" data-value="Dapur / Kitchen">
                                    <i class="fa-solid fa-kitchen-set"></i>
                                    <span>Dapur / Kitchen</span>
                                </div>
                                <div class="fac-card" onclick="toggleFacility(this)" data-value="Parkir Mobil / Motor">
                                    <i class="fa-solid fa-square-parking"></i>
                                    <span>Parkir Mobil / Motor</span>
                                </div>
                                <div class="fac-card" onclick="toggleFacility(this)" data-value="Mesin Cuci / Laundry">
                                    <i class="fa-solid fa-jug-detergent"></i>
                                    <span>Mesin Cuci / Laundry</span>
                                </div>
                                <div class="fac-card" onclick="toggleFacility(this)" data-value="Listrik Include">
                                    <i class="fa-solid fa-bolt"></i>
                                    <span>Listrik Include</span>
                                </div>
                                <div class="fac-card" onclick="toggleFacility(this)" data-value="Keamanan / CCTV">
                                    <i class="fa-solid fa-shield-halved"></i>
                                    <span>Keamanan / CCTV</span>
                                </div>
                            </div>

                            <div class="custom-facilities-section"
                                style="margin-top: 24px; border-top: 1px solid var(--border); padding-top: 24px;">
                                <label class="form-label">Fasilitas Tambahan (Custom)</label>
                                <div style="display: flex; gap: 12px; margin-bottom: 12px;">
                                    <input type="text" id="customFacInput" class="form-control"
                                        placeholder="Ketik fasilitas lainnya (misal: Balkon)">
                                    <button type="button" class="btn-next" style="padding: 12px 24px; flex-shrink: 0;"
                                        onclick="addCustomFacility()">+ Add</button>
                                </div>
                                <div id="customFacBadges" class="custom-badges-container">
                                    <!-- Badges appear here -->
                                </div>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="form-actions">
                            <button type="button" class="btn-back" onclick="goToStep(1)">&larr; Back</button>
                            <button type="button" class="btn-next" onclick="goToStep(3)">Continue to Photos
                                &rarr;</button>
                        </div>
                    </div>

                    <!-- ==============================================
             STEP 3: PHOTOS
             ============================================== -->
                    <div id="step3" class="form-step-container step-content">
                        <div class="step-header">
                            <h1>Property Photos</h1>
                            <p>High-quality photos increase bookings. Upload clear, bright images that showcase the best
                                features.</p>
                        </div>

                        <!-- Card 1: Cover Image -->
                        <div class="form-card">
                            <h2>Cover Image</h2>
                            <div class="dropzone" id="coverDropzone"
                                onclick="document.getElementById('coverPhotoInput').click()">
                                <div id="coverPlaceholder">
                                    <div class="dropzone-icon">
                                        <i class="fa-solid fa-cloud-arrow-up" style="font-size: 24px;"></i>
                                    </div>
                                    <div class="dropzone-title">Click to upload or drag and drop</div>
                                    <div class="dropzone-subtitle">SVG, PNG, JPG or GIF (max. 10MB, 1920x1080px
                                        recommended)</div>
                                </div>
                                <img id="coverPreview" src="" alt="Cover Preview"
                                    style="display: none; position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover;">
                                <button type="button" id="removeCoverBtn"
                                    style="display: none; position: absolute; top: 16px; right: 16px; background: rgba(255, 255, 255, 0.9); border: none; border-radius: 50%; width: 36px; height: 36px; cursor: pointer; color: var(--deep); box-shadow: var(--shadow-sm); z-index: 10; align-items: center; justify-content: center;"
                                    onclick="removeCoverPhoto(event)">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                                <!-- Assuming backend handles photos as text/url or file. For now it's file input -->
                                <input type="file" name="cover_photo" id="coverPhotoInput" style="display:none;"
                                    accept="image/*">
                            </div>
                        </div>

                        <!-- Card 2: Gallery Photos -->
                        <div class="form-card">
                            <h2>Gallery Photos</h2>
                            <p style="font-size:13px; color:var(--text-secondary); margin-bottom:16px;">Add up to 5
                                photos showcasing every room and amenity.</p>

                            <div class="gallery-grid" id="galleryGrid">
                                <div class="gallery-add" onclick="document.getElementById('galleryInput').click()">
                                    <i class="fa-regular fa-image" style="font-size: 24px;"></i>
                                    Add Photos
                                </div>
                                <div class="gallery-placeholder"><i class="fa-solid fa-image"
                                        style="font-size: 24px;"></i></div>
                                <div class="gallery-placeholder"><i class="fa-solid fa-image"
                                        style="font-size: 24px;"></i></div>
                                <div class="gallery-placeholder"><i class="fa-solid fa-image"
                                        style="font-size: 24px;"></i></div>
                            </div>
                            <input type="file" name="gallery_photos" id="galleryInput" multiple style="display:none;"
                                accept="image/*">
                        </div>

                        <!-- Actions -->
                        <div class="form-actions">
                            <button type="button" class="btn-back" onclick="goToStep(2)">&larr; Back</button>
                            <button type="submit" class="btn-next">Submit Property</button>
                        </div>
                </form>

                <!-- SCRIPTS -->
                <script src="${pageContext.request.contextPath}/assets/js/shared/ui-alerts.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/profile-dropdown.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/owner/add_property.js"></script>
            </body>

            </html>