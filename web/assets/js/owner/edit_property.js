let selectedGalleryFiles = [];

document.getElementById('propertyForm').addEventListener('submit', function (e) {
    e.preventDefault();

    const formElement = document.getElementById('propertyForm');

    const requiredInputs = formElement.querySelectorAll('input[required], select[required], textarea[required]');
    let isValid = true;

    formElement.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));

    requiredInputs.forEach(input => {
        if (!input.value.trim()) {
            isValid = false;
            if (input.type === 'hidden' && input.nextElementSibling && input.nextElementSibling.classList.contains('custom-select-trigger')) {
                input.nextElementSibling.classList.add('is-invalid');
            } else {
                input.classList.add('is-invalid');
            }
        }
    });

    if (!isValid) {
        Swal.fire({
            title: 'Formulir Belum Lengkap',
            text: 'Silakan isi semua kolom wajib sebelum menyimpan.',
            icon: 'warning',
            confirmButtonColor: 'var(--deep)'
        });
        return;
    }

    const activeFacilities = [];
    document.querySelectorAll('.fac-card.selected').forEach(card => {
        activeFacilities.push(card.getAttribute('data-value'));
    });
    document.querySelectorAll('.custom-fac-badge').forEach(badge => {
        activeFacilities.push(badge.getAttribute('data-value'));
    });
    document.getElementById('facilitiesInput').value = activeFacilities.join(', ');

    const propertyForm = document.getElementById('propertyForm');
    const originalPhotosStr = propertyForm ? (propertyForm.dataset.photos || "") : "";
    const originalPhotosArr = originalPhotosStr ? originalPhotosStr.split(',').map(p => p.trim()) : [];
    const coverPreview = document.getElementById('coverPreview');
    const coverInput = document.getElementById('coverPhotoInput');

    if (coverPreview.style.display === 'block' && (!coverInput.files || coverInput.files.length === 0)) {
        if (originalPhotosArr.length > 0) {
            existingPhotosList.push(originalPhotosArr[0]);
        }
    }

    selectedGalleryFiles.forEach(itemObj => {
        if (itemObj.isExisting) {
            existingPhotosList.push(itemObj.originalUrl);
        }
    });
    document.getElementById('existingPhotosInput').value = existingPhotosList.join(',');

    const galleryInput = document.getElementById('galleryInput');
    if (galleryInput) {
        const dt = new DataTransfer();
        selectedGalleryFiles.forEach(itemObj => {
            if (!itemObj.isExisting) {
                dt.items.add(itemObj.file);
            }
        });
        galleryInput.files = dt.files;
    }

    const loadingOverlay = document.getElementById('loadingOverlay');
    loadingOverlay.classList.add('active');

    const formData = new FormData(formElement);

    fetch(formElement.action, {
        method: 'POST',
        body: formData,
        headers: {
            'Accept': 'application/json'
        }
    })
        .then(response => response.json())
        .then(data => {
            loadingOverlay.classList.remove('active');
            if (data.success) {
                Swal.fire({
                    title: 'Berhasil!',
                    text: 'Perubahan properti berhasil disimpan.',
                    icon: 'success',
                    confirmButtonColor: 'var(--deep)',
                    confirmButtonText: 'Selesai'
                }).then((result) => {
                    window.location.href = window.contextPath + '/owner/detail?propertyId=' + data.propertyId + '&updated=true';
                });
            } else {
                Swal.fire({
                    title: 'Gagal!',
                    text: data.message || 'Gagal menyimpan perubahan.',
                    icon: 'error',
                    confirmButtonColor: 'var(--deep)'
                });
            }
        })
        .catch(error => {
            loadingOverlay.classList.remove('active');
            Swal.fire({
                title: 'Kesalahan Sistem',
                text: 'Tidak dapat terhubung ke server.',
                icon: 'error',
                confirmButtonColor: 'var(--deep)'
            });
            console.error('Error:', error);
        });
});

document.addEventListener('input', function (e) {
    if (e.target.classList.contains('form-control')) {
        e.target.classList.remove('is-invalid');
    }
});

