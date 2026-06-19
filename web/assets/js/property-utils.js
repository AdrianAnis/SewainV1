// Digunakan oleh: detail.jsp, detail_owner.jsp, dashboard.js

window.PropertyUtils = {

    resolvePropertyImage: function (photoStr) {
        const ctxPath = window.contextPath || "";
        const defaultImg = ctxPath + "/assets/images/default-property.jpg";
        if (!photoStr || typeof photoStr !== 'string') return defaultImg;
        let trimmed = photoStr.trim();
        if (trimmed === "" || trimmed === "null" || trimmed === "[]") return defaultImg;
        let parts = trimmed.split(',');
        if (parts.length === 0 || !parts[0]) return defaultImg;
        let photo = parts[0].trim();
        if (photo === "" || photo === "null") return defaultImg;
        if (photo.startsWith("http://") || photo.startsWith("https://")) return photo;
        if (photo.startsWith(ctxPath + "/uploads/")) return photo;
        if (photo.startsWith("/uploads/")) return ctxPath + photo;
        if (photo.startsWith("/")) return photo;
        if (photo.startsWith("uploads/")) return ctxPath + "/" + photo;
        return ctxPath + "/uploads/" + photo;
    },

    getCoverImage: function (rawPhotos) {
        return this.resolvePropertyImage(rawPhotos);
    },

    resolveAllPhotos: function (rawImageString) {
        const ctxPath = window.contextPath || "";
        const defaultImg = ctxPath + "/assets/images/default-property.jpg";
        let photosArr = rawImageString ? rawImageString.split(',').map(s => s.trim()).filter(s => s) : [];
        if (photosArr.length === 0) photosArr.push(defaultImg);
        return photosArr.map(p => this.resolvePropertyImage(p));
    }
};

window.resolvePropertyImage = window.PropertyUtils.resolvePropertyImage.bind(window.PropertyUtils);
window.getCoverImage = window.PropertyUtils.getCoverImage.bind(window.PropertyUtils);
