document.addEventListener("DOMContentLoaded", function () {

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


  const upgradeOwnerLink = document.getElementById("upgradeOwnerLink");
  const upgradeModalOverlay = document.getElementById("upgradeModalOverlay");
  const cancelUpgradeBtn = document.getElementById("cancelUpgradeBtn");
  const confirmUpgradeBtn = document.getElementById("confirmUpgradeBtn");

  if (upgradeOwnerLink && upgradeModalOverlay) {
    upgradeOwnerLink.addEventListener("click", function(e) {
      e.preventDefault();

      if (profileDropdown) profileDropdown.style.display = "none";
      upgradeModalOverlay.style.display = "flex";
    });

    cancelUpgradeBtn.addEventListener("click", function() {
      upgradeModalOverlay.style.display = "none";
    });


    upgradeModalOverlay.addEventListener("click", function(e) {
      if (e.target === upgradeModalOverlay) {
        upgradeModalOverlay.style.display = "none";
      }
    });

    confirmUpgradeBtn.addEventListener("click", async function() {

      const originalText = this.textContent;
      this.textContent = "Memproses...";
      this.disabled = true;
      
      const ctx = window.contextPath || "";
      try {
        
        const response = await fetch(ctx + "/upgrade", { method: 'GET' });
        
        if (response.ok) {

          SewainAlert.success("Selamat! Anda berhasil beralih ke mode Owner.").then(() => {
            window.location.reload();
          });
          window.location.href = ctx + "/pages/owner/dashboard_owner.jsp";
        } else {
          SewainAlert.error(data.message || "Gagal melakukan upgrade.");
          this.textContent = originalText;
          this.disabled = false;
        }
      } catch (error) {
        console.error("Upgrade error:", error);
        SewainAlert.error("Terjadi kesalahan jaringan.");
        this.textContent = originalText;
        this.disabled = false;
      }
    });
  }

  const urlParamsCheck = new URLSearchParams(window.location.search);
  const isSearchPerformedCheck = urlParamsCheck.has("search_property_name") || 
                                 urlParamsCheck.has("search_location") || 
                                 urlParamsCheck.has("price") || 
                                 urlParamsCheck.has("type");

  let rawProperties = window.serverProperties || [];

  function resolvePropertyImage(photoStr) {
    const ctxPath = window.contextPath || "";
    const defaultImg = ctxPath + "/assets/images/default-property.jpg";
    if (!photoStr || typeof photoStr !== 'string') return defaultImg;
    
    let trimmed = photoStr.trim();
    if (trimmed === "" || trimmed === "null" || trimmed === "[]") return defaultImg;
    
    let parts = trimmed.split(',');
    if (parts.length === 0 || !parts[0]) return defaultImg;
    
    let photo = parts[0].trim();
    if (photo === "" || photo === "null") return defaultImg;
    
    if (photo.startsWith("http://") || photo.startsWith("https://")) return photo;
    if (photo.startsWith(ctxPath + "/uploads/")) return photo;
    if (photo.startsWith("/uploads/")) {
        console.log("ctxPath:", ctxPath);
        console.log("photo:", photo);
        console.log("result:", ctxPath + photo);
        return ctxPath + photo;
    }
    if (photo.startsWith("/")) return photo;
    if (photo.startsWith("uploads/")) return ctxPath + "/" + photo;
    return ctxPath + "/uploads/" + photo;
  }


  const properties = (rawProperties || []).map(p => {
    if (!p) return null;
    const id = p.propertyId ? String(p.propertyId) : (p.id ? String(p.id) : "");
    const name = p.name || "Properti";
    const location = p.location || "Lokasi Tidak Diketahui";
    const type = p.propertyType || p.type || "Kost";
    const price = typeof p.price === 'number' ? p.price : 0;
    const priceLabel = p.priceLabel || (price >= 1000000 ? "Rp " + (price / 1000000) + " jt/bln" : "Rp " + price + "/bln");
    const beds = p.beds || 1;
    const baths = p.baths || 1;
    const area = p.area || "10m²";
    const verified = (p.verificationStatus === 'Approved') || !!p.verified;
    const available = (p.availability === 1) || !!p.available;
    
    const rawPhotos = p.photos || p.image || "";
    const ownerName = p.ownerName || "SewaIn Manager";
    let ownerProfilePic = (window.contextPath || "") + "/assets/images/avatar/default.png";

    return {
      id,
      name,
      location,
      type,
      price,
      priceLabel,
      beds,
      baths,
      area,
      verified,
      available,
      image: resolvePropertyImage(p.photos || p.image || ""),
      rawPhotos,
      ownerName,
      ownerProfilePic,
      description: p.description || "",
      gender: p.gender || "",
      roomType: p.roomType || "",
      jumlahKamar: p.jumlahKamar || 0,
      luasTanah: p.luasTanah || 0,
      durasiMinimum: p.durasiMinimum || 0,
      lantai: p.lantai || 0,
      nomorUnit: p.nomorUnit || "",
      tipeUnit: p.tipeUnit || ""
    };
  }).filter(p => p !== null);


  let favorites = JSON.parse(localStorage.getItem(WISHLIST_KEY)) || [];

  const propertyGrid = document.getElementById("propertyGrid");
  const ctx = window.contextPath || "";


  const mainSearchInput = document.getElementById("mainSearchInput");
  const searchLocationInput = document.getElementById("searchLocationInput");
  const locationSuggestions = document.getElementById("locationSuggestions");
  const nameSuggestions = document.getElementById("nameSuggestions");
  const searchForm = document.getElementById("searchForm");
  const hiddenPrice = document.getElementById("hiddenPrice");
  const hiddenType = document.getElementById("hiddenType");


  const urlParams = new URLSearchParams(window.location.search);
  const paramName = urlParams.get("search_property_name") || "";
  const paramLoc = urlParams.get("search_location") || "";
  const paramPrice = urlParams.get("price") || "";
  const paramType = urlParams.get("type") || "";

  if (mainSearchInput) mainSearchInput.value = paramName;
  if (searchLocationInput) searchLocationInput.value = paramLoc;
  if (hiddenPrice) hiddenPrice.value = paramPrice;
  if (hiddenType) hiddenType.value = paramType;


  let filteredProperties = [...properties];


  function initCustomDropdown(dropdownId, initialValue, onSelectCallback) {
    const dropdown = document.getElementById(dropdownId);
    if (!dropdown) return;

    const trigger = dropdown.querySelector(".dropdown-trigger");
    const label = dropdown.querySelector(".trigger-label");
    const options = dropdown.querySelectorAll(".dropdown-option");


    if (initialValue) {
      options.forEach(opt => {
        if (opt.getAttribute("data-value") === initialValue) {
          options.forEach(o => o.classList.remove("selected"));
          opt.classList.add("selected");
          label.textContent = opt.textContent;
        }
      });
    }

    trigger.addEventListener("click", function (e) {
      e.stopPropagation();

      document.querySelectorAll(".custom-dropdown").forEach(d => {
        if (d !== dropdown) {
          d.classList.remove("active");
        }
      });
      dropdown.classList.toggle("active");
    });

    options.forEach(opt => {
      opt.addEventListener("click", function (e) {
        e.stopPropagation();
        options.forEach(o => o.classList.remove("selected"));
        opt.classList.add("selected");

        const val = opt.getAttribute("data-value");
        const text = opt.textContent;

        label.textContent = text;
        dropdown.classList.remove("active");

        onSelectCallback(val);
      });
    });
  }


  initCustomDropdown("priceDropdown", paramPrice, function (val) {
    if (hiddenPrice) hiddenPrice.value = val;
  });

  initCustomDropdown("typeDropdown", paramType, function (val) {
    if (hiddenType) hiddenType.value = val;
  });


  document.addEventListener("click", function (e) {
    document.querySelectorAll(".custom-dropdown").forEach(d => {
      d.classList.remove("active");
    });
    if (locationSuggestions && !locationSuggestions.contains(e.target) && e.target !== searchLocationInput) {
      locationSuggestions.style.display = "none";
    }
    if (nameSuggestions && !nameSuggestions.contains(e.target) && e.target !== mainSearchInput) {
      nameSuggestions.style.display = "none";
    }
  });


  if (searchLocationInput && locationSuggestions) {
    let debounceTimer;
    searchLocationInput.addEventListener("input", function () {
      clearTimeout(debounceTimer);
      const query = this.value.trim();
      
      if (query.length < 1) {
        locationSuggestions.innerHTML = "";
        locationSuggestions.style.display = "none";
        return;
      }

      debounceTimer = setTimeout(() => {
        fetch(`${ctx}/get-locations?q=${encodeURIComponent(query)}`)
          .then(res => res.json())
          .then(data => {
            locationSuggestions.innerHTML = "";
            if (data.length === 0) {
              const noRes = document.createElement("div");
              noRes.className = "suggestion-item no-results";
              noRes.textContent = "Lokasi tidak ditemukan";
              locationSuggestions.appendChild(noRes);
            } else {
              data.forEach(loc => {
                const item = document.createElement("div");
                item.className = "suggestion-item";
                item.textContent = loc;
                 item.addEventListener("click", function () {
                   searchLocationInput.value = loc;
                   locationSuggestions.style.display = "none";
                 });
                locationSuggestions.appendChild(item);
              });
            }
            locationSuggestions.style.display = "block";
          })
          .catch(err => {
            console.error("Error fetching locations autocomplete:", err);
          });
      }, 200);
    });

    searchLocationInput.addEventListener("focus", function () {
      if (this.value.trim().length >= 1 && locationSuggestions.children.length > 0) {
        locationSuggestions.style.display = "block";
      }
    });
  }


  const ITEMS_PER_PAGE = 6;
  let currentPage = 1;


  function renderProperties() {
    const paginationEl = document.querySelector(".pagination");
    if (!propertyGrid) return;

    if (filteredProperties.length === 0) {
      propertyGrid.innerHTML = `
        <div style="grid-column: 1 / -1; text-align: center; padding: 60px 20px; color: var(--text-secondary);">
          <svg width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" style="margin-bottom: 16px; color: var(--primary); display: inline-block;">
            <circle cx="12" cy="12" r="10"></circle>
            <line x1="8" y1="12" x2="16" y2="12"></line>
          </svg>
          <h3 style="color: var(--deep); font-weight: 700; margin-bottom: 8px; font-size: 20px;">Data tidak ditemukan</h3>
          <p style="font-size: 14px;">Coba gunakan kata kunci atau kombinasi filter pencarian lainnya.</p>
        </div>
      `;
      if (paginationEl) paginationEl.style.display = "none";
      return;
    }


    const totalPages = Math.ceil(filteredProperties.length / ITEMS_PER_PAGE);
    if (currentPage > totalPages) currentPage = totalPages;
    if (currentPage < 1) currentPage = 1;
    const startIdx = (currentPage - 1) * ITEMS_PER_PAGE;
    const pageItems = filteredProperties.slice(startIdx, startIdx + ITEMS_PER_PAGE);

    propertyGrid.innerHTML = pageItems.map(prop => {
      const isFav = favorites.includes(prop.id);
      return `
        <div class="property-card" data-id="${prop.id}">
          <div class="property-img-wrapper">
            <img src="${prop.image}" alt="${prop.name}">
            
            ${prop.verified ? `
            <span class="badge-verified">
                <i class="fa-solid fa-circle-check"></i> VERIFIED
            </span>
            ` : ""}
            
            <button class="property-wishlist ${isFav ? 'active' : ''}" data-id="${prop.id}" aria-label="Wishlist">
              <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
              </svg>
            </button>
            
            ${prop.available ? `
            <div class="property-available">AVAILABLE NOW</div>
            ` : ""}
          </div>
          
          <div class="property-content">
            <div class="property-top-row">
              <h3 class="property-name">${prop.name}</h3>
              <span class="property-price">${prop.priceLabel}</span>
            </div>
            
            <p class="property-location">
              <svg width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/>
                <circle cx="12" cy="9" r="2.5" />
              </svg>
              ${prop.location}
            </p>
            
            <div class="property-meta" style="display: flex; gap: 16px; border-top: 1px solid var(--border); padding-top: 16px; font-size: 13.5px; font-weight: 500; color: var(--deep);">
              ${(function() {
                const pType = (prop.type || "").toLowerCase();
                if (pType === "kost") {
                  return `
                    <span style="display: flex; align-items: center; gap: 6px;">
                      <i class="fa-solid fa-venus-mars"></i>
                      ${prop.gender || "Campur"}
                    </span>
                    <span style="display: flex; align-items: center; gap: 6px;">
                      <i class="fa-solid fa-door-closed"></i>
                      ${prop.roomType || "Standard"}
                    </span>
                  `;
                } else if (pType === "rumah") {
                  return `
                    <span style="display: flex; align-items: center; gap: 6px;">
                      <i class="fa-solid fa-bed"></i>
                      ${prop.jumlahKamar || prop.beds} Kamar
                    </span>
                    <span style="display: flex; align-items: center; gap: 6px;">
                      <i class="fa-solid fa-maximize"></i>
                      ${prop.luasTanah ? (prop.luasTanah + " m²") : prop.area}
                    </span>
                  `;
                } else if (pType === "kontrakan") {
                  return `
                    <span style="display: flex; align-items: center; gap: 6px;">
                      <i class="fa-solid fa-bed"></i>
                      ${prop.jumlahKamar || prop.beds} Kamar
                    </span>
                    <span style="display: flex; align-items: center; gap: 6px;">
                      <i class="fa-solid fa-calendar-days"></i>
                      Min. ${prop.durasiMinimum || 12} Bln
                    </span>
                  `;
                } else { 
                  return `
                    <span style="display: flex; align-items: center; gap: 6px;">
                      <i class="fa-solid fa-layer-group"></i>
                      Lantai ${prop.lantai || 12}
                    </span>
                    <span style="display: flex; align-items: center; gap: 6px;">
                      <i class="fa-solid fa-door-closed"></i>
                      Unit ${prop.nomorUnit || "12B"}
                    </span>
                    <span style="display: flex; align-items: center; gap: 6px;">
                      <i class="fa-solid fa-shapes"></i>
                      ${prop.tipeUnit || "Studio"}
                    </span>
                  `;
                }
              })()}
            </div>
          </div>
        </div>
      `;
    }).join("");

    bindCardInteractions();
    renderPagination(totalPages);
  }


  function renderPagination(totalPages) {
    const paginationEl = document.querySelector(".pagination");
    if (!paginationEl) return;


    if (totalPages <= 1) {
      paginationEl.style.display = "none";
      return;
    }
    paginationEl.style.display = "flex";
    paginationEl.innerHTML = "";

 
    const prevLink = document.createElement("a");
    prevLink.href = "#";
    prevLink.className = "page-link" + (currentPage <= 1 ? " disabled" : "");
    prevLink.setAttribute("aria-label", "Previous page");
    prevLink.innerHTML = "&lt;";
    prevLink.addEventListener("click", function(e) {
      e.preventDefault();
      if (currentPage > 1) { currentPage--; renderProperties(); window.scrollTo({ top: propertyGrid.offsetTop - 100, behavior: "smooth" }); }
    });
    paginationEl.appendChild(prevLink);


    for (let i = 1; i <= totalPages; i++) {
      const pageLink = document.createElement("a");
      pageLink.href = "#";
      pageLink.className = "page-link" + (i === currentPage ? " active" : "");
      pageLink.textContent = i;
      pageLink.addEventListener("click", function(e) {
        e.preventDefault();
        currentPage = i;
        renderProperties();
        window.scrollTo({ top: propertyGrid.offsetTop - 100, behavior: "smooth" });
      });
      paginationEl.appendChild(pageLink);
    }


    const nextLink = document.createElement("a");
    nextLink.href = "#";
    nextLink.className = "page-link" + (currentPage >= totalPages ? " disabled" : "");
    nextLink.setAttribute("aria-label", "Next page");
    nextLink.innerHTML = "&gt;";
    nextLink.addEventListener("click", function(e) {
      e.preventDefault();
      if (currentPage < totalPages) { currentPage++; renderProperties(); window.scrollTo({ top: propertyGrid.offsetTop - 100, behavior: "smooth" }); }
    });
    paginationEl.appendChild(nextLink);
  }


  function bindCardInteractions() {

    const wishlistBtns = document.querySelectorAll(".property-wishlist");
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
      });
    });


    const cards = document.querySelectorAll(".property-grid .property-card");
    cards.forEach(card => {

      card.addEventListener("click", function () {
        const id = this.getAttribute("data-id");
        window.location.href = `${ctx}/property/detail?id=${id}`;
      });

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
  }


  if (mainSearchInput && nameSuggestions) {
    let debounceTimerName;
    mainSearchInput.addEventListener("input", function () {
      clearTimeout(debounceTimerName);
      const query = this.value.trim();
      
      if (query.length < 1) {
        nameSuggestions.innerHTML = "";
        nameSuggestions.style.display = "none";
        return;
      }

      debounceTimerName = setTimeout(() => {
        fetch(`${ctx}/get-property-names?q=${encodeURIComponent(query)}`)
          .then(res => res.json())
          .then(data => {
            nameSuggestions.innerHTML = "";
            if (data.length === 0) {
              const noRes = document.createElement("div");
              noRes.className = "suggestion-item no-results";
              noRes.textContent = "Nama properti tidak ditemukan";
              nameSuggestions.appendChild(noRes);
            } else {
              data.forEach(nameVal => {
                const item = document.createElement("div");
                item.className = "suggestion-item";
                item.textContent = nameVal;
                item.addEventListener("click", function () {
                  mainSearchInput.value = nameVal;
                  nameSuggestions.style.display = "none";
                });
                nameSuggestions.appendChild(item);
              });
            }
            nameSuggestions.style.display = "block";
          })
          .catch(err => {
            console.error("Error fetching property names autocomplete:", err);
          });
      }, 200);
    });

    mainSearchInput.addEventListener("focus", function () {
      if (this.value.trim().length >= 1 && nameSuggestions.children.length > 0) {
        nameSuggestions.style.display = "block";
      }
    });
  }


  renderProperties();
});
