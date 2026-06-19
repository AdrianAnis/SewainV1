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