function toggleDropdown(triggerElement) {
    document.querySelectorAll('.custom-select-container.open').forEach(el => {
        if (el !== triggerElement.parentElement) {
            el.classList.remove('open');
        }
    });
    triggerElement.parentElement.classList.toggle('open');
}

function selectOption(optionElement, value) {
    const container = optionElement.closest('.custom-select-container');
    const hiddenInput = container.querySelector('input[type="hidden"]');
    const trigger = container.querySelector('.custom-select-trigger');
    const triggerText = trigger.querySelector('span');

    hiddenInput.value = value;
    triggerText.textContent = optionElement.textContent;

    trigger.classList.add('has-value');
    trigger.classList.remove('is-invalid');
    container.classList.remove('open');

    container.querySelectorAll('.custom-select-option').forEach(opt => opt.classList.remove('selected'));
    optionElement.classList.add('selected');
}

document.addEventListener('click', function (e) {
    if (!e.target.closest('.custom-select-container')) {
        document.querySelectorAll('.custom-select-container.open').forEach(el => {
            el.classList.remove('open');
        });
    }
});

function selectGender(element, value) {
    const container = element.closest('.segmented-control');
    const hiddenInput = container.querySelector('input[type="hidden"]');
    hiddenInput.value = value;
    container.querySelectorAll('.segment-btn').forEach(btn => btn.classList.remove('active'));
    element.classList.add('active');
}

function toggleFacility(element) {
    element.classList.toggle('selected');
}

function addCustomFacility() {
    const input = document.getElementById('customFacInput');
    const value = input.value.trim();
    if (value) {
        addCustomBadge(value);
        input.value = '';
    }
}

function addCustomBadge(value) {
    const container = document.getElementById('customFacBadges');
    const existing = Array.from(container.children).find(b => b.getAttribute('data-value').toLowerCase() === value.toLowerCase());
    if (existing) return;

    const badge = document.createElement('div');
    badge.className = 'custom-fac-badge';
    badge.setAttribute('data-value', value);

    const textSpan = document.createElement('span');
    textSpan.textContent = value;
    badge.appendChild(textSpan);

    const btn = document.createElement('button');
    btn.type = 'button';
    btn.innerHTML = '<i class="fa-solid fa-xmark"></i>';
    btn.onclick = function () { this.parentElement.remove(); };
    badge.appendChild(btn);

    container.appendChild(badge);
}

document.getElementById('customFacInput').addEventListener('keypress', function (e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        addCustomFacility();
    }
});

const coverInput = document.getElementById('coverPhotoInput');
const coverPreview = document.getElementById('coverPreview');
const coverPlaceholder = document.getElementById('coverPlaceholder');
const removeCoverBtn = document.getElementById('removeCoverBtn');
const coverDropzone = document.getElementById('coverDropzone');
let currentCoverUrl = null;

if (coverInput) {
    coverInput.addEventListener('change', function (e) {
        if (this.files && this.files[0]) {
            if (currentCoverUrl && !currentCoverUrl.startsWith('http')) {
                URL.revokeObjectURL(currentCoverUrl);
            }
            currentCoverUrl = URL.createObjectURL(this.files[0]);
            coverPreview.src = currentCoverUrl;
            coverPreview.style.display = 'block';
            coverPlaceholder.style.display = 'none';
            removeCoverBtn.style.display = 'flex';
            coverDropzone.style.borderStyle = 'solid';
        }
    });
}

function removeCoverPhoto(e) {
    e.stopPropagation();
    if (currentCoverUrl && !currentCoverUrl.startsWith('http')) {
        URL.revokeObjectURL(currentCoverUrl);
    }
    currentCoverUrl = null;
    coverInput.value = '';
    coverPreview.src = '';
    coverPreview.style.display = 'none';
    coverPlaceholder.style.display = 'block';
    removeCoverBtn.style.display = 'none';
    coverDropzone.style.borderStyle = 'dashed';
}

const galleryInput = document.getElementById('galleryInput');
const galleryGrid = document.getElementById('galleryGrid');

