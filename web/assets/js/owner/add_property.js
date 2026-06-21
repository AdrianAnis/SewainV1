

let currentStep = 1;
let selectedGalleryFiles = [];

window.goToStep = function (step) {
    if (step > currentStep) {
        const currentContainer = document.getElementById('step' + currentStep);
        const requiredInputs = currentContainer.querySelectorAll('input[required], select[required], textarea[required]');
        let isValid = true;

        currentContainer.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));

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
            SewainAlert.alert("Please fill in all required fields before proceeding.", "Incomplete Form", "warning");
            return;
        }
    }

    for (let i = 1; i <= 3; i++) {
        document.getElementById('step' + i).style.display = 'none';
        document.getElementById('ind-' + i).classList.remove('active');
    }

    document.getElementById('step' + step).style.display = 'block';
    for (let i = 1; i <= step; i++) {
        document.getElementById('ind-' + i).classList.add('active');
    }

    currentStep = step;
    window.scrollTo({ top: 0, behavior: 'smooth' });
};

window.selectType = function (type) {
    document.getElementById('propertyTypeInput').value = type;

    document.querySelectorAll('.type-selector .type-btn').forEach(btn => {
        btn.classList.remove('active');
        if (btn.textContent.trim() === type) {
            btn.classList.add('active');
        }
    });

    const sfContainer = document.getElementById('specificFields');
    sfContainer.style.display = 'block';

    let html = '';
    if (type === 'Kost') {
        html = `
            <div class="grid-2">
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label">Gender Type</label>
                    <div class="segmented-control">
                        <input type="hidden" name="gender" id="genderInput" value="Male" required>
                        <div class="segment-btn active" onclick="selectGender(this, 'Male')">Male</div>
                        <div class="segment-btn" onclick="selectGender(this, 'Female')">Female</div>
                        <div class="segment-btn" onclick="selectGender(this, 'Mixed')">Mixed</div>
                    </div>
                </div>
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label">Room Type</label>
                    <div class="custom-select-container">
                        <input type="hidden" name="roomType" required>
                        <div class="custom-select-trigger" onclick="toggleDropdown(this)">
                            <span>Select Room Type</span>
                            <i class="fa-solid fa-chevron-down"></i>
                        </div>
                        <div class="custom-select-options">
                            <div class="custom-select-option" onclick="selectOption(this, 'Standar Room')">Standar Room</div>
                            <div class="custom-select-option" onclick="selectOption(this, 'Deluxe Room')">Deluxe Room</div>
                            <div class="custom-select-option" onclick="selectOption(this, 'VIP')">VIP</div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    } else if (type === 'Rumah') {
        html = `
            <div class="grid-2">
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label">Jumlah Kamar</label>
                    <input type="number" name="jumlahKamar" class="form-control" placeholder="0" required>
                </div>
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label">Luas Tanah (m²)</label>
                    <input type="number" step="0.01" name="luasTanah" class="form-control" placeholder="0.0" required>
                </div>
            </div>
        `;
    } else if (type === 'Kontrakan') {
        html = `
            <div class="grid-2">
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label">Durasi Minimum (Bulan)</label>
                    <input type="number" name="durasiMinimum" class="form-control" placeholder="Misal: 12" required>
                </div>
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label">Jumlah Kamar</label>
                    <input type="number" name="jumlahKamar" class="form-control" placeholder="0" required>
                </div>
            </div>
        `;
    } else if (type === 'Apartement' || type === 'Apartemen') {
        html = `
            <div class="grid-3">
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label">Floor Number</label>
                    <input type="number" name="lantai" class="form-control" placeholder="0" required>
                </div>
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label">Unit Number</label>
                    <input type="text" name="nomorUnit" class="form-control" placeholder="A-102" required>
                </div>
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label">Unit Type</label>
                    <div class="custom-select-container">
                        <input type="hidden" name="tipeUnit" required>
                        <div class="custom-select-trigger" onclick="toggleDropdown(this)">
                            <span>Select Unit Type</span>
                            <i class="fa-solid fa-chevron-down"></i>
                        </div>
                        <div class="custom-select-options">
                            <div class="custom-select-option" onclick="selectOption(this, 'Studio')">Studio</div>
                            <div class="custom-select-option" onclick="selectOption(this, '1BR')">1 Bedroom (1BR)</div>
                            <div class="custom-select-option" onclick="selectOption(this, '2BR')">2 Bedroom (2BR)</div>
                            <div class="custom-select-option" onclick="selectOption(this, 'Penthouse')">Penthouse</div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }
    sfContainer.innerHTML = html;
};

window.selectGender = function (element, value) {
    const container = element.closest('.segmented-control');
    const hiddenInput = container.querySelector('input[type="hidden"]');
    hiddenInput.value = value;
    container.querySelectorAll('.segment-btn').forEach(btn => btn.classList.remove('active'));
    element.classList.add('active');
};

window.toggleDropdown = function (triggerElement) {
    document.querySelectorAll('.custom-select-container.open').forEach(el => {
        if (el !== triggerElement.parentElement) {
            el.classList.remove('open');
        }
    });
    triggerElement.parentElement.classList.toggle('open');
};

window.selectOption = function (optionElement, value) {
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
};

