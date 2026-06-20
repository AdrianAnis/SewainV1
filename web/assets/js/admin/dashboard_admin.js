document.addEventListener("DOMContentLoaded", () => {
    updateHeaderDate();
    setInterval(updateSystemTime, 1000);
    updateSystemTime();

    window.showLoader = () => {
        const loader = document.getElementById("ajax-loader");
        if (loader) loader.style.display = "flex";
    };

    window.hideLoader = () => {
        const loader = document.getElementById("ajax-loader");
        if (loader) loader.style.display = "none";
    };
});

function updateHeaderDate() {
    const dateEl = document.getElementById("current-date");
    if (!dateEl) return;

    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    const today = new Date();

    try {
        dateEl.textContent = today.toLocaleDateString("id-ID", options);
    } catch (e) {
        dateEl.textContent = today.toDateString();
    }
}

function updateSystemTime() {
    const timeEl = document.getElementById("system-time");
    if (!timeEl) return;

    const now = new Date();
    let hours = now.getHours().toString().padStart(2, '0');
    let minutes = now.getMinutes().toString().padStart(2, '0');
    let seconds = now.getSeconds().toString().padStart(2, '0');

    timeEl.innerHTML = `<i class="fa-regular fa-clock"></i> ${hours}:${minutes}:${seconds}`;
}


const rowsPerPage = 10;
let currentPage = 1;
let tableRows;
let paginationControls;
let btnPrev;
let btnNext;
let paginationInfo;

function initPagination() {
    tableRows = document.querySelectorAll('.log-row');
    paginationControls = document.getElementById('pagination-controls');
    btnPrev = document.getElementById('btn-prev');
    btnNext = document.getElementById('btn-next');
    paginationInfo = document.getElementById('pagination-info');

    if (!paginationControls) return;

    paginationControls.style.display = 'flex';
    
    if (tableRows.length === 0) {
        if (paginationInfo) paginationInfo.textContent = `Halaman 0 dari 0`;
        if (btnPrev) btnPrev.disabled = true;
        if (btnNext) btnNext.disabled = true;
        return;
    }

    showPage(currentPage);

    if (btnPrev && btnNext) {
        btnPrev.addEventListener('click', () => {
            if (currentPage > 1) {
                currentPage--;
                showPage(currentPage);
            }
        });

        btnNext.addEventListener('click', () => {
            const totalPages = Math.ceil(tableRows.length / rowsPerPage);
            if (currentPage < totalPages) {
                currentPage++;
                showPage(currentPage);
            }
        });
    }
}

function showPage(page) {
    const totalPages = Math.ceil(tableRows.length / rowsPerPage);
    const startIdx = (page - 1) * rowsPerPage;
    const endIdx = startIdx + rowsPerPage;

    tableRows.forEach((row, index) => {
        if (index >= startIdx && index < endIdx) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });

    if (paginationInfo) {
        paginationInfo.textContent = `Halaman ${page} dari ${totalPages}`;
    }

    if (btnPrev) {
        btnPrev.disabled = page === 1;
    }

    if (btnNext) {
        btnNext.disabled = page === totalPages;
    }
}

document.addEventListener("DOMContentLoaded", initPagination);
