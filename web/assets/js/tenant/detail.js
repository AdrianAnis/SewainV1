document.addEventListener("DOMContentLoaded", function () {
    window.openReportModal = function () {
        const modal = document.getElementById("reportModal");
        const reportPropIdInput = document.getElementById("reportPropertyId");
        if (modal && property) {
            reportPropIdInput.value = property.id;
            modal.style.display = "flex";
        }
    };

    window.closeReportModal = function () {
        const modal = document.getElementById("reportModal");
        if (modal) {
            modal.style.display = "none";
        }
    };

    window.submitReportForm = function (event) {
        event.preventDefault();
        const form = document.getElementById("reportForm");
        const formData = new URLSearchParams(new FormData(form));

        fetch(window.contextPath + "/submit-report", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: formData.toString()
        })
            .then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error("Gagal mengirim laporan.");
            })
            .then(data => {
                if (data.status === "success") {
                    SewainAlert.success(data.message);
                    closeReportModal();
                    form.reset();

                    const dropdownModal = document.getElementById("reportIssueDropdown");
                    if (dropdownModal) {
                        const label = dropdownModal.querySelector(".trigger-label-modal");
                        const options = dropdownModal.querySelectorAll(".dropdown-option-modal");
                        const hiddenInput = document.getElementById("issueType");
                        if (label && hiddenInput && options.length > 0) {
                            options.forEach(o => o.classList.remove("selected"));
                            options[0].classList.add("selected");
                            label.textContent = options[0].textContent;
                            hiddenInput.value = options[0].getAttribute("data-value");
                        }
                    }
                } else {
                    SewainAlert.error("Error: " + data.message);
                }
            })
            .catch(error => {
                console.error("Error submitting report:", error);
                SewainAlert.error("Terjadi kesalahan saat mengirim laporan penipuan.");
            });
    };


    const avatarBtn = document.getElementById("avatarBtn");
    const profileDropdown = document.getElementById("profileDropdown");

    if (avatarBtn && profileDropdown) {
        avatarBtn.addEventListener("click", function (e) {
            e.stopPropagation();
            const isVisible = profileDropdown.style.display === "flex";
            profileDropdown.style.display = isVisible ? "none" : "flex";
        });

        document.addEventListener("click", function (e) {
            if (!profileDropdown.contains(e.target) && !e.target.closest("#avatarBtn")) {
                profileDropdown.style.display = "none";
            }
        });
    }


    const properties = window.properties || [];

    const ctx = window.contextPath || "";

    const urlParams = new URLSearchParams(window.location.search);
    const propId = urlParams.get("id");
    const cleanId = (id) => id ? String(id).trim() : "";
    const targetCleanId = cleanId(propId);
    const property = properties.find(p => cleanId(p.id) === targetCleanId);

    const container = document.getElementById("detailContainer");

    if (!property) {
        container.innerHTML = `
                    <div class="fallback-container">
                        <h1>Properti Tidak Ditemukan</h1>
                        <p>Maaf, detail informasi hunian yang Anda cari tidak tersedia atau telah dihapus.</p>
                        <a href="${ctx}/landing" class="booking-btn" style="text-decoration: none;">Kembali ke Dashboard</a>
                    </div>
                `;
        return;
    }


    const facilityIcons = {
        "AC": `<i class="fa-solid fa-snowflake" style="color: var(--primary); font-size: 18px; flex-shrink: 0;"></i>`,
        "Wi-Fi / Internet": `<i class="fa-solid fa-wifi" style="color: var(--primary); font-size: 18px; flex-shrink: 0;"></i>`,
        "Kamar Mandi Dalam": `<i class="fa-solid fa-shower" style="color: var(--primary); font-size: 18px; flex-shrink: 0;"></i>`,
        "Kasur / Bed": `<i class="fa-solid fa-bed" style="color: var(--primary); font-size: 18px; flex-shrink: 0;"></i>`,
        "Lemari Pakaian": `<i class="fa-solid fa-door-closed" style="color: var(--primary); font-size: 18px; flex-shrink: 0;"></i>`,
        "Dapur / Kitchen": `<i class="fa-solid fa-kitchen-set" style="color: var(--primary); font-size: 18px; flex-shrink: 0;"></i>`,
        "Parkir Mobil / Motor": `<i class="fa-solid fa-square-parking" style="color: var(--primary); font-size: 18px; flex-shrink: 0;"></i>`,
        "Mesin Cuci / Laundry": `<i class="fa-solid fa-jug-detergent" style="color: var(--primary); font-size: 18px; flex-shrink: 0;"></i>`,
        "Listrik Include": `<i class="fa-solid fa-bolt" style="color: var(--primary); font-size: 18px; flex-shrink: 0;"></i>`,
        "Keamanan / CCTV": `<i class="fa-solid fa-shield-halved" style="color: var(--primary); font-size: 18px; flex-shrink: 0;"></i>`
    };

    const defaultIcon = `<svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
  <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
  <line x1="7" y1="7" x2="7.01" y2="7"/>
</svg>`;


    const verifiedTag = property.verified ? `
                <div class="verified-badge">
                    <svg width="14" height="14" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                    </svg>
                    Verified
                </div>` : '';

    const capitalize = (str) => {
        if (!str) return "";
        const trimmed = str.trim();
        return trimmed.charAt(0).toUpperCase() + trimmed.slice(1).toLowerCase();
    };
    const categoryBadge = `<span class="category-badge">${capitalize(property.type)}</span>`;


    let facilitiesHtml = "";
    property.facilities.forEach(function (facility) {

        let foundIcon = null;
        let facLower = facility.trim().toLowerCase();
        for (let key in facilityIcons) {
            if (key.toLowerCase() === facLower) {
                foundIcon = facilityIcons[key];
                break;
            }
        }
        let icon = foundIcon || defaultIcon;
        facilitiesHtml += '<div class="facility-item">' +
            icon +
            '<span>' + facility + '</span>' +
            '</div>';
    });

    let recsHtml = "";
    let favorites = JSON.parse(localStorage.getItem(WISHLIST_KEY)) || [];
    const otherProps = properties.filter(p => p.id !== property.id).slice(0, 3);
    if (otherProps.length === 0) {
        recsHtml = `<div class="no-recommendations" style="grid-column: 1 / -1; text-align: center; padding: 45px 20px; color: var(--text-secondary); font-size: 14px; font-weight: 500;">Tidak ada rekomendasi properti saat ini.</div>`;
    } else {
        otherProps.forEach(function (p) {
            const isFav = favorites.includes(p.id);
            const recCoverSrc = getCoverImage(p.rawPhotos || p.image);
            recsHtml += `
                    <div class="property-card" data-id="${p.id}">
                        <div class="property-img-wrapper">
                            <img src="${recCoverSrc}" alt="${p.name}">
                            
                            ${p.verified ? `
                            <span class="badge-verified">
                                <i class="fa-solid fa-circle-check"></i> VERIFIED
                            </span>` : ""}
                            
                            <button class="property-wishlist ${isFav ? 'active' : ''}" data-id="${p.id}" aria-label="Wishlist">
                                <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                                </svg>
                            </button>
                            
                            ${p.available ? `
                            <div class="property-available">AVAILABLE NOW</div>` : ""}
                        </div>
                        
                        <div class="property-content">
                            <div class="property-top-row">
                                <h3 class="property-name">${p.name}</h3>
                                <span class="property-price">${p.priceLabel}</span>
                            </div>
                            
                            <p class="property-location">
                                <svg width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                    <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/>
                                    <circle cx="12" cy="9" r="2.5" />
                                </svg>
                                ${p.location}
                            </p>
                            
                            <div class="property-meta" style="display: flex; gap: 16px; border-top: 1px solid var(--border); padding-top: 16px; font-size: 13.5px; font-weight: 500; color: var(--deep);">
                                ${(function () {
                    const pType = (p.type || "").trim().toLowerCase();
                    if (pType === "kost") {
                        return `
                                        <span style="display: flex; align-items: center; gap: 6px;">
                                            <i class="fa-solid fa-venus-mars"></i>
                                            ${p.gender || "Campur"}
                                        </span>
                                        <span style="display: flex; align-items: center; gap: 6px;">
                                            <i class="fa-solid fa-door-closed"></i>
                                            ${p.roomType || "Standard"}
                                        </span>`;
                    } else if (pType === "rumah") {
                        return `
                                        <span style="display: flex; align-items: center; gap: 6px;">
                                            <i class="fa-solid fa-bed"></i>
                                            ${p.jumlahKamar || 0} Kamar
                                        </span>
                                        <span style="display: flex; align-items: center; gap: 6px;">
                                            <i class="fa-solid fa-maximize"></i>
                                            ${p.luasTanah ? (p.luasTanah + " m²") : "0 m²"}
                                        </span>`;
                    } else if (pType === "kontrakan") {
                        return `
                                        <span style="display: flex; align-items: center; gap: 6px;">
                                            <i class="fa-solid fa-bed"></i>
                                            ${p.jumlahKamar || 0} Kamar
                                        </span>
                                        <span style="display: flex; align-items: center; gap: 6px;">
                                            <i class="fa-solid fa-calendar-days"></i>
                                            Min. ${p.durasiMinimum || 12} Bln
                                        </span>`;
                    } else {
                        return `
                                        <span style="display: flex; align-items: center; gap: 6px;">
                                            <i class="fa-solid fa-layer-group"></i>
                                            Lantai ${p.lantai || 12}
                                        </span>
                                        <span style="display: flex; align-items: center; gap: 6px;">
                                            <i class="fa-solid fa-door-closed"></i>
                                            Unit ${p.nomorUnit || "12B"}
                                        </span>
                                        <span style="display: flex; align-items: center; gap: 6px;">
                                            <i class="fa-solid fa-shapes"></i>
                                            ${p.tipeUnit || "Studio"}
                                        </span>`;
                    }
                })()}
                            </div>
                        </div>
                    </div>`;
        });
    }


    const fallbackInteriors = [
        "https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1616594039964-ae9021a400a0?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80"
    ];

    const rawImageString = property.rawPhotos ? property.rawPhotos.trim() : "";
    let photosArr = rawImageString ? rawImageString.split(',').map(s => s.trim()).filter(s => s) : [];

    if (photosArr.length === 0) {
        photosArr.push(ctx + "/assets/images/default-property.jpg");
    }

    photosArr = photosArr.map(p => resolvePropertyImage(p));

    let gridStyles = '';
    let gridHtml = '';

    if (photosArr.length === 1) {
        gridStyles = 'grid-template-columns: 1fr; grid-template-rows: 1fr;';
        gridHtml = `
                                                        <div class="photo-grid-main" style="grid-column: 1 / -1; grid-row: 1 / -1; cursor: pointer;" onclick="openLightbox(0);">
                                                            <img src="${photosArr[0]}" alt="${property.name}">
                                                        </div>
                                                    `;
    } else if (photosArr.length === 2) {
        gridStyles = 'grid-template-columns: 1fr 1fr; grid-template-rows: 1fr;';
        gridHtml = `
                                                        <div class="photo-grid-main" style="grid-row: 1 / -1; cursor: pointer;" onclick="openLightbox(0);">
                                                            <img src="${photosArr[0]}" alt="${property.name}">
                                                        </div>
                                                        <div class="photo-grid-sub" style="grid-row: 1 / -1; cursor: pointer;" onclick="openLightbox(1);">
                                                            <img src="${photosArr[1]}" alt="Interior 1">
                                                        </div>
                                                    `;
    } else if (photosArr.length === 3) {
        gridStyles = 'grid-template-columns: 2fr 1fr; grid-template-rows: 1fr 1fr;';
        gridHtml = `
                                                        <div class="photo-grid-main" style="grid-row: span 2; cursor: pointer;" onclick="openLightbox(0);">
                                                            <img src="${photosArr[0]}" alt="${property.name}">
                                                        </div>
                                                        <div class="photo-grid-sub" style="cursor: pointer;" onclick="openLightbox(1);">
                                                            <img src="${photosArr[1]}" alt="Interior 1">
                                                        </div>
                                                        <div class="photo-grid-sub" style="cursor: pointer;" onclick="openLightbox(2);">
                                                            <img src="${photosArr[2]}" alt="Interior 2">
                                                        </div>
                                                    `;
    } else if (photosArr.length === 4) {
        gridStyles = 'grid-template-columns: 2fr 1fr 1fr; grid-template-rows: 1fr 1fr;';
        gridHtml = `
                                                        <div class="photo-grid-main" style="grid-row: span 2; cursor: pointer;" onclick="openLightbox(0);">
                                                            <img src="${photosArr[0]}" alt="${property.name}">
                                                        </div>
                                                        <div class="photo-grid-sub" style="cursor: pointer;" onclick="openLightbox(1);">
                                                            <img src="${photosArr[1]}" alt="Interior 1">
                                                        </div>
                                                        <div class="photo-grid-sub" style="cursor: pointer;" onclick="openLightbox(2);">
                                                            <img src="${photosArr[2]}" alt="Interior 2">
                                                        </div>
                                                        <div class="photo-grid-sub" style="grid-column: span 2; cursor: pointer;" onclick="openLightbox(3);">
                                                            <img src="${photosArr[3]}" alt="Interior 3">
                                                        </div>
                                                    `;
    } else {

        gridStyles = 'grid-template-columns: 2.2fr 1fr 1fr; grid-template-rows: 1fr 1fr;';
        gridHtml = `
                                                        <div class="photo-grid-main" style="grid-row: span 2; cursor: pointer;" onclick="openLightbox(0);">
                                                            <img src="${photosArr[0]}" alt="${property.name}">
                                                        </div>
                                                        <div class="photo-grid-sub" style="cursor: pointer;" onclick="openLightbox(1);">
                                                            <img src="${photosArr[1]}" alt="Interior 1">
                                                        </div>
                                                        <div class="photo-grid-sub" style="cursor: pointer;" onclick="openLightbox(2);">
                                                            <img src="${photosArr[2]}" alt="Interior 2">
                                                        </div>
                                                        <div class="photo-grid-sub" style="cursor: pointer;" onclick="openLightbox(3);">
                                                            <img src="${photosArr[3]}" alt="Interior 3">
                                                        </div>
                                                        <div class="photo-grid-sub" style="cursor: pointer;" onclick="openLightbox(4);">
                                                            <img src="${photosArr[4]}" alt="Interior 4">
                                                        </div>
                                                    `;
    }

    const photoGridHtml = `
                <div class="photo-grid-container" style="${gridStyles}">
                    ${gridHtml}
                    ${photosArr.length > 5 ? `
                    <button class="show-all-btn" onclick="openLightbox(0);">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 6px;">
                            <rect x="3" y="3" width="7" height="7"></rect>
                            <rect x="14" y="3" width="7" height="7"></rect>
                            <rect x="14" y="14" width="7" height="7"></rect>
                            <rect x="3" y="14" width="7" height="7"></rect>
                        </svg>
                        Show all ${photosArr.length} photos
                    </button>
                    ` : ''}
                </div>
            `;


    const allPhotos = photosArr.map((url, idx) => {
        return { url: url, caption: idx === 0 ? "Main Photo" : "Interior " + idx };
    });


    let specsHtml = "";
    const typeLower = (property.type || "").trim().toLowerCase();
    if (typeLower === "kost") {
        specsHtml = `
                    <div class="spec-badge">
                        <i class="fa-solid fa-venus-mars"></i>
                        <span>Gender: ${property.gender}</span>
                    </div>
                    <div class="spec-badge">
                        <i class="fa-solid fa-door-closed"></i>
                        <span>Tipe Kamar: ${property.roomType}</span>
                    </div>
                `;
    } else if (typeLower === "rumah") {
        specsHtml = `
                    <div class="spec-badge">
                        <i class="fa-solid fa-bed"></i>
                        <span>${property.jumlahKamar} Kamar Tidur</span>
                    </div>
                    <div class="spec-badge">
                        <i class="fa-solid fa-maximize"></i>
                        <span>Luas Tanah: ${property.luasTanah} m²</span>
                    </div>
                `;
    } else if (typeLower === "kontrakan") {
        specsHtml = `
                    <div class="spec-badge">
                        <i class="fa-solid fa-bed"></i>
                        <span>${property.jumlahKamar} Kamar Tidur</span>
                    </div>
                    <div class="spec-badge">
                        <i class="fa-solid fa-calendar-days"></i>
                        <span>Min. Sewa: ${property.durasiMinimum} Bulan</span>
                    </div>
                `;
    } else {
        specsHtml = `
                    <div class="spec-badge">
                        <i class="fa-solid fa-layer-group"></i>
                        <span>Lantai: ${property.lantai}</span>
                    </div>
                    <div class="spec-badge">
                        <i class="fa-solid fa-door-closed"></i>
                        <span>No. Unit: ${property.nomorUnit}</span>
                    </div>
                    <div class="spec-badge">
                        <i class="fa-solid fa-shapes"></i>
                        <span>Tipe Unit: ${property.tipeUnit}</span>
                    </div>
                `;
    }

    container.innerHTML =
        '<!-- Back Link -->' +
        '<div class="back-nav" style="margin-top: 20px;">' +
        '    <a href="' + ctx + '/landing" class="btn-back">' +
        '        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">' +
        '            <polyline points="15 18 9 12 15 6"></polyline>' +
        '        </svg>' +
        '        Discover' +
        '    </a>' +
        '</div>' +
        '' +
        '<!-- 5-Photo Grid Widget -->' +
        photoGridHtml +
        '' +
        '<!-- LEFT COLUMN: Description & details -->' +
        '<div class="detail-main">' +
        '    <div class="title-badge-strip">' +
        '        ' + categoryBadge +
        '        ' + verifiedTag +
        '    </div>' +
        '    <div class="detail-info-header" style="border-bottom: none; padding-bottom: 0;">' +
        '        <div class="detail-title">' +
        '            <h1 style="margin-top: 0;">' + property.name + '</h1>' +
        '            <div class="detail-location">' +
        '                <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">' +
        '                    <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/>' +
        '                    <circle cx="12" cy="9" r="2.5" />' +
        '                </svg>' +
        '                ' + property.location +
        '            </div>' +
        '        </div>' +
        '    </div>' +
        '' +
        '    <!-- Custom Dynamic Specs row (UML compliance) -->' +
        '    <div class="detail-specs-strip">' +
        '        ' + specsHtml +
        '    </div>' +
        '' +
        '    <!-- Deskripsi Section -->' +
        '    <div class="detail-section">' +
        '        <h2>About this property</h2>' +
        '        <p style="word-wrap: break-word; overflow-wrap: break-word; word-break: break-word; white-space: normal; max-width: 100%;">' + property.description + '</p>' +
        '    </div>' +
        '' +
        '    <!-- Fasilitas Section -->' +
        '    <div class="detail-section">' +
        '        <h2>Facilities</h2>' +
        '        <div class="facility-grid">' +
        '            ' + facilitiesHtml +
        '        </div>' +
        '    </div>' +
        '</div>' +
        '' +
        '<!-- RIGHT COLUMN: Booking/Owner Widget -->' +
        '<div class="detail-sidebar">' +
        '    <div class="booking-card" style="background: #fff; border: 1px solid var(--border); box-shadow: 0 10px 40px rgba(0,0,0,0.03);">' +
        '        <div class="booking-header" style="border-bottom: none; padding-bottom: 0; margin-bottom: 16px;">' +
        '            <div class="booking-title" style="font-size: 11px; color: var(--text-secondary);">Rent Price</div>' +
        '            <div class="booking-price" style="font-size: 28px; font-weight: 800; color: var(--deep);">' + property.priceLabel.replace("/bln", "") + ' <span style="font-size: 14px; font-weight: 500; color: var(--text-secondary);">/ month</span></div>' +
        '            <div style="font-size: 12px; color: var(--text-secondary); margin-top: 4px; font-weight: 500;">Minimum rent: 6 Months</div>' +
        '        </div>' +
        '' +
        '        <form class="booking-form" onsubmit="event.preventDefault(); SewainAlert.alert(\'Mengajukan pesan sewa kepada pemilik...\');" style="gap: 12px;">' +
        '            <button type="submit" class="booking-btn" style="background: #475d58; box-shadow: none; display: flex; align-items: center; justify-content: center; gap: 8px; border-radius: 12px; padding: 12px;">' +
        '                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">' +
        '                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>' +
        '                </svg>' +
        '                Contact Owner' +
        '            </button>' +
        '            ' +
        '            <button type="button" id="sidebarWishlistBtn" class="owner-chat-btn" style="border-radius: 12px; padding: 12px; display: flex; align-items: center; justify-content: center; gap: 8px; border: 1px solid var(--border); font-size: 14px; font-weight:600; transition: all 0.3s ease;">' +
        '                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">' +
        '                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>' +
        '                </svg>' +
        '                Save to Wishlist' +
        '            </button>' +
        '        </form>' +
        '' +
        '        <!-- Owner profile banner widget -->' +
        '        <div class="owner-profile-widget">' +
        '            <span class="nav-avatar-circle" style="width: 44px; height: 44px; display: flex; align-items: center; justify-content: center; background: #6b8c80; border-radius: 50%; color: white; flex-shrink: 0; margin-right: 12px;">' +
        '                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">' +
        '                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>' +
        '                    <circle cx="12" cy="7" r="4"/>' +
        '                </svg>' +
        '            </span>' +
        '            <div class="owner-details">' +
        '                <span class="owner-name">' + property.ownerName + '</span>' +
        '                <span class="owner-role">Property Manager</span>' +
        '            </div>' +
        '        </div>' +
        '        <button type="button" class="report-btn-premium" onclick="openReportModal()">' +
        '            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">' +
        '                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>' +
        '            </svg>' +
        '            Laporkan Properti/Penipuan' +
        '        </button>' +
        '    </div>' +
        '</div>' +
        '' +
        '<!-- recommendations bottom block -->' +
        '<div class="recommendations-section">' +
        '    <h2 class="recommendations-title">You might also like</h2>' +
        '    <div class="recommendations-grid">' +
        '        ' + recsHtml +
        '    </div>' +
        '</div>';


    document.querySelectorAll(".recommendations-grid .property-card").forEach(function (card) {

        card.addEventListener("click", function (e) {
            if (e.target.closest(".property-wishlist")) return;
            const id = this.getAttribute("data-id");
            window.location.href = ctx + "/property/detail?id=" + id;
        });
    });


    const wishlistBtns = document.querySelectorAll(".recommendations-grid .property-wishlist");
    wishlistBtns.forEach(btn => {
        btn.addEventListener("click", function (e) {
            e.preventDefault();
            e.stopPropagation();

            const id = this.getAttribute("data-id");
            const idx = favorites.indexOf(id);

            if (idx > -1) {
                favorites.splice(idx, 1);
                this.classList.remove("active");
            } else {
                favorites.push(id);
                this.classList.add("active");

                this.classList.add("pop");
                setTimeout(() => {
                    this.classList.remove("pop");
                }, 400);
            }

            localStorage.setItem(WISHLIST_KEY, JSON.stringify(favorites));


            if (id === property.id) {
                updateSidebarWishlistUI();
            }
        });
    });


    function updateSidebarWishlistUI() {
        const sidebarBtn = document.getElementById("sidebarWishlistBtn");
        if (!sidebarBtn) return;
        const isFav = favorites.includes(property.id);
        if (isFav) {
            sidebarBtn.classList.add("active");
            sidebarBtn.innerHTML = `
                        <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24" style="color: white; fill: white;">
                            <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"></path>
                        </svg>
                        Saved to Wishlist
                    `;
            sidebarBtn.style.background = "var(--primary)";
            sidebarBtn.style.color = "white";
            sidebarBtn.style.borderColor = "var(--primary)";
        } else {
            sidebarBtn.classList.remove("active");
            sidebarBtn.innerHTML = `
                        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                        </svg>
                        Save to Wishlist
                    `;
            sidebarBtn.style.background = "var(--white)";
            sidebarBtn.style.color = "var(--deep)";
            sidebarBtn.style.borderColor = "var(--border)";
        }
    }

    const sidebarBtn = document.getElementById("sidebarWishlistBtn");
    if (sidebarBtn) {
        sidebarBtn.addEventListener("click", function (e) {
            e.preventDefault();

            const id = property.id;
            const idx = favorites.indexOf(id);

            if (idx > -1) {
                favorites.splice(idx, 1);
            } else {
                favorites.push(id);
            }

            localStorage.setItem(WISHLIST_KEY, JSON.stringify(favorites));
            updateSidebarWishlistUI();


            document.querySelectorAll(`.recommendations-grid .property-wishlist[data-id="${id}"]`).forEach(btn => {
                if (idx > -1) {
                    btn.classList.remove("active");
                } else {
                    btn.classList.add("active");
                }
            });
        });
    }

    updateSidebarWishlistUI();

    const cards = document.querySelectorAll(".recommendations-grid .property-card");
    cards.forEach(card => {
        card.addEventListener("mousemove", function (e) {
            const rect = card.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            const centerX = rect.width / 2;
            const centerY = rect.height / 2;
            const rotateX = ((y - centerY) / centerY) * -3;
            const rotateY = ((x - centerX) / centerX) * 3;

            card.style.transform = `translateY(-10px) perspective(800px) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
        });

        card.style.transition = "transform 0.15s ease-out, box-shadow 0.3s ease";

        card.addEventListener("mouseleave", function () {
            card.style.transform = "";
            card.style.transition = "transform 0.4s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.4s cubic-bezier(0.22, 1, 0.36, 1)";
        });
    });

    const lightboxSlider = document.getElementById("lightboxSlider");
    const lightboxThumbs = document.getElementById("lightboxThumbs");
    const lightboxPropName = document.getElementById("lightboxPropName");
    if (lightboxPropName) lightboxPropName.textContent = property.name;

    if (lightboxSlider && lightboxThumbs) {
        allPhotos.forEach((photo, idx) => {
            const slide = document.createElement("div");
            slide.className = "lightbox-slide";
            const img = document.createElement("img");
            img.src = photo.url;
            img.alt = photo.caption;
            slide.appendChild(img);
            lightboxSlider.appendChild(slide);

            const thumb = document.createElement("div");
            thumb.className = `lightbox-thumb ${idx === 0 ? 'active' : ''}`;
            thumb.setAttribute("data-index", idx);
            const thumbImg = document.createElement("img");
            thumbImg.src = photo.url;
            thumbImg.alt = `Thumbnail ${idx + 1}`;
            thumb.appendChild(thumbImg);

            thumb.addEventListener("click", () => {
                goToSlide(idx);
            });
            lightboxThumbs.appendChild(thumb);
        });
    }

    let currentSlideIndex = 0;
    const totalSlides = allPhotos.length;

    window.goToSlide = function (index) {
        if (index < 0) index = 0;
        if (index >= totalSlides) index = totalSlides - 1;
        currentSlideIndex = index;

        if (lightboxSlider) {
            lightboxSlider.style.transform = `translateX(-${currentSlideIndex * 100}%)`;
        }

        const counter = document.getElementById("lightboxCounter");
        if (counter) {
            counter.textContent = `Photo ${currentSlideIndex + 1} of ${totalSlides}`;
        }

        const caption = document.getElementById("lightboxCaption");
        if (caption) {
            caption.textContent = allPhotos[currentSlideIndex].caption;
        }

        document.querySelectorAll(".lightbox-thumb").forEach((t, i) => {
            if (i === currentSlideIndex) {
                t.classList.add("active");
            } else {
                t.classList.remove("active");
            }
        });
    };

    let isDragging = false;
    let startX = 0;

    if (lightboxSlider) {
        lightboxSlider.addEventListener("dragstart", (e) => e.preventDefault());


        lightboxSlider.addEventListener("touchstart", dragStart);
        lightboxSlider.addEventListener("touchmove", dragMove);
        lightboxSlider.addEventListener("touchend", dragEnd);

        lightboxSlider.addEventListener("mousedown", dragStart);
        lightboxSlider.addEventListener("mousemove", dragMove);
        lightboxSlider.addEventListener("mouseup", dragEnd);
        lightboxSlider.addEventListener("mouseleave", dragEnd);
    }

    function getDragX(e) {
        return e.type.includes("mouse") ? e.pageX : e.touches[0].clientX;
    }

    function dragStart(e) {
        isDragging = true;
        startX = getDragX(e);
        if (lightboxSlider) {
            lightboxSlider.classList.add("dragging");
        }
    }

    function dragMove(e) {
        if (!isDragging) return;
        const currentX = getDragX(e);
        const diffX = currentX - startX;

        const sliderWidth = lightboxSlider.clientWidth;
        const currentPercentage = -(currentSlideIndex * 100) + (diffX / sliderWidth) * 100;
        lightboxSlider.style.transform = `translateX(${currentPercentage}%)`;
    }

    function dragEnd(e) {
        if (!isDragging) return;
        isDragging = false;
        if (lightboxSlider) {
            lightboxSlider.classList.remove("dragging");
        }

        const sliderWidth = lightboxSlider.clientWidth;
        let endX = e.type.includes("mouse") ? e.pageX : (e.changedTouches ? e.changedTouches[0].clientX : startX);
        const diffX = endX - startX;

        const threshold = Math.min(100, sliderWidth * 0.15);

        if (diffX < -threshold && currentSlideIndex < totalSlides - 1) {
            goToSlide(currentSlideIndex + 1);
        } else if (diffX > threshold && currentSlideIndex > 0) {
            goToSlide(currentSlideIndex - 1);
        } else {
            goToSlide(currentSlideIndex);
        }
    }

    const btnPrev = document.getElementById("lightboxPrev");
    const btnNext = document.getElementById("lightboxNext");

    if (btnPrev) {
        btnPrev.addEventListener("click", () => {
            goToSlide(currentSlideIndex - 1);
        });
    }
    if (btnNext) {
        btnNext.addEventListener("click", () => {
            goToSlide(currentSlideIndex + 1);
        });
    }

    document.addEventListener("keydown", (e) => {
        const lightboxEl = document.getElementById("photoLightbox");
        if (!lightboxEl || !lightboxEl.classList.contains("active")) return;

        if (e.key === "Escape") {
            closeLightbox();
        } else if (e.key === "ArrowLeft") {
            goToSlide(currentSlideIndex - 1);
        } else if (e.key === "ArrowRight") {
            goToSlide(currentSlideIndex + 1);
        }
    });

    window.openLightbox = function (startIndex = 0) {
        const lightboxEl = document.getElementById("photoLightbox");
        if (lightboxEl) {
            lightboxEl.style.display = "flex";
            lightboxEl.offsetHeight;
            lightboxEl.classList.add("active");
            goToSlide(startIndex);
        }
    };

    window.closeLightbox = function () {
        const lightboxEl = document.getElementById("photoLightbox");
        if (lightboxEl) {
            lightboxEl.classList.remove("active");
            setTimeout(() => {
                lightboxEl.style.display = "none";
            }, 450);
        }
    };

    const lightboxClose = document.getElementById("lightboxClose");
    if (lightboxClose) {
        lightboxClose.addEventListener("click", closeLightbox);
    }

    const lightboxEl = document.getElementById("photoLightbox");
    if (lightboxEl) {
        lightboxEl.addEventListener("click", (e) => {
            if (e.target === lightboxEl) {
                closeLightbox();
            }
        });
    }

    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    const dateInput = document.getElementById("startDate");
    if (dateInput) {
        dateInput.value = tomorrow.toISOString().split("T")[0];
        dateInput.min = tomorrow.toISOString().split("T")[0];
    }

    const dropdownModal = document.getElementById("reportIssueDropdown");
    if (dropdownModal) {
        const trigger = dropdownModal.querySelector(".dropdown-trigger-modal");
        const label = dropdownModal.querySelector(".trigger-label-modal");
        const options = dropdownModal.querySelectorAll(".dropdown-option-modal");
        const hiddenInput = document.getElementById("issueType");

        trigger.addEventListener("click", function (e) {
            e.stopPropagation();
            dropdownModal.classList.toggle("active");
        });

        options.forEach(opt => {
            opt.addEventListener("click", function (e) {
                e.stopPropagation();
                options.forEach(o => o.classList.remove("selected"));
                this.classList.add("selected");

                label.textContent = this.textContent;
                hiddenInput.value = this.getAttribute("data-value");
                dropdownModal.classList.remove("active");
            });
        });

        document.addEventListener("click", function (e) {
            if (!dropdownModal.contains(e.target)) {
                dropdownModal.classList.remove("active");
            }
        });
    }
});
