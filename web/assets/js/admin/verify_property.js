document.addEventListener("DOMContentLoaded", () => {
    resolveCardImages();
});

function resolveCardImages() {
    const images = document.querySelectorAll(".property-img-preview");
    images.forEach(img => {
        const photoStr = img.getAttribute("data-photos");
        if (typeof resolvePropertyImage === "function") {
            img.src = resolvePropertyImage(photoStr);
        } else {
            img.src = `${window.contextPath}/assets/images/default-property.jpg`;
        }
    });
}

async function approveProperty(propertyId) {
    if (!(await SewainAlert.confirm("Apakah Anda yakin ingin menyetujui iklan properti ini?", "Konfirmasi Persetujuan", "info"))) return;

    showSpinner();

    const params = new URLSearchParams();
    params.append("action", "approve");
    params.append("propertyId", propertyId);

    fetch(`${window.contextPath}/admin/verify`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        hideSpinner();
        if (data.success) {
            removeCardFromUI(propertyId);
            SewainAlert.success("Properti berhasil disetujui!");
        } else {
            SewainAlert.error(data.message || "Gagal menyetujui properti.");
        }
    })
    .catch(error => {
        hideSpinner();
        console.error("Error approving property:", error);
        SewainAlert.error("Terjadi kesalahan koneksi server.");
    });
}

function openRejectModal(propertyId) {
    document.getElementById("reject-property-id").value = propertyId;
    document.getElementById("reject-reason").value = "";
    document.getElementById("reject-modal").style.display = "flex";
}

function closeRejectModal() {
    document.getElementById("reject-modal").style.display = "none";
}

function executeReject(event) {
    event.preventDefault();

    const propertyId = document.getElementById("reject-property-id").value;
    const reason = document.getElementById("reject-reason").value.trim();

    closeRejectModal();
    showSpinner();

    const params = new URLSearchParams();
    params.append("action", "reject");
    params.append("propertyId", propertyId);
    params.append("reason", reason);

    fetch(`${window.contextPath}/admin/verify`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        hideSpinner();
        if (data.success) {
            removeCardFromUI(propertyId);
            SewainAlert.success("Properti berhasil ditolak.");
        } else {
            SewainAlert.error(data.message || "Gagal menolak properti.");
        }
    })
    .catch(error => {
        hideSpinner();
        console.error("Error rejecting property:", error);
        SewainAlert.error("Terjadi kesalahan koneksi server.");
    });
}

function removeCardFromUI(propertyId) {
    const card = document.querySelector(`.property-card[data-id="${propertyId}"]`);
    if (!card) return;

    card.style.transition = "all 0.4s ease";
    card.style.opacity = "0";
    card.style.transform = "scale(0.9) translateY(-20px)";

    setTimeout(() => {
        card.remove();
        updatePendingCounter();
    }, 400);
}

function updatePendingCounter() {
    const container = document.getElementById("properties-container");
    const counterBadge = document.getElementById("pending-count");
    
    const remainingCards = container.querySelectorAll(".property-card").length;
    
    if (counterBadge) {
        counterBadge.textContent = `${remainingCards} Pengajuan`;
    }

    if (remainingCards === 0) {
        container.innerHTML = `
            <div class="no-pending-state">
                <i class="fa-solid fa-shield-check success-icon" style="font-size: 4.5rem; margin-bottom: 12px; background: -webkit-linear-gradient(135deg, #0f766e, #10b981); -webkit-background-clip: text; -webkit-text-fill-color: transparent;"></i>
                <h3 style="font-size: 1.75rem; font-weight: 800; color: #0f172a; margin: 0;">Antrean Bersih!</h3>
                <p style="color: #64748b; font-size: 1.05rem; margin-top: 8px;">Semua pengajuan properti telah selesai ditinjau.</p>
            </div>
        `;
    }
}

function showSpinner() {
    const loader = document.getElementById("ajax-loader");
    if (loader) loader.style.display = "flex";
}

function hideSpinner() {
    const loader = document.getElementById("ajax-loader");
    if (loader) loader.style.display = "none";
}

function viewPropertyImage(url) {
    if (!url) return;
    window.open(url, '_blank');
}