if (galleryInput) {
    galleryInput.addEventListener('change', function (e) {
        if (!this.files || this.files.length === 0) return;

        Array.from(this.files).forEach(file => {
            if (selectedGalleryFiles.length < 5) {
                const objectURL = URL.createObjectURL(file);
                selectedGalleryFiles.push({
                    isExisting: false,
                    file: file,
                    url: objectURL
                });
            }
        });

        this.value = '';
        renderGallery();
    });
}

function renderGallery() {
    if (!galleryGrid) return;
    galleryGrid.innerHTML = '';

    const addBtn = document.createElement('div');
    addBtn.className = 'gallery-add';
    addBtn.onclick = () => document.getElementById('galleryInput').click();
    addBtn.innerHTML = '<i class="fa-regular fa-image" style="font-size: 24px;"></i>Add Photos';
    galleryGrid.appendChild(addBtn);

    selectedGalleryFiles.forEach((itemObj, index) => {
        const item = document.createElement('div');
        item.className = 'gallery-item';

        const imgElement = document.createElement('img');
        imgElement.src = itemObj.url;
        imgElement.alt = "Gallery Preview " + (index + 1);
        imgElement.style.width = "100%";
        imgElement.style.height = "100%";
        imgElement.style.objectFit = "cover";

        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'remove-gallery-btn';
        btn.onclick = function (e) { removeGalleryPhoto(index, e); };
        btn.innerHTML = '<i class="fa-solid fa-xmark"></i>';

        item.appendChild(imgElement);
        item.appendChild(btn);

        galleryGrid.appendChild(item);
    });

    const placeholdersNeeded = Math.max(0, 3 - selectedGalleryFiles.length);
    for (let i = 0; i < placeholdersNeeded; i++) {
        const placeholder = document.createElement('div');
        placeholder.className = 'gallery-placeholder';
        placeholder.innerHTML = '<i class="fa-solid fa-image" style="font-size: 24px;"></i>';
        galleryGrid.appendChild(placeholder);
    }
}

function removeGalleryPhoto(index, e) {
    e.stopPropagation();
    if (!selectedGalleryFiles[index].isExisting) {
        URL.revokeObjectURL(selectedGalleryFiles[index].url);
    }
    selectedGalleryFiles.splice(index, 1);
    renderGallery();
}

document.addEventListener("DOMContentLoaded", function () {
    const propertyForm = document.getElementById('propertyForm');
    const facilitiesStr = propertyForm ? (propertyForm.dataset.facilities || "") : "";
    if (facilitiesStr) {
        const facList = facilitiesStr.split(',').map(f => f.trim());
        facList.forEach(fac => {
            const card = document.querySelector(`.fac-card[data-value="${fac}"]`);
            if (card) {
                card.classList.add('selected');
            } else if (fac) {
                addCustomBadge(fac);
            }
        });
    }

    const originalPhotos = propertyForm ? (propertyForm.dataset.photos || "") : "";
    if (originalPhotos && originalPhotos.trim() !== "") {
        const photosArr = originalPhotos.split(',').map(p => p.trim());

        if (photosArr.length > 0 && photosArr[0]) {
            const url = getResolvedUrl(photosArr[0]);
            currentCoverUrl = url;
            coverPreview.src = url;
            coverPreview.style.display = 'block';
            coverPlaceholder.style.display = 'none';
            removeCoverBtn.style.display = 'flex';
            coverDropzone.style.borderStyle = 'solid';
        }

        for (let i = 1; i < photosArr.length; i++) {
            if (photosArr[i]) {
                const url = getResolvedUrl(photosArr[i]);
                selectedGalleryFiles.push({
                    isExisting: true,
                    url: url,
                    originalUrl: photosArr[i]
                });
            }
        }
        renderGallery();
    }
});

function getResolvedUrl(path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
        return path;
    } else if (path.startsWith('/uploads/')) {
        return window.contextPath + path;
    } else if (path.startsWith('/')) {
        return path;
    } else {
        return window.contextPath + '/uploads/' + path;
    }
}
