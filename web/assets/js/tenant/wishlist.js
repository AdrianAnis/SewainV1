(function () {
  const ctx = window.contextPath || "";
  const wishlistKey = window.WISHLIST_KEY;

  try {
    var raw = localStorage.getItem(wishlistKey);
    if (raw) {
      var arr = JSON.parse(raw);
      if (Array.isArray(arr)) {
        var clean = arr.filter(function (id) {
          if (id === null || id === undefined || id === "") return false;
          return !isNaN(Number(String(id)));
        });
        if (clean.length !== arr.length) {
          console.warn("[wishlist] Sanitized favorites:", arr, "->", clean);
          localStorage.setItem(wishlistKey, JSON.stringify(clean));
        }
      }
    }
  } catch (e) { console.warn("[wishlist] Cleanup error:", e); }


  var originalFetch = window.fetch;
  window.fetch = function (url, options) {
    return originalFetch.apply(this, arguments).then(function (response) {
      if (typeof url === "string" && url.indexOf("/wishlist-properties") !== -1) {
        return response.clone().text().then(function (text) {
          try {
            var data = JSON.parse(text);
            if (Array.isArray(data)) {
              data.forEach(function (prop) {
                if (prop && prop.photos && typeof prop.photos === "string") {
                  prop.photos = prop.photos.split(",").map(function (photo) {
                    var p = photo.trim();
                    if (p.indexOf("/uploads/") === 0) {
                      return ctx + p;
                    }
                    return p;
                  }).join(",");
                }
              });
            }
            return new Response(JSON.stringify(data), {
              status: response.status,
              statusText: response.statusText,
              headers: { "Content-Type": "application/json" }
            });
          } catch (e) {
            return new Response(text, {
              status: response.status,
              statusText: response.statusText,
              headers: response.headers
            });
          }
        });
      }
      return response;
    });
  };
})();

document.addEventListener("DOMContentLoaded", function () {
  const wishlistGrid = document.getElementById("wishlistGrid");
  const emptyPanel = document.getElementById("emptyPanel");
  const headerPanel = document.getElementById("headerPanel");
  const countHighlight = document.getElementById("countHighlight");
  const ctx = window.contextPath || "";


  let favorites = JSON.parse(localStorage.getItem(WISHLIST_KEY)) || [];

  const favNavbarBtn = document.querySelector(".nav-icon-btn[aria-label='Favorit']");
  if (favNavbarBtn) {
    favNavbarBtn.addEventListener("click", function (e) {
      e.preventDefault();
      window.location.href = `${ctx}/pages/tenant/wishlist.jsp`;
    });
  }

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


  function updateLayoutState(count) {
    if (count === 0) {
      if (headerPanel) headerPanel.style.display = "none";
      if (wishlistGrid) wishlistGrid.style.display = "none";
      if (emptyPanel) emptyPanel.style.display = "flex";
    } else {
      if (headerPanel) headerPanel.style.display = "flex";
      if (wishlistGrid) wishlistGrid.style.display = "grid";
      if (emptyPanel) emptyPanel.style.display = "none";
      if (countHighlight) {
        countHighlight.innerHTML = `<span class="count-highlight">${count} properti</span>`;
      }
    }
  }


  if (favorites.length === 0) {
    updateLayoutState(0);
    return;
  }


  const idsParam = favorites.join(",");
  fetch(`${ctx}/wishlist-properties?ids=${encodeURIComponent(idsParam)}`)
    .then(res => {
      if (!res.ok) throw new Error("Gagal mengambil data wishlist");
      return res.json();
    })
    .then(data => {
      const properties = (data || []).map(p => {
        if (!p) return null;
        let image = "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=600&q=80";
        let rawPhotos = p.photos || p.image || "";
        if (typeof rawPhotos === 'string' && rawPhotos.trim().length > 0) {
          let parts = rawPhotos.split(',');
          if (parts.length > 0 && parts[0]) {
            let photoUtama = parts[0].trim();
            if (photoUtama.startsWith("http")) {
              image = photoUtama;
            } else if (photoUtama.includes("/uploads/")) {
              image = photoUtama;
            } else if (photoUtama.length > 0) {
              image = ctx + "/uploads/" + photoUtama;
            }
          }
        }

        return {
          id: p.propertyId ? String(p.propertyId) : p.id,
          name: p.name || "Properti",
          location: p.location || "Lokasi Tidak Diketahui",
          type: p.propertyType || p.type || "Kost",
          price: p.price || 0,
          priceLabel: p.priceLabel || (p.price >= 1000000 ? "Rp " + (p.price / 1000000) + " jt/bln" : "Rp " + p.price + "/bln"),
          beds: p.beds || 1,
          baths: p.baths || 1,
          area: p.area || "10m²",
          verified: (p.verificationStatus === 'Approved') || p.verified,
          available: (p.availability === 1) || p.available,
          image: image,
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

      renderWishlist(properties);
    })
    .catch(err => {
      console.error("Error loading wishlist properties:", err);
      updateLayoutState(0);
    });


  function renderWishlist(propertiesList) {
    if (!wishlistGrid) return;
    updateLayoutState(propertiesList.length);

    wishlistGrid.innerHTML = propertiesList.map(prop => {
      return `
        <div class="property-card" data-id="${prop.id}">
          <div class="property-img-wrapper">
            <img src="${prop.image}" alt="${prop.name}">
            
            ${prop.verified ? `
            <span class="badge-verified">
                <i class="fa-solid fa-circle-check"></i> VERIFIED
            </span>
            ` : ""}
            
            <button class="property-wishlist active" data-id="${prop.id}" aria-label="Wishlist">
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
              ${(function () {
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

    bindWishlistCardInteractions(propertiesList);
  }


  function bindWishlistCardInteractions(propertiesList) {
    const cards = document.querySelectorAll(".property-grid .property-card");

    cards.forEach(card => {
      const id = card.getAttribute("data-id");
      const wishlistBtn = card.querySelector(".property-wishlist");

      card.addEventListener("click", function (e) {
        if (wishlistBtn.contains(e.target) || wishlistBtn === e.target) return;
        window.location.href = `${ctx}/property/detail?id=${id}`;
      });

      if (wishlistBtn) {
        wishlistBtn.addEventListener("click", function (e) {
          e.preventDefault();
          e.stopPropagation();

          wishlistBtn.classList.add("pop");

          setTimeout(() => {
            const idxFav = favorites.indexOf(id);
            if (idxFav > -1) {
              favorites.splice(idxFav, 1);
              localStorage.setItem(WISHLIST_KEY, JSON.stringify(favorites));
            }

            card.classList.add("fade-out");

            setTimeout(() => {
              card.remove();

              const updatedList = propertiesList.filter(p => p.id !== id);
              updateLayoutState(updatedList.length);
              bindWishlistCardInteractions(updatedList);
            }, 400);
          }, 350);
        });
      }

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
});
