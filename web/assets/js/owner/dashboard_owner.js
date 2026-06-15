document.addEventListener("DOMContentLoaded", function () {
    const ITEMS_PER_PAGE = 6;
    let currentPage = 1;
    const grid = document.querySelector(".property-grid");
    const paginationEl = document.getElementById("ownerPagination");
    const allCards = grid ? Array.from(grid.querySelectorAll(".property-card")) : [];

    function showPage(page) {
        currentPage = page;
        const totalPages = Math.ceil(allCards.length / ITEMS_PER_PAGE);
        if (currentPage > totalPages) currentPage = totalPages;
        if (currentPage < 1) currentPage = 1;
        const start = (currentPage - 1) * ITEMS_PER_PAGE;
        const end = start + ITEMS_PER_PAGE;

        allCards.forEach(function(card, idx) {
            card.style.display = (idx >= start && idx < end) ? "" : "none";
        });

        renderOwnerPagination(totalPages);
    }

    function renderOwnerPagination(totalPages) {
        if (!paginationEl) return;
        if (totalPages <= 1) {
            paginationEl.style.display = "none";
            return;
        }
        paginationEl.style.display = "flex";
        paginationEl.innerHTML = "";

        const prev = document.createElement("a");
        prev.href = "#";
        prev.className = "page-link" + (currentPage <= 1 ? " disabled" : "");
        prev.innerHTML = "&lt;";
        prev.addEventListener("click", function(e) {
            e.preventDefault();
            if (currentPage > 1) {
                showPage(currentPage - 1);
                if (grid) window.scrollTo({ top: grid.offsetTop - 100, behavior: "smooth" });
            }
        });
        paginationEl.appendChild(prev);

        for (let i = 1; i <= totalPages; i++) {
            (function(pageNum) {
                const link = document.createElement("a");
                link.href = "#";
                link.className = "page-link" + (pageNum === currentPage ? " active" : "");
                link.textContent = pageNum;
                link.addEventListener("click", function(e) {
                    e.preventDefault();
                    showPage(pageNum);
                    if (grid) window.scrollTo({ top: grid.offsetTop - 100, behavior: "smooth" });
                });
                paginationEl.appendChild(link);
            })(i);
        }

        const next = document.createElement("a");
        next.href = "#";
        next.className = "page-link" + (currentPage >= totalPages ? " disabled" : "");
        next.innerHTML = "&gt;";
        next.addEventListener("click", function(e) {
            e.preventDefault();
            if (currentPage < totalPages) {
                showPage(currentPage + 1);
                if (grid) window.scrollTo({ top: grid.offsetTop - 100, behavior: "smooth" });
            }
        });
        paginationEl.appendChild(next);
    }

    if (allCards.length > 0) {
        showPage(1);
    }

    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('deleted') === 'true') {
        Swal.fire({
            title: 'Berhasil!',
            text: 'Properti berhasil dihapus secara permanen.',
            icon: 'success',
            confirmButtonColor: '#10b981'
        });
        window.history.replaceState({}, document.title, window.location.pathname);
    }
});

window.openDashboardDeleteModal = function(propertyId, propertyName) {
    const deleteIdInput = document.getElementById('dashboardDeletePropertyId');
    const deleteNameEl = document.getElementById('dashboardDeleteName');
    const deleteModal = document.getElementById('dashboardDeleteModal');
    if (deleteIdInput && deleteNameEl && deleteModal) {
        deleteIdInput.value = propertyId;
        deleteNameEl.textContent = propertyName;
        deleteModal.style.display = 'flex';
    }
};