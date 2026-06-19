let activeDeletePropertyId = null;

// 1. Unflag Property via AJAX
async function unflagProperty(propertyId) {
    if (!(await SewainAlert.confirm("Apakah Anda yakin ingin mencabut status flag pada properti ini? Iklan akan kembali aktif."))) return;

    showLoader();

    const params = new URLSearchParams();
    params.append("action", "unflagProperty");
    params.append("propertyId", propertyId);

    fetch(`${window.contextPath}/admin/flagged`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params
    })
        .then(response => response.json())
        .then(data => {
            hideLoader();
            if (data.success) {
                removeRowFromUI(propertyId);
                SewainAlert.success("Status flag berhasil dicabut. Properti kembali aktif.");
            } else {
                SewainAlert.error(data.message || "Gagal mencabut status flag.");
            }
        })
        .catch(error => {
            hideLoader();
            console.error("Error unflagging property:", error);
            SewainAlert.error("Terjadi kesalahan koneksi server.");
        });
}

// 2. Permanent Delete Property via Modal & AJAX
function confirmDeletePermanent(propertyId) {
    activeDeletePropertyId = propertyId;

    const row = document.querySelector(`.property-row[data-id="${propertyId}"]`);
    const name = row ? row.getAttribute("data-name") : "properti ini";

    document.getElementById("delete-prop-name").textContent = `"${name}"`;
    document.getElementById("delete-modal").style.display = "flex";

    document.getElementById("btn-delete-confirm-execute").onclick = executeDeletePermanent;
}

function closeDeleteModal() {
    document.getElementById("delete-modal").style.display = "none";
    activeDeletePropertyId = null;
}

function executeDeletePermanent() {
    if (!activeDeletePropertyId) return;

    closeDeleteModal();
    showLoader();

    const params = new URLSearchParams();
    params.append("action", "deleteProperty");
    params.append("propertyId", activeDeletePropertyId);

    fetch(`${window.contextPath}/admin/flagged`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params
    })
        .then(response => response.json())
        .then(data => {
            hideLoader();
            if (data.success) {
                removeRowFromUI(activeDeletePropertyId);
                SewainAlert.success("Properti berhasil dihapus secara permanen.");
            } else {
                SewainAlert.error(data.message || "Gagal menghapus properti secara permanen.");
            }
        })
        .catch(error => {
            hideLoader();
            console.error("Error deleting property permanently:", error);
            SewainAlert.error("Terjadi kesalahan koneksi server.");
        });
}

// 3. UI Helpers
function removeRowFromUI(propertyId) {
    const row = document.querySelector(`.property-row[data-id="${propertyId}"]`);
    if (!row) return;

    row.style.transition = "all 0.4s ease";
    row.style.opacity = "0";
    row.style.transform = "scale(0.95) translateX(-20px)";

    setTimeout(() => {
        row.remove();
        updateFlaggedCounter();
    }, 400);
}

function updateFlaggedCounter() {
    const tbody = document.getElementById("flagged-table-body");
    const badge = document.getElementById("flag-count-badge");
    const remainingRows = tbody.querySelectorAll(".property-row").length;

    if (badge) {
        badge.textContent = `${remainingRows} Properti`;
    }

    if (remainingRows === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="5" class="text-center text-muted py-8">
                    <i class="fa-solid fa-circle-check success-icon mb-2 block"></i>
                    Tidak ada properti bermasalah yang sedang ditangguhkan saat ini.
                </td>
            </tr>
        `;
    }
}

function showLoader() {
    const loader = document.getElementById("ajax-loader");
    if (loader) loader.style.display = "flex";
}

function hideLoader() {
    const loader = document.getElementById("ajax-loader");
    if (loader) loader.style.display = "none";
}
