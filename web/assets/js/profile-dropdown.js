document.addEventListener("DOMContentLoaded", function () {
    const avatarBtn = document.getElementById("avatarBtn");
    const profileDropdown = document.getElementById("profileDropdown");

    if (avatarBtn && profileDropdown) {
        avatarBtn.addEventListener("click", function (e) {
            e.stopPropagation();
            const isVisible = profileDropdown.style.display === "flex";
            profileDropdown.style.display = isVisible ? "none" : "flex";
        });

        document.addEventListener("click", function (e) {
            if (!profileDropdown.contains(e.target) && !e.target.closest("#avatarBtn")) {
                profileDropdown.style.display = "none";
            }
        });
    }
});
