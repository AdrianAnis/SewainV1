<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="model.User, model.Property, model.Kost, model.Rumah, model.Kontrakan, model.Apartement" %>
        <% // Ensure user session exists and role is owner or admin User currentUser=(User)
            session.getAttribute("userSession"); if (currentUser==null ||
            !("Owner".equalsIgnoreCase(currentUser.getRole()) || "Admin" .equalsIgnoreCase(currentUser.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp" ); return; } Property
            property=(Property) request.getAttribute("property"); if (property==null) {
            response.sendRedirect(request.getContextPath() + "/pages/owner/dashboard_owner.jsp" ); return; } %>
            <!DOCTYPE html>
            <html lang="id">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Edit Properti - SewaIn</title>

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

                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owner/edit_property.css" />
            </head>

            <body>

                <!-- LOADING OVERLAY -->
                <div class="loading-overlay" id="loadingOverlay">
                    <div class="spinner"></div>
                    <div class="loading-text">Sedang menyimpan perubahan properti...</div>
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

                <!-- MAIN FORM -->
                <form id="propertyForm" action="${pageContext.request.contextPath}/owner/edit" method="POST"
                    enctype="multipart/form-data"
                    data-photos="<%= property.getPhotos() != null ? property.getPhotos() : "" %>"
                    data-facilities="<%= property.getFacilities() != null ? property.getFacilities() : "" %>"
                    style="max-width: 800px; margin: 40px auto 80px; padding: 0 24px;">
                    <input type="hidden" name="propertyId" value="<%= property.getPropertyId() %>">
                    <input type="hidden" name="existingPhotos" id="existingPhotosInput"
                        value="<%= property.getPhotos() != null ? property.getPhotos() : "" %>">

                    <div class="step-header">
                        <h1>Edit Properti</h1>
                        <p>Ubah informasi detail properti sewa Anda pada form berikut.</p>
                    </div>

                    <!-- Section 1 — Informasi Dasar -->
                    <div class="form-card">
                        <h2>Informasi Dasar</h2>

                        <div class="form-group">
                            <label class="form-label">Nama Properti</label>
                            <input type="text" name="name" class="form-control" value="<%= property.getName() %>"
                                placeholder="e.g. Exclusive Kost for Men in Tebet" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Tipe Properti (Tidak dapat diubah)</label>
                            <input type="hidden" name="type" id="propertyTypeInput"
                                value="<%= property.getPropertyType() %>">

                            <div class="type-selector" style="pointer-events: none; opacity: 0.85; margin-bottom: 0;">
                                <div class="type-btn <%= " Rumah".equalsIgnoreCase(property.getPropertyType())
                                    ? "active" : "" %>">
                                    <i class="fa-solid fa-house" style="font-size: 24px;"></i>
                                    Rumah
                                </div>
                                <div class="type-btn <%= " Apartement".equalsIgnoreCase(property.getPropertyType())
                                    || "Apartemen" .equalsIgnoreCase(property.getPropertyType()) ? "active" : "" %>">
                                    <i class="fa-solid fa-building" style="font-size: 24px;"></i>
                                    Apartement
                                </div>
                                <div class="type-btn <%= " Kost".equalsIgnoreCase(property.getPropertyType()) ? "active"
                                    : "" %>">
                                    <i class="fa-solid fa-bed" style="font-size: 24px;"></i>
                                    Kost
                                </div>
                                <div class="type-btn <%= " Kontrakan".equalsIgnoreCase(property.getPropertyType())
                                    ? "active" : "" %>">
                                    <i class="fa-solid fa-door-open" style="font-size: 24px;"></i>
                                    Kontrakan
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Lokasi / Alamat Lengkap</label>
                            <textarea name="location" class="form-control"
                                placeholder="Masukkan alamat lengkap properti"
                                required><%= property.getLocation() %></textarea>
                        </div>

                        <div class="grid-2">
                            <div class="form-group">
                                <label class="form-label">Harga Sewa per Bulan (IDR)</label>
                                <div class="input-with-icon">
                                    <span class="input-icon-left">Rp</span>
                                    <input type="number" name="price" class="form-control"
                                        value="<%= (long)property.getPrice() %>" placeholder="0" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Status Ketersediaan</label>
                                <div class="custom-select-container">
                                    <input type="hidden" name="status" value="<%= property.isAvailability() ? "
                                        Available" : "Unavailable" %>" required>
                                    <div class="custom-select-trigger has-value" onclick="toggleDropdown(this)">
                                        <span>
                                            <%= property.isAvailability() ? "Available" : "Unavailable" %>
                                        </span>
                                        <i class="fa-solid fa-chevron-down"></i>
                                    </div>
                                    <div class="custom-select-options">
                                        <div class="custom-select-option <%= property.isAvailability() ? " selected"
                                            : "" %>" onclick="selectOption(this, 'Available')">Available</div>
                                        <div class="custom-select-option <%= !property.isAvailability() ? " selected"
                                            : "" %>" onclick="selectOption(this, 'Unavailable')">Unavailable</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Section 2 — Detail Spesifik -->
                    <div class="form-card">
                        <h2>Detail Spesifik</h2>
                        <div id="specificFields">
                            <% String propType=property.getPropertyType() !=null ?
                                property.getPropertyType().trim().toLowerCase() : "" ; if ("kost".equals(propType)) {
                                String currentGender=property.getGender() !=null && !property.getGender().isEmpty() ?
                                property.getGender() : "Male" ; String currentRoomType=property.getRoomType() !=null ?
                                property.getRoomType() : "" ; %>
                                <div class="grid-2">
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <label class="form-label">Gender Type</label>
                                        <div class="segmented-control">
                                            <input type="hidden" name="gender" id="genderInput"
                                                value="<%= currentGender %>" required>
                                            <div class="segment-btn <%= " Male".equalsIgnoreCase(currentGender)
                                                ? "active" : "" %>" onclick="selectGender(this, 'Male')">Male</div>
                                            <div class="segment-btn <%= " Female".equalsIgnoreCase(currentGender)
                                                ? "active" : "" %>" onclick="selectGender(this, 'Female')">Female</div>
                                            <div class="segment-btn <%= " Mixed".equalsIgnoreCase(currentGender)
                                                ? "active" : "" %>" onclick="selectGender(this, 'Mixed')">Mixed</div>
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <label class="form-label">Room Type</label>
                                        <div class="custom-select-container">
                                            <input type="hidden" name="roomType" value="<%= currentRoomType %>"
                                                required>
                                            <div class="custom-select-trigger <%= !currentRoomType.isEmpty() ? "
                                                has-value" : "" %>" onclick="toggleDropdown(this)">
                                                <span>
                                                    <%= !currentRoomType.isEmpty() ? currentRoomType
                                                        : "Select Room Type" %>
                                                </span>
                                                <i class="fa-solid fa-chevron-down"></i>
                                            </div>
                                            <div class="custom-select-options">
                                                <div class="custom-select-option <%= " Standar
                                                    Room".equals(currentRoomType) ? "selected" : "" %>"
                                                    onclick="selectOption(this, 'Standar Room')">Standar Room</div>
                                                <div class="custom-select-option <%= " Deluxe
                                                    Room".equals(currentRoomType) ? "selected" : "" %>"
                                                    onclick="selectOption(this, 'Deluxe Room')">Deluxe Room</div>
                                                <div class="custom-select-option <%= " VIP".equals(currentRoomType)
                                                    ? "selected" : "" %>" onclick="selectOption(this, 'VIP')">VIP</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <% } else if ("rumah".equals(propType)) { %>
                                    <div class="grid-2">
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label class="form-label">Jumlah Kamar</label>
                                            <input type="number" name="jumlahKamar" class="form-control"
                                                value="<%= property.getJumlahKamar() %>" placeholder="0" required>
                                        </div>
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label class="form-label">Luas Tanah (m²)</label>
                                            <input type="number" step="0.01" name="luasTanah" class="form-control"
                                                value="<%= property.getLuasTanah() %>" placeholder="0.0" required>
                                        </div>
                                    </div>
                                    <% } else if ("kontrakan".equals(propType)) { %>
                                        <div class="grid-2">
                                            <div class="form-group" style="margin-bottom: 0;">
                                                <label class="form-label">Durasi Minimum (Bulan)</label>
                                                <input type="number" name="durasiMinimum" class="form-control"
                                                    value="<%= property.getDurasiMinimum() %>" placeholder="Misal: 12"
                                                    required>
                                            </div>
                                            <div class="form-group" style="margin-bottom: 0;">
                                                <label class="form-label">Jumlah Kamar</label>
                                                <input type="number" name="jumlahKamar" class="form-control"
                                                    value="<%= property.getJumlahKamar() %>" placeholder="0" required>
                                            </div>
                                        </div>
                                        <% } else if ("apartement".equals(propType) || "apartemen" .equals(propType)) {
                                            String currentTipeUnit=property.getTipeUnit() !=null ?
                                            property.getTipeUnit() : "" ; %>
                                            <div class="grid-3">
                                                <div class="form-group" style="margin-bottom: 0;">
                                                    <label class="form-label">Floor Number</label>
                                                    <input type="number" name="lantai" class="form-control"
                                                        value="<%= property.getLantai() %>" placeholder="0" required>
                                                </div>
                                                <div class="form-group" style="margin-bottom: 0;">
                                                    <label class="form-label">Unit Number</label>
                                                    <input type="text" name="nomorUnit" class="form-control"
                                                        value="<%= property.getNomorUnit() %>" placeholder="A-102"
                                                        required>
                                                </div>
                                                <div class="form-group" style="margin-bottom: 0;">
                                                    <label class="form-label">Unit Type</label>
                                                    <div class="custom-select-container">
                                                        <input type="hidden" name="tipeUnit"
                                                            value="<%= currentTipeUnit %>" required>
                                                        <div class="custom-select-trigger <%= !currentTipeUnit.isEmpty() ? "
                                                            has-value" : "" %>" onclick="toggleDropdown(this)">
                                                            <span>
                                                                <%= !currentTipeUnit.isEmpty() ? currentTipeUnit
                                                                    : "Select Unit Type" %>
                                                            </span>
                                                            <i class="fa-solid fa-chevron-down"></i>
                                                        </div>
                                                        <div class="custom-select-options">
                                                            <div class="custom-select-option <%= "
                                                                Studio".equals(currentTipeUnit) ? "selected" : "" %>"
                                                                onclick="selectOption(this, 'Studio')">Studio</div>
                                                            <div class="custom-select-option <%= "
                                                                1BR".equals(currentTipeUnit) ? "selected" : "" %>"
                                                                onclick="selectOption(this, '1BR')">1 Bedroom (1BR)
                                                            </div>
                                                            <div class="custom-select-option <%= "
                                                                2BR".equals(currentTipeUnit) ? "selected" : "" %>"
                                                                onclick="selectOption(this, '2BR')">2 Bedroom (2BR)
                                                            </div>
                                                            <div class="custom-select-option <%= "
                                                                Penthouse".equals(currentTipeUnit) ? "selected" : "" %>"
                                                                onclick="selectOption(this, 'Penthouse')">Penthouse
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <% } %>
                        </div>
                    </div>

                    <!-- Section 3 — Deskripsi & Fasilitas -->
                    <div class="form-card">
                        <h2>Deskripsi & Fasilitas</h2>

                        <div class="form-group">
                            <label class="form-label">Deskripsi Lengkap</label>
                            <textarea name="description" class="form-control"
                                placeholder="Describe the key features and atmosphere..."
                                required><%= property.getDescription() %></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Fasilitas Properti</label>
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
                    </div>

                    <!-- Section 4 — Foto Properti -->
                    <div class="form-card">
                        <h2>Foto Properti</h2>

                        <!-- Cover Image -->
                        <div class="form-group">
                            <label class="form-label">Cover Image <span
                                    style="font-weight: normal; color: var(--text-secondary);">(Biarkan kosong jika
                                    tidak ingin mengganti foto)</span></label>
                            <div class="dropzone" id="coverDropzone"
                                onclick="document.getElementById('coverPhotoInput').click()">
                                <div id="coverPlaceholder">
                                    <div class="dropzone-icon">
                                        <i class="fa-solid fa-cloud-arrow-up" style="font-size: 24px;"></i>
                                    </div>
                                    <div class="dropzone-title">Click to upload or drag and drop</div>
                                    <div class="dropzone-subtitle">SVG, PNG, JPG or GIF (max. 10MB)</div>
                                </div>
                                <img id="coverPreview" src="" alt="Cover Preview"
                                    style="display: none; position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover;">
                                <button type="button" id="removeCoverBtn"
                                    style="display: none; position: absolute; top: 16px; right: 16px; background: rgba(255, 255, 255, 0.9); border: none; border-radius: 50%; width: 36px; height: 36px; cursor: pointer; color: var(--deep); box-shadow: var(--shadow-sm); z-index: 10; align-items: center; justify-content: center;"
                                    onclick="removeCoverPhoto(event)">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                                <input type="file" name="cover_photo" id="coverPhotoInput" style="display:none;"
                                    accept="image/*">
                            </div>
                        </div>

                        <!-- Gallery Photos -->
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Gallery Photos <span
                                    style="font-weight: normal; color: var(--text-secondary);">(Add up to 5
                                    photos)</span></label>
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
                    </div>

                    <!-- Submit & Cancel Actions -->
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/pages/owner/dashboard_owner.jsp" class="btn-back"
                            style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">Batal</a>
                        <button type="submit" class="btn-next">Simpan Perubahan</button>
                    </div>

                </form>

                <script src="${pageContext.request.contextPath}/assets/js/owner/edit_property.js"></script>
            </body>

            </html>