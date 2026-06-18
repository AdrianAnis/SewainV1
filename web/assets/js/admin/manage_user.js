document.addEventListener("DOMContentLoaded", () => {

    // Initial counter update
    updateUserCount();
});


function updateUserCount(count = null) {
    const badge = document.getElementById("user-count-badge");
    if (!badge) return;

    if (count === null) {
        count = document.querySelectorAll(".user-row").length;
    }
    badge.textContent = `${count} Pengguna`;
}

// 2. User Detail Modal
function showUserDetail(userId) {
    const row = document.querySelector(`.user-row[data-id="${userId}"]`);
    if (!row) return;

    const name = row.getAttribute("data-name");
    const email = row.getAttribute("data-email");
    const phone = row.getAttribute("data-phone");
    const role = row.getAttribute("data-role");
    const status = row.getAttribute("data-status");

    // Populate modal fields
    document.getElementById("detail-id").textContent = userId;
    document.getElementById("detail-name").textContent = name;
    document.getElementById("detail-email").textContent = email;
    document.getElementById("detail-phone").textContent = phone;
    
    const roleBadge = document.getElementById("detail-role-badge");
    roleBadge.textContent = role;
    roleBadge.className = `role-badge role-${role.toLowerCase()}`;

    const statusBadge = document.getElementById("detail-status");
    statusBadge.textContent = status;
    statusBadge.className = `status-badge status-${status.toLowerCase()}`;

    // Open Modal
    document.getElementById("detail-modal").style.display = "flex";
}

function closeDetailModal() {
    document.getElementById("detail-modal").style.display = "none";
}

// 3. User Suspend / Activate Action Handling via AJAX
let activeActionUserId = null;
let activeActionStatus = null;

function confirmToggleStatus(userId, targetStatus) {
    activeActionUserId = userId;
    activeActionStatus = targetStatus;

    const row = document.querySelector(`.user-row[data-id="${userId}"]`);
    const name = row ? row.getAttribute("data-name") : "pengguna ini";
    const statusText = targetStatus === "Suspended" ? "menangguhkan (suspend)" : "mengaktifkan kembali";
    
    document.getElementById("confirm-title").textContent = targetStatus === "Suspended" ? "Suspend Pengguna" : "Aktifkan Pengguna";
    document.getElementById("confirm-message").textContent = `Apakah Anda yakin ingin ${statusText} akun untuk "${name}"?`;
    
    const submitBtn = document.getElementById("confirm-submit-btn");
    if (targetStatus === "Suspended") {
        submitBtn.className = "btn-primary btn-danger";
        submitBtn.textContent = "Ya, Suspend";
    } else {
        submitBtn.className = "btn-primary btn-activate";
        submitBtn.textContent = "Ya, Aktifkan";
    }

    // Set submit button action
    submitBtn.onclick = executeToggleStatus;

    // Show Confirmation Modal
    document.getElementById("confirm-modal").style.display = "flex";
}

function closeConfirmModal() {
    document.getElementById("confirm-modal").style.display = "none";
    activeActionUserId = null;
    activeActionStatus = null;
}

function executeToggleStatus() {
    if (!activeActionUserId || !activeActionStatus) return;
    
    closeConfirmModal();
    showLoaderSpinner();

    // Prepare parameters for POST request
    const params = new URLSearchParams();
    params.append("action", "toggleStatus");
    params.append("userId", activeActionUserId);
    params.append("status", activeActionStatus);

    fetch(`${window.contextPath}/admin/users`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        hideLoaderSpinner();
        if (data.success) {
            updateRowUI(activeActionUserId, activeActionStatus);
            SewainAlert.success("Status pengguna berhasil diperbarui.");
        } else {
            SewainAlert.error(data.message || "Gagal memperbarui status pengguna.");
        }
    })
    .catch(error => {
        hideLoaderSpinner();
        console.error("Error toggling status:", error);
        SewainAlert.error("Terjadi kesalahan koneksi server.");
    });
}

function updateRowUI(userId, newStatus) {
    const row = document.querySelector(`.user-row[data-id="${userId}"]`);
    if (!row) return;

    // 1. Update data attribute
    row.setAttribute("data-status", newStatus);

    // 2. Update status badge TD
    const statusBadge = row.querySelector(".status-badge");
    if (statusBadge) {
        statusBadge.textContent = newStatus;
        statusBadge.className = `status-badge status-${newStatus.toLowerCase()}`;
    }

    // 3. Update action buttons container
    const actionCell = row.querySelector(".action-buttons");
    if (actionCell) {
        const detailBtnHtml = `<button class="btn-action btn-detail" onclick="showUserDetail('${userId}')" title="Detail Pengguna"><i class="fa-solid fa-eye"></i></button>`;
        let toggleBtnHtml = "";
        
        if (newStatus.toLowerCase() === "suspended") {
            toggleBtnHtml = `<button class="btn-action btn-activate" onclick="confirmToggleStatus('${userId}', 'Active')" title="Aktifkan Akun"><i class="fa-solid fa-user-check"></i></button>`;
        } else {
            toggleBtnHtml = `<button class="btn-action btn-suspend" onclick="confirmToggleStatus('${userId}', 'Suspended')" title="Tangguhkan Akun"><i class="fa-solid fa-user-minus"></i></button>`;
        }
        actionCell.innerHTML = detailBtnHtml + " " + toggleBtnHtml;
    }

}

function showLoaderSpinner() {
    const loader = document.getElementById("ajax-loader");
    if (loader) loader.style.display = "flex";
}

function hideLoaderSpinner() {
    const loader = document.getElementById("ajax-loader");
    if (loader) loader.style.display = "none";
}
