document.addEventListener("DOMContentLoaded", function () {
    const ctx = window.contextPath || "";
    const property = window.propertyData;
    const container = document.getElementById("detailContainer");

    if (!property) {
        container.innerHTML = `
            <div class="fallback-container">
                <h1>Properti Tidak Ditemukan</h1>
                <p>Maaf, detail informasi hunian yang Anda cari tidak tersedia atau telah dihapus.</p>
                <a href="${ctx}/pages/owner/dashboard_owner.jsp" class="booking-btn" style="text-decoration: none;">Kembali ke Dashboard</a>
            </div>
        `;
        return;
    }

    const rawImageString = property.rawPhotos ? property.rawPhotos.trim() : "";
    let photosArr = rawImageString ? rawImageString.split(',').map(s => s.trim()).filter(s => s) : [];
    
    if (photosArr.length === 0) {
        photosArr.push(ctx + "/assets/images/default-property.jpg");
    }

    photosArr = photosArr.map(p => PropertyUtils.resolvePropertyImage(p));

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

    let flagBannerHtml = "";
    if (property.flagCount >= 1 && property.flagCount < 3) {
        flagBannerHtml = `
            <div class="flag-banner flag-banner-warning">
                <strong>Properti Anda Sedang Ditangguhkan</strong>
                <p>Alasan: ${property.flagReason}</p>
                <p>Peringatan ke-${property.flagCount} dari 3. Pada peringatan ke-3, properti akan diblokir permanen.</p>
            </div>
        `;
    } else if (property.flagCount >= 3) {
        flagBannerHtml = `
            <div class="flag-banner flag-banner-banned">
                <strong>Properti Ini Telah Diblokir Permanen</strong>
                <p>Alasan: ${property.flagReason}</p>
                <p>Properti ini tidak dapat diedit atau dipulihkan. Hubungi admin untuk informasi lebih lanjut.</p>
            </div>
        `;
    }

    container.innerHTML = `
        <div class="back-nav" style="margin-top: 20px;">
            <a href="${ctx}/pages/owner/dashboard_owner.jsp" class="btn-back">
                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
                Back to Dashboard
            </a>
        </div>
        
        ${flagBannerHtml}

        ${photoGridHtml}

        <div class="detail-main">
            <div class="title-badge-strip">
                ${categoryBadge}
                ${verifiedTag}
            </div>
            <div class="detail-info-header" style="border-bottom: none; padding-bottom: 0;">
                <div class="detail-title">
                    <h1 style="margin-top: 0;">${property.name}</h1>
                    <div class="detail-location">
                        <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/>
                            <circle cx="12" cy="9" r="2.5" />
                        </svg>
                        ${property.location}
                    </div>
                </div>
            </div>

            <div class="detail-specs-strip">
                ${specsHtml}
            </div>

            <div class="detail-section">
                <h2>About this property</h2>
                <p style="word-wrap: break-word; overflow-wrap: break-word; word-break: break-word; white-space: normal; max-width: 100%;">${property.description}</p>
            </div>

            <div class="detail-section">
                <h2>Facilities</h2>
                <div class="facility-grid">
                    ${facilitiesHtml}
                </div>
            </div>
        </div>

        <div class="detail-sidebar">
            <div class="booking-card" style="background: #fff; border: 1px solid var(--border); box-shadow: 0 10px 40px rgba(0,0,0,0.03);">
                <div class="booking-header" style="border-bottom: none; padding-bottom: 0; margin-bottom: 16px;">
                    <div class="booking-title" style="font-size: 11px; color: var(--text-secondary);">Rent Price</div>
                    <div class="booking-price" style="font-size: 28px; font-weight: 800; color: var(--deep);">${property.priceLabel.replace("/bln", "")} <span style="font-size: 14px; font-weight: 500; color: var(--text-secondary);">/ month</span></div>
                    <div style="font-size: 12px; color: var(--text-secondary); margin-top: 4px; font-weight: 500;">Status: ${property.available ? 'Available' : 'Rented'}</div>
                </div>

                <div class="booking-form" style="gap: 12px;">
                    ${property.flagCount < 3 ? `
                        <a href="${ctx}/owner/edit?propertyId=${property.id}" class="owner-action-btn-edit">
                            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                <path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                            </svg>
                            Edit Property
                        </a>
                        
                        <button type="button" class="owner-action-btn-delete" onclick="openDeleteModal(${property.id})">
                            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <polyline points="3 6 5 6 21 6"></polyline>
                                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                            </svg>
                            Delete Property
                        </button>
                    ` : ''}
                </div>
            </div>
        </div>
    `;

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
});

window.openDeleteModal = function (propertyId) {
    const modal = document.getElementById("deleteModal");
    const deleteIdInput = document.getElementById("deletePropertyId");
    if (modal && deleteIdInput) {
        deleteIdInput.value = propertyId;
        modal.style.display = "flex";
    }
};

window.closeDeleteModal = function () {
    const modal = document.getElementById("deleteModal");
    if (modal) {
        modal.style.display = "none";
    }
};