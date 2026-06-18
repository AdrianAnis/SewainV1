document.addEventListener("DOMContentLoaded", () => {
    // Client-Side Pagination setup
    initPagination();
});

const ROWS_PER_PAGE = 10;
let currentPage = 1;
let rows = [];

function initPagination() {
    rows = Array.from(document.querySelectorAll(".log-row"));
    if (rows.length === 0) return;

    const totalPages = Math.ceil(rows.length / ROWS_PER_PAGE);

    // Only show pagination if there are more rows than limit
    const paginationControls = document.getElementById("pagination-controls");
    if (rows.length > ROWS_PER_PAGE) {
        if (paginationControls) paginationControls.style.display = "flex";
        
        const btnPrev = document.getElementById("btn-prev");
        const btnNext = document.getElementById("btn-next");

        if (btnPrev) btnPrev.addEventListener("click", () => changePage(currentPage - 1));
        if (btnNext) btnNext.addEventListener("click", () => changePage(currentPage + 1));

        changePage(1);
    } else {
        if (paginationControls) paginationControls.style.display = "none";
    }
}

function changePage(page) {
    const totalPages = Math.ceil(rows.length / ROWS_PER_PAGE);
    
    // Boundary check
    if (page < 1) page = 1;
    if (page > totalPages) page = totalPages;

    currentPage = page;

    // Show/hide matching rows
    const startIdx = (currentPage - 1) * ROWS_PER_PAGE;
    const endIdx = startIdx + ROWS_PER_PAGE;

    rows.forEach((row, index) => {
        if (index >= startIdx && index < endIdx) {
            row.style.display = "";
        } else {
            row.style.display = "none";
        }
    });

    // Update Pagination Info UI
    const infoSpan = document.getElementById("pagination-info");
    if (infoSpan) {
        infoSpan.textContent = `Halaman ${currentPage} dari ${totalPages}`;
    }

    // Update Button Disabled States
    const btnPrev = document.getElementById("btn-prev");
    const btnNext = document.getElementById("btn-next");

    if (btnPrev) btnPrev.disabled = (currentPage === 1);
    if (btnNext) btnNext.disabled = (currentPage === totalPages);
}
