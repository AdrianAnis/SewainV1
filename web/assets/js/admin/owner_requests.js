async function approveRequest(requestId) {
    if (!(await SewainAlert.confirm("Apakah Anda yakin ingin menyetujui permintaan menjadi Owner ini?", "Konfirmasi Persetujuan", "info"))) return;

    showSpinner();

    const params = new URLSearchParams();
    params.append("action", "approve");
    params.append("requestId", requestId);

    fetch(`${window.contextPath}/admin/owner-requests`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params
    })
    .then(response => {
        if(response.redirected) {
            window.location.href = response.url;
            return null;
        }
        return response.json().catch(() => ({ success: true }));
    })
    .then(data => {
        if (!data) return; 
        hideSpinner();
        window.location.reload();
    })
    .catch(error => {
        hideSpinner();
        console.error("Error approving request:", error);
        SewainAlert.error("Terjadi kesalahan koneksi server.");
    });
}

function openRejectModal(requestId) {
    document.getElementById("reject-request-id").value = requestId;
    document.getElementById("reject-reason").value = "";
    document.getElementById("reject-modal").style.display = "flex";
}

function closeRejectModal() {
    document.getElementById("reject-modal").style.display = "none";
}

function executeReject(event) {
    event.preventDefault();

    const requestId = document.getElementById("reject-request-id").value;
    const reason = document.getElementById("reject-reason").value.trim();

    closeRejectModal();
    showSpinner();

    const params = new URLSearchParams();
    params.append("action", "reject");
    params.append("requestId", requestId);
    params.append("rejectReason", reason);

    fetch(`${window.contextPath}/admin/owner-requests`, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params
    })
    .then(response => {
        if(response.redirected) {
            window.location.href = response.url;
            return null;
        }
        return response.json().catch(() => ({ success: true }));
    })
    .then(data => {
        if (!data) return; 
        hideSpinner();
        window.location.reload();
    })
    .catch(error => {
        hideSpinner();
        console.error("Error rejecting request:", error);
        SewainAlert.error("Terjadi kesalahan koneksi server.");
    });
}

function viewKtpFull(url) {
    if (!url) return;
    window.open(url, '_blank');
}

function showSpinner() {
    const loader = document.getElementById("ajax-loader");
    if (loader) loader.style.display = "flex";
}

function hideSpinner() {
    const loader = document.getElementById("ajax-loader");
    if (loader) loader.style.display = "none";
}
