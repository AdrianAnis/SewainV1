document.addEventListener("DOMContentLoaded", function() {
    const form = document.getElementById("profileForm");
    const saveBtn = document.getElementById("saveBtn");
    const alertBox = document.getElementById("alertBox");
    const displayName = document.getElementById("displayName");
    const ctx = window.contextPath || "";

    if (form) {
        form.addEventListener("submit", async function (e) {
            e.preventDefault();
            const name  = document.getElementById("nameInput").value.trim();
            const phone = document.getElementById("phoneInput").value.trim();

            if (!name) {
                showAlert("error", "Nama tidak boleh kosong.");
                return;
            }

            saveBtn.disabled = true;
            saveBtn.textContent = "Menyimpan...";

            try {
                const res = await fetch(ctx + "/profile", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: "name=" + encodeURIComponent(name) + "&phone=" + encodeURIComponent(phone)
                });
                const data = await res.json();

                if (data.success) {
                    showAlert("success", data.message);
                    displayName.textContent = data.name || name;
                } else {
                    showAlert("error", data.message || "Gagal menyimpan.");
                }
            } catch (err) {
                showAlert("error", "Terjadi kesalahan jaringan.");
            } finally {
                saveBtn.disabled = false;
                saveBtn.innerHTML = `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/>
                    <polyline points="17 21 17 13 7 13 7 21"/>
                    <polyline points="7 3 7 8 15 8"/>
                    </svg> Simpan Perubahan`;
            }
        });
    }

    function showAlert(type, message) {
        alertBox.className = "alert-box " + (type === "success" ? "alert-success" : "alert-error");
        alertBox.textContent = message;
        alertBox.style.display = "block";
        setTimeout(() => { alertBox.style.display = "none"; }, 4000);
    }
});
