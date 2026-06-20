window.SewainAlert = {
    _createModal: function (title, text, type, showCancel) {
        return new Promise((resolve) => {
            const overlay = document.createElement('div');
            overlay.className = 'sewain-modal-overlay';

            const card = document.createElement('div');
            card.className = 'sewain-modal-card';

            const iconWrap = document.createElement('div');
            iconWrap.className = 'sewain-modal-icon ' + type;
            let iconHtml = '<i class="fa-solid fa-info"></i>';
            if (type === 'success') iconHtml = '<i class="fa-solid fa-check"></i>';
            if (type === 'error') iconHtml = '<i class="fa-solid fa-xmark"></i>';
            if (type === 'warning') iconHtml = '<i class="fa-solid fa-exclamation"></i>';
            iconWrap.innerHTML = iconHtml;

            const titleEl = document.createElement('h3');
            titleEl.className = 'sewain-modal-title';
            titleEl.textContent = title;

            const textEl = document.createElement('p');
            textEl.className = 'sewain-modal-text';
            textEl.textContent = text;

            const btnGroup = document.createElement('div');
            btnGroup.className = 'sewain-modal-actions';

            if (showCancel) {
                const btnCancel = document.createElement('button');
                btnCancel.className = 'sewain-btn-secondary';
                btnCancel.textContent = 'Batal';
                btnCancel.onclick = () => {
                    overlay.classList.add('hide');
                    setTimeout(() => document.body.removeChild(overlay), 200);
                    resolve(false);
                };
                btnGroup.appendChild(btnCancel);
            }

            const btnOk = document.createElement('button');
            btnOk.className = 'sewain-btn-primary ' + (type === 'warning' || type === 'error' ? 'danger' : '');
            btnOk.textContent = showCancel ? 'Ya, Lanjutkan' : 'OK Mengerti';
            btnOk.onclick = () => {
                overlay.classList.add('hide');
                setTimeout(() => document.body.removeChild(overlay), 200);
                resolve(true);
            };
            btnGroup.appendChild(btnOk);

            card.appendChild(iconWrap);
            if (title) card.appendChild(titleEl);
            card.appendChild(textEl);
            card.appendChild(btnGroup);

            overlay.appendChild(card);
            document.body.appendChild(overlay);

            
            requestAnimationFrame(() => {
                overlay.classList.add('show');
            });
        });
    },

    alert: function (message, title = "Informasi") {
        return this._createModal(title, message, 'info', false);
    },

    success: function (message, title = "Berhasil!") {
        return this._createModal(title, message, 'success', false);
    },

    error: function (message, title = "Kesalahan") {
        return this._createModal(title, message, 'error', false);
    },

    confirm: function (message, title = "Konfirmasi Tindakan", type = 'warning') {
        return this._createModal(title, message, type, true);
    }
};
