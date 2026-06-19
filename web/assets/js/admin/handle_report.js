document.addEventListener("DOMContentLoaded", () => {

    updateReportCount();
});


function updateReportCount(count = null) {
    const badge = document.getElementById("report-count-badge");
    if (!badge) return;

    if (count === null) {
        count = document.querySelectorAll(".report-row").length;
    }
    badge.textContent = `${count} Laporan`;
}

async function resolveReport(reportId) {
    if (!(await SewainAlert.confirm("Apakah Anda yakin ingin menandai laporan ini sebagai SELESAI?"))) return;

    showLoader();

    const params = new URLSearchParams();
    params.append("action", "resolveReport");
    params.append("reportId", reportId);

    fetch(`${window.contextPath}/admin/reports`, {
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
                updateReportRowStatus(reportId, "Resolved");
                SewainAlert.success("Laporan berhasil diselesaikan.");
            } else {
                SewainAlert.error(data.message || "Gagal menyelesaikan laporan.");
            }
        })
        .catch(error => {
            hideLoader();
            console.error("Error resolving report:", error);
            SewainAlert.error("Terjadi kesalahan koneksi server.");
        });
}

function updateReportRowStatus(reportId, newStatus) {
    const row = document.querySelector(`.report-row[data-id="${reportId}"]`);
    if (!row) return;

    row.setAttribute("data-status", newStatus);

    const statusBadge = row.querySelector(".status-badge");
    if (statusBadge) {
        statusBadge.textContent = newStatus;
        statusBadge.className = `status-badge status-${newStatus.toLowerCase()}`;
    }

    const actionCell = row.querySelector(".action-buttons");
    if (actionCell) {
        actionCell.innerHTML = `<span class="text-success text-xs font-bold"><i class="fa-solid fa-circle-check"></i> Selesai</span>`;
    }

}

function openFlagModal(propertyId, propertyName, reportId) {
    document.getElementById("flag-property-id").value = propertyId;
    document.getElementById("flag-report-id").value = reportId;
    document.getElementById("flag-prop-display-name").textContent = propertyName;
    document.getElementById("flag-reason").value = "";
    document.getElementById("flag-modal").style.display = "flex";
}

function closeFlagModal() {
    document.getElementById("flag-modal").style.display = "none";
}

function executeFlag(event) {
    event.preventDefault();

    const propertyId = document.getElementById("flag-property-id").value;
    const reportId = document.getElementById("flag-report-id").value;
    const reason = document.getElementById("flag-reason").value.trim();

    closeFlagModal();
    showLoader();

    const params = new URLSearchParams();
    params.append("action", "flagProperty");
    params.append("propertyId", propertyId);
    params.append("reportId", reportId);
    params.append("reason", reason);

    fetch(`${window.contextPath}/admin/reports`, {
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
                SewainAlert.success("Properti berhasil ditandai (flagged) dan ditangguhkan.").then(() => {
                    window.location.reload();
                });
            } else {
                SewainAlert.error(data.message || "Gagal menandai properti.");
            }
        })
        .catch(error => {
            hideLoader();
            console.error("Error flagging property:", error);
            SewainAlert.error("Terjadi kesalahan koneksi server.");
        });
}

function showLoader() {
    const loader = document.getElementById("ajax-loader");
    if (loader) loader.style.display = "flex";
}

function hideLoader() {
    const loader = document.getElementById("ajax-loader");
    if (loader) loader.style.display = "none";
}