document.addEventListener('click', function (e) {
    if (!e.target.closest('.custom-select-container')) {
        document.querySelectorAll('.custom-select-container.open').forEach(el => {
            el.classList.remove('open');
        });
    }
});

window.toggleFacility = function (element) {
    element.classList.toggle('selected');
};

window.addCustomFacility = function () {
    const input = document.getElementById('customFacInput');
    const value = input.value.trim();
    if (value) {
        const container = document.getElementById('customFacBadges');

        const existing = Array.from(container.children).find(b => b.getAttribute('data-value').toLowerCase() === value.toLowerCase());
        if (existing) {
            input.value = '';
            return;
        }

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
        input.value = '';
    }
};


document.addEventListener("DOMContentLoaded", function () {
    const customFacInput = document.getElementById('customFacInput');
    if (customFacInput) {
        customFacInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                addCustomFacility();
            }
        });
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
            if (currentCoverUrl) {
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

window.removeCoverPhoto = function (e) {
    e.stopPropagation();
    if (currentCoverUrl) {
        URL.revokeObjectURL(currentCoverUrl);
        currentCoverUrl = null;
    }
    coverInput.value = '';
    coverPreview.src = '';
    coverPreview.style.display = 'none';
    coverPlaceholder.style.display = 'block';
    removeCoverBtn.style.display = 'none';
    coverDropzone.style.borderStyle = 'dashed';
};

const galleryInput = document.getElementById('galleryInput');
const galleryGrid = document.getElementById('galleryGrid');

if (galleryInput) {
    galleryInput.addEventListener('change', function (e) {
        if (!this.files || this.files.length === 0) return;

        Array.from(this.files).forEach(file => {
            if (selectedGalleryFiles.length < 5) {
                const objectURL = URL.createObjectURL(file);
                selectedGalleryFiles.push({
                    file: file,
                    url: objectURL
                });
            }
        });

        this.value = '';
        renderGallery();
    });
}

window.renderGallery = function () {
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
};

window.removeGalleryPhoto = function (index, e) {
    e.stopPropagation();
    URL.revokeObjectURL(selectedGalleryFiles[index].url);
    selectedGalleryFiles.splice(index, 1);
    renderGallery();
};

document.addEventListener("DOMContentLoaded", function () {
    const propertyForm = document.getElementById('propertyForm');
    if (propertyForm) {
        propertyForm.addEventListener('submit', function (e) {
            if (!document.getElementById('propertyTypeInput').value) {
                e.preventDefault();
                goToStep(1);
                SewainAlert.alert("Mohon pilih jenis properti (Property Type) terlebih dahulu.", "Tipe Belum Dipilih", "warning");
                return;
            }

            const step3Container = document.getElementById('step3');
            const requiredInputs = step3Container.querySelectorAll('input[required], textarea[required]');
            let isValid = true;
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
                e.preventDefault();
                SewainAlert.alert("Please fill in all required fields before submitting.", "Incomplete Form", "warning");
                return;
            }

            const activeFacilities = [];
            document.querySelectorAll('.fac-card.selected').forEach(card => {
                activeFacilities.push(card.getAttribute('data-value'));
            });
            document.querySelectorAll('.custom-fac-badge').forEach(badge => {
                activeFacilities.push(badge.getAttribute('data-value'));
            });

            if (activeFacilities.length === 0) {
                e.preventDefault();
                goToStep(2);
                SewainAlert.alert("Minimal pilih 1 fasilitas untuk properti Anda.", "Fasilitas Kosong", "warning");
                return;
            }

            const coverInput = document.getElementById('coverPhotoInput');
            if (!coverInput || !coverInput.files || coverInput.files.length === 0) {
                e.preventDefault();
                goToStep(3);
                SewainAlert.alert("Mohon unggah minimal Cover Image untuk properti Anda.", "Foto Belum Lengkap", "warning");
                return;
            }

            const galleryInput = document.getElementById('galleryInput');
            if (galleryInput && typeof selectedGalleryFiles !== 'undefined') {
                const dt = new DataTransfer();
                selectedGalleryFiles.forEach(itemObj => dt.items.add(itemObj.file));
                galleryInput.files = dt.files;
            }

            document.getElementById('facilitiesInput').value = activeFacilities.join(', ');

            e.preventDefault();

            const formData = new FormData(propertyForm);
            const loadingOverlay = document.getElementById('loadingOverlay');
            loadingOverlay.classList.add('active');

            fetch(propertyForm.action, {
                method: 'POST',
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    loadingOverlay.classList.remove('active');
                    if (data.success) {
                        Swal.fire({
                            title: 'Berhasil!',
                            text: 'Properti Anda berhasil ditambahkan dan sedang menunggu verifikasi.',
                            icon: 'success',
                            confirmButtonColor: 'var(--deep)',
                            confirmButtonText: 'Ke Dashboard'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                window.location.href = window.contextPath + '/pages/owner/dashboard_owner.jsp';
                            }
                        });
                    } else {
                        Swal.fire({
                            title: 'Gagal!',
                            text: data.message || 'Terjadi kesalahan saat memproses data.',
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
    }
});

document.addEventListener('input', function (e) {
    if (e.target.classList.contains('form-control')) {
        e.target.classList.remove('is-invalid');
    }
});
document.addEventListener('change', function (e) {
    if (e.target.classList.contains('form-control')) {
        e.target.classList.remove('is-invalid');
    }
});
