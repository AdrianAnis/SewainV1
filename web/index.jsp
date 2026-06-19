<%-- Document : index Created on : Jun 8, 2026, 11:49:08 PM Author : Lenovo --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@page import="DAO.PropertyDAO" %>
            <%@page import="model.Property" %>
                <%@page import="java.util.List" %>
                    <%@page import="java.util.ArrayList" %>
                        <%! public String resolvePropertyImage(String photoStr, String contextPath) { String
                            defaultImg=contextPath + "/assets/images/default-property.jpg" ; if (photoStr==null) return
                            defaultImg; String trimmed=photoStr.trim(); if (trimmed.isEmpty() || "null" .equals(trimmed)
                            || "[]" .equals(trimmed)) return defaultImg; String[] parts=trimmed.split(","); if
                            (parts.length==0) return defaultImg; String photo=parts[0].trim(); if (photo.isEmpty()
                            || "null" .equals(photo)) return defaultImg; if (photo.startsWith("http://") ||
                            photo.startsWith("https://")) return photo; if (photo.startsWith(contextPath + "/uploads/"
                            )) return photo; if (photo.startsWith("/uploads/")) return contextPath + photo; if
                            (photo.startsWith("/")) return photo; if (photo.startsWith("uploads/")) return contextPath
                            + "/" + photo; return contextPath + "/uploads/" + photo; } public String formatPrice(double
                            price) { if (price>= 1000000) {
                            double priceJt = price / 1000000.0;
                            if (priceJt == (long) priceJt) {
                            return "Rp " + (long) priceJt + " jt/bln";
                            } else {
                            return "Rp " + priceJt + " jt/bln";
                            }
                            } else {
                            return "Rp " + (long) price + "/bln";
                            }
                            }
                            %>
                            <% PropertyDAO propertyDAO=new PropertyDAO(); List<Property> landingProps =
                                propertyDAO.getLandingProperties();
                                Property heroProperty = null;
                                List<Property> featuredProperties = new ArrayList<>();

                                        if (landingProps != null && !landingProps.isEmpty()) {
                                        heroProperty = landingProps.get(0);
                                        for (int i = 1; i < Math.min(landingProps.size(), 4); i++) {
                                            featuredProperties.add(landingProps.get(i)); } } String
                                            ctxPath=request.getContextPath(); %>
                                            <!DOCTYPE html>
                                            <html lang="id">

                                            <head>
                                                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                                                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                                                <link rel="preconnect" href="https://fonts.googleapis.com" />
                                                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
                                                <link
                                                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
                                                    rel="stylesheet" />
                                                <link rel="stylesheet" href="assets/css/shared/global.css" />
                                                <link rel="stylesheet" href="assets/css/shared/components.css" />
                                                <link rel="stylesheet" href="assets/css/landing/landing.css" />
                                                <link rel="stylesheet"
                                                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
                                                <title>SewaIn - Temukan Hunian Impian Anda</title>
                                            </head>

                                            <body>
                                                <section class="hero">
                                                    <div class="container">
                                                        <jsp:include page="pages/components/navbar.jsp" />

                                                        <div class="hero-content">
                                                            <div class="hero-left">
                                                                <h1>
                                                                    Temukan<br />
                                                                    <span class="hero-highlight">Hunian
                                                                        Impian</span><br />
                                                                    Anda
                                                                </h1>
                                                                <p class="hero-desc">
                                                                    Sewa apartemen, rumah, dan kost premium dengan
                                                                    mudah,
                                                                    aman, dan
                                                                    terpercaya. Pilihan terbaik untuk gaya hidup modern.
                                                                </p>
                                                            </div>

                                                            <div class="hero-right">
                                                                <% if (heroProperty !=null) { %>
                                                                    <div class="property-card hero-card"
                                                                        style="cursor: pointer;"
                                                                        onclick="window.location.href='<%= ctxPath %>/pages/auth/login.jsp'">
                                                                        <div
                                                                            class="property-img-wrapper hero-card-img-wrapper">
                                                                            <img src="<%= resolvePropertyImage(heroProperty.getPhotos(), ctxPath) %>"
                                                                                alt="<%= heroProperty.getName() %>"
                                                                                onerror="this.src='<%= ctxPath %>/assets/images/default-property.jpg'" />
                                                                            <% if
                                                                                ("Approved".equalsIgnoreCase(heroProperty.getVerificationStatus()))
                                                                                { %>
                                                                                <span class="badge-verified">
                                                                                    <i
                                                                                        class="fa-solid fa-circle-check"></i>
                                                                                    VERIFIED
                                                                                </span>
                                                                                <% } %>
                                                                                    <button class="property-wishlist"
                                                                                        aria-label="Wishlist"
                                                                                        onclick="event.stopPropagation(); window.location.href='<%= ctxPath %>/pages/auth/login.jsp'">
                                                                                        <svg width="18" height="18"
                                                                                            fill="none"
                                                                                            stroke="currentColor"
                                                                                            stroke-width="2"
                                                                                            viewBox="0 0 24 24">
                                                                                            <path
                                                                                                d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                                                                        </svg>
                                                                                    </button>
                                                                                    <% if
                                                                                        (heroProperty.isAvailability())
                                                                                        { %>
                                                                                        <div class="property-available">
                                                                                            AVAILABLE NOW</div>
                                                                                        <% } %>
                                                                        </div>

                                                                        <div class="property-content hero-card-content">
                                                                            <div class="property-top-row">
                                                                                <h3 class="property-name">
                                                                                    <%= heroProperty.getName() %>
                                                                                </h3>
                                                                                <span class="property-price">
                                                                                    <%= formatPrice(heroProperty.getPrice())
                                                                                        %>
                                                                                </span>
                                                                            </div>
                                                                            <p class="property-location">
                                                                                <svg width="13" height="13" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2"
                                                                                    viewBox="0 0 24 24">
                                                                                    <path
                                                                                        d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z" />
                                                                                    <circle cx="12" cy="9" r="2.5" />
                                                                                </svg>
                                                                                <%= heroProperty.getLocation() %>
                                                                            </p>
                                                                            <div class="property-meta"
                                                                                style="display: flex; gap: 16px; border-top: 1px solid var(--border); padding-top: 16px; font-size: 13.5px; font-weight: 500; color: var(--deep);">
                                                                                <% String
                                                                                    pType=(heroProperty.getPropertyType()
                                                                                    !=null ?
                                                                                    heroProperty.getPropertyType() : ""
                                                                                    ).toLowerCase(); if
                                                                                    ("kost".equals(pType)) { %>
                                                                                    <span
                                                                                        style="display: flex; align-items: center; gap: 6px;">
                                                                                        <i
                                                                                            class="fa-solid fa-venus-mars"></i>
                                                                                        <%= heroProperty.getGender()
                                                                                            !=null &&
                                                                                            !heroProperty.getGender().isEmpty()
                                                                                            ? heroProperty.getGender()
                                                                                            : "Campur" %>
                                                                                    </span>
                                                                                    <span
                                                                                        style="display: flex; align-items: center; gap: 6px;">
                                                                                        <i
                                                                                            class="fa-solid fa-door-closed"></i>
                                                                                        <%= heroProperty.getRoomType()
                                                                                            !=null &&
                                                                                            !heroProperty.getRoomType().isEmpty()
                                                                                            ? heroProperty.getRoomType()
                                                                                            : "Standard" %>
                                                                                    </span>
                                                                                    <% } else if ("rumah".equals(pType))
                                                                                        { %>
                                                                                        <span
                                                                                            style="display: flex; align-items: center; gap: 6px;">
                                                                                            <i
                                                                                                class="fa-solid fa-bed"></i>
                                                                                            <%= heroProperty.getJumlahKamar()
                                                                                                %> Kamar
                                                                                        </span>
                                                                                        <span
                                                                                            style="display: flex; align-items: center; gap: 6px;">
                                                                                            <i
                                                                                                class="fa-solid fa-maximize"></i>
                                                                                            <%= (int)
                                                                                                heroProperty.getLuasTanah()
                                                                                                %> m²
                                                                                        </span>
                                                                                        <% } else if
                                                                                            ("kontrakan".equals(pType))
                                                                                            { %>
                                                                                            <span
                                                                                                style="display: flex; align-items: center; gap: 6px;">
                                                                                                <i
                                                                                                    class="fa-solid fa-bed"></i>
                                                                                                <%= heroProperty.getJumlahKamar()
                                                                                                    %> Kamar
                                                                                            </span>
                                                                                            <span
                                                                                                style="display: flex; align-items: center; gap: 6px;">
                                                                                                <i
                                                                                                    class="fa-solid fa-calendar-days"></i>
                                                                                                Min. <%=
                                                                                                    heroProperty.getDurasiMinimum()
                                                                                                    %> Bln
                                                                                            </span>
                                                                                            <% } else { // apartement /
                                                                                                apartemen %>
                                                                                                <span
                                                                                                    style="display: flex; align-items: center; gap: 6px;">
                                                                                                    <i
                                                                                                        class="fa-solid fa-layer-group"></i>
                                                                                                    Lantai <%=
                                                                                                        heroProperty.getLantai()
                                                                                                        %>
                                                                                                </span>
                                                                                                <span
                                                                                                    style="display: flex; align-items: center; gap: 6px;">
                                                                                                    <i
                                                                                                        class="fa-solid fa-door-closed"></i>
                                                                                                    Unit <%=
                                                                                                        heroProperty.getNomorUnit()
                                                                                                        !=null &&
                                                                                                        !heroProperty.getNomorUnit().isEmpty()
                                                                                                        ?
                                                                                                        heroProperty.getNomorUnit()
                                                                                                        : "12B" %>
                                                                                                </span>
                                                                                                <span
                                                                                                    style="display: flex; align-items: center; gap: 6px;">
                                                                                                    <i
                                                                                                        class="fa-solid fa-shapes"></i>
                                                                                                    <%= heroProperty.getTipeUnit()
                                                                                                        !=null &&
                                                                                                        !heroProperty.getTipeUnit().isEmpty()
                                                                                                        ?
                                                                                                        heroProperty.getTipeUnit()
                                                                                                        : "Studio" %>
                                                                                                </span>
                                                                                                <% } %>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <% } else { %>
                                                                        <div class="property-card hero-card"
                                                                            style="cursor: pointer;"
                                                                            onclick="window.location.href='<%= ctxPath %>/pages/auth/login.jsp'">
                                                                            <div
                                                                                class="property-img-wrapper hero-card-img-wrapper">
                                                                                <img src="assets/images/landing/hero-property.jpg"
                                                                                    alt="The Grand Residence"
                                                                                    onerror="this.style.visibility = 'hidden'" />
                                                                                <span class="badge-verified">
                                                                                    <i
                                                                                        class="fa-solid fa-circle-check"></i>
                                                                                    VERIFIED
                                                                                </span>
                                                                                <button class="property-wishlist"
                                                                                    aria-label="Wishlist"
                                                                                    onclick="event.stopPropagation(); window.location.href='<%= ctxPath %>/pages/auth/login.jsp'">
                                                                                    <svg width="18" height="18"
                                                                                        fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2"
                                                                                        viewBox="0 0 24 24">
                                                                                        <path
                                                                                            d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                                                                    </svg>
                                                                                </button>
                                                                                <div class="property-available">
                                                                                    AVAILABLE
                                                                                    NOW</div>
                                                                            </div>

                                                                            <div
                                                                                class="property-content hero-card-content">
                                                                                <div class="property-top-row">
                                                                                    <h3 class="property-name">The Grand
                                                                                        Residence</h3>
                                                                                    <span class="property-price">Rp
                                                                                        15jt/bln</span>
                                                                                </div>
                                                                                <p class="property-location">
                                                                                    <svg width="13" height="13"
                                                                                        fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2"
                                                                                        viewBox="0 0 24 24">
                                                                                        <path
                                                                                            d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z" />
                                                                                        <circle cx="12" cy="9"
                                                                                            r="2.5" />
                                                                                    </svg>
                                                                                    Jakarta Selatan
                                                                                </p>
                                                                                <div class="property-meta"
                                                                                    style="display: flex; gap: 16px; border-top: 1px solid var(--border); padding-top: 16px; font-size: 13.5px; font-weight: 500; color: var(--deep);">
                                                                                    <span
                                                                                        style="display: flex; align-items: center; gap: 6px;">
                                                                                        <i class="fa-solid fa-bed"></i>
                                                                                        3 Kamar
                                                                                    </span>
                                                                                    <span
                                                                                        style="display: flex; align-items: center; gap: 6px;">
                                                                                        <i class="fa-solid fa-bath"></i>
                                                                                        2 Mandi
                                                                                    </span>
                                                                                    <span
                                                                                        style="display: flex; align-items: center; gap: 6px;">
                                                                                        <i
                                                                                            class="fa-solid fa-maximize"></i>
                                                                                        120m&sup2;
                                                                                    </span>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <% } %>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </section>
                                                <section class="property-section">
                                                    <div class="container">
                                                        <div class="property-header reveal-header">
                                                            <div>
                                                                <h2 class="section-title">Properti Unggulan</h2>
                                                                <p class="section-subtitle">
                                                                    Pilihan premium yang telah dikurasi untuk Anda.
                                                                </p>
                                                            </div>
                                                            <a href="${pageContext.request.contextPath}/login"
                                                                class="btn-see-all">
                                                                Lihat Semua
                                                                <svg width="16" height="16" fill="none"
                                                                    stroke="currentColor" stroke-width="2"
                                                                    viewBox="0 0 24 24">
                                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                                </svg>
                                                            </a>
                                                        </div>

                                                        <div class="property-grid">
                                                            <% if (featuredProperties !=null &&
                                                                !featuredProperties.isEmpty()) { for (Property prop :
                                                                featuredProperties) { %>
                                                                <div class="property-card reveal-card"
                                                                    style="cursor: pointer;"
                                                                    onclick="window.location.href='<%= ctxPath %>/pages/auth/login.jsp'">
                                                                    <div class="property-img-wrapper">
                                                                        <img src="<%= resolvePropertyImage(prop.getPhotos(), ctxPath) %>"
                                                                            alt="<%= prop.getName() %>"
                                                                            onerror="this.src='<%= ctxPath %>/assets/images/default-property.jpg'" />
                                                                        <% if
                                                                            ("Approved".equalsIgnoreCase(prop.getVerificationStatus()))
                                                                            { %>
                                                                            <span class="badge-verified">
                                                                                <i class="fa-solid fa-circle-check"></i>
                                                                                VERIFIED
                                                                            </span>
                                                                            <% } %>
                                                                                <button class="property-wishlist"
                                                                                    aria-label="Wishlist"
                                                                                    onclick="event.stopPropagation(); window.location.href='<%= ctxPath %>/pages/auth/login.jsp'">
                                                                                    <svg width="18" height="18"
                                                                                        fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2"
                                                                                        viewBox="0 0 24 24">
                                                                                        <path
                                                                                            d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                                                                    </svg>
                                                                                </button>
                                                                                <% if (prop.isAvailability()) { %>
                                                                                    <div class="property-available">
                                                                                        AVAILABLE NOW</div>
                                                                                    <% } %>
                                                                    </div>
                                                                    <div class="property-content">
                                                                        <div class="property-top-row">
                                                                            <h3 class="property-name">
                                                                                <%= prop.getName() %>
                                                                            </h3>
                                                                            <span class="property-price">
                                                                                <%= formatPrice(prop.getPrice()) %>
                                                                            </span>
                                                                        </div>
                                                                        <p class="property-location">
                                                                            <svg width="13" height="13" fill="none"
                                                                                stroke="currentColor" stroke-width="2"
                                                                                viewBox="0 0 24 24">
                                                                                <path
                                                                                    d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z" />
                                                                                <circle cx="12" cy="9" r="2.5" />
                                                                            </svg>
                                                                            <%= prop.getLocation() %>
                                                                        </p>
                                                                        <div class="property-meta"
                                                                            style="display: flex; gap: 16px; border-top: 1px solid var(--border); padding-top: 16px; font-size: 13.5px; font-weight: 500; color: var(--deep);">
                                                                            <% String pType=(prop.getPropertyType()
                                                                                !=null ? prop.getPropertyType() : ""
                                                                                ).toLowerCase(); if
                                                                                ("kost".equals(pType)) { %>
                                                                                <span
                                                                                    style="display: flex; align-items: center; gap: 6px;">
                                                                                    <i
                                                                                        class="fa-solid fa-venus-mars"></i>
                                                                                    <%= prop.getGender() !=null &&
                                                                                        !prop.getGender().isEmpty() ?
                                                                                        prop.getGender() : "Campur" %>
                                                                                </span>
                                                                                <span
                                                                                    style="display: flex; align-items: center; gap: 6px;">
                                                                                    <i
                                                                                        class="fa-solid fa-door-closed"></i>
                                                                                    <%= prop.getRoomType() !=null &&
                                                                                        !prop.getRoomType().isEmpty() ?
                                                                                        prop.getRoomType() : "Standard"
                                                                                        %>
                                                                                </span>
                                                                                <% } else if ("rumah".equals(pType)) {
                                                                                    %>
                                                                                    <span
                                                                                        style="display: flex; align-items: center; gap: 6px;">
                                                                                        <i class="fa-solid fa-bed"></i>
                                                                                        <%= prop.getJumlahKamar() %>
                                                                                            Kamar
                                                                                    </span>
                                                                                    <span
                                                                                        style="display: flex; align-items: center; gap: 6px;">
                                                                                        <i
                                                                                            class="fa-solid fa-maximize"></i>
                                                                                        <%= (int) prop.getLuasTanah() %>
                                                                                            m²
                                                                                    </span>
                                                                                    <% } else if
                                                                                        ("kontrakan".equals(pType)) { %>
                                                                                        <span
                                                                                            style="display: flex; align-items: center; gap: 6px;">
                                                                                            <i
                                                                                                class="fa-solid fa-bed"></i>
                                                                                            <%= prop.getJumlahKamar() %>
                                                                                                Kamar
                                                                                        </span>
                                                                                        <span
                                                                                            style="display: flex; align-items: center; gap: 6px;">
                                                                                            <i
                                                                                                class="fa-solid fa-calendar-days"></i>
                                                                                            Min. <%=
                                                                                                prop.getDurasiMinimum()
                                                                                                %> Bln
                                                                                        </span>
                                                                                        <% } else { // apartement /
                                                                                            apartemen %>
                                                                                            <span
                                                                                                style="display: flex; align-items: center; gap: 6px;">
                                                                                                <i
                                                                                                    class="fa-solid fa-layer-group"></i>
                                                                                                Lantai <%=
                                                                                                    prop.getLantai() %>
                                                                                            </span>
                                                                                            <span
                                                                                                style="display: flex; align-items: center; gap: 6px;">
                                                                                                <i
                                                                                                    class="fa-solid fa-door-closed"></i>
                                                                                                Unit <%=
                                                                                                    prop.getNomorUnit()
                                                                                                    !=null &&
                                                                                                    !prop.getNomorUnit().isEmpty()
                                                                                                    ?
                                                                                                    prop.getNomorUnit()
                                                                                                    : "12B" %>
                                                                                            </span>
                                                                                            <span
                                                                                                style="display: flex; align-items: center; gap: 6px;">
                                                                                                <i
                                                                                                    class="fa-solid fa-shapes"></i>
                                                                                                <%= prop.getTipeUnit()
                                                                                                    !=null &&
                                                                                                    !prop.getTipeUnit().isEmpty()
                                                                                                    ? prop.getTipeUnit()
                                                                                                    : "Studio" %>
                                                                                            </span>
                                                                                            <% } %>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <% } } else { %>
                                                                    <div class="property-card reveal-card"
                                                                        style="cursor: pointer;"
                                                                        onclick="window.location.href='<%= ctxPath %>/pages/auth/login.jsp'">
                                                                        <div class="property-img-wrapper">
                                                                            <img src="assets/images/landing/property1.jpg"
                                                                                alt="The Senopati Suites"
                                                                                onerror="this.style.visibility = 'hidden'" />
                                                                            <span class="badge-verified">
                                                                                <i class="fa-solid fa-circle-check"></i>
                                                                                VERIFIED
                                                                            </span>
                                                                            <button class="property-wishlist"
                                                                                aria-label="Wishlist"
                                                                                onclick="event.stopPropagation(); window.location.href='<%= ctxPath %>/pages/auth/login.jsp'">
                                                                                <svg width="18" height="18" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2"
                                                                                    viewBox="0 0 24 24">
                                                                                    <path
                                                                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                                                                </svg>
                                                                            </button>
                                                                            <div class="property-available">AVAILABLE
                                                                                NOW
                                                                            </div>
                                                                        </div>
                                                                        <div class="property-content">
                                                                            <div class="property-top-row">
                                                                                <h3 class="property-name">The Senopati
                                                                                    Suites</h3>
                                                                                <span class="property-price">Rp
                                                                                    12jt/bln</span>
                                                                            </div>
                                                                            <p class="property-location">
                                                                                <svg width="13" height="13" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2"
                                                                                    viewBox="0 0 24 24">
                                                                                    <path
                                                                                        d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z" />
                                                                                    <circle cx="12" cy="9" r="2.5" />
                                                                                </svg>
                                                                                Senopati, Jakarta Selatan
                                                                            </p>
                                                                            <div class="property-meta"
                                                                                style="display: flex; gap: 16px; border-top: 1px solid var(--border); padding-top: 16px; font-size: 13.5px; font-weight: 500; color: var(--deep);">
                                                                                <span
                                                                                    style="display: flex; align-items: center; gap: 6px;">
                                                                                    <i class="fa-solid fa-bed"></i>
                                                                                    2 Kamar
                                                                                </span>
                                                                                <span
                                                                                    style="display: flex; align-items: center; gap: 6px;">
                                                                                    <i class="fa-solid fa-bath"></i>
                                                                                    2 Mandi
                                                                                </span>
                                                                                <span
                                                                                    style="display: flex; align-items: center; gap: 6px;">
                                                                                    <i class="fa-solid fa-maximize"></i>
                                                                                    85m&sup2;
                                                                                </span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="property-card reveal-card"
                                                                        style="cursor: pointer;"
                                                                        onclick="window.location.href='<%= ctxPath %>/pages/auth/login.jsp'">
                                                                        <div class="property-img-wrapper">
                                                                            <img src="assets/images/landing/property2.jpg"
                                                                                alt="Serenity Villa Kemang"
                                                                                onerror="this.style.visibility = 'hidden'" />
                                                                            <span class="badge-verified">
                                                                                <i class="fa-solid fa-circle-check"></i>
                                                                                VERIFIED
                                                                            </span>
                                                                            <button class="property-wishlist"
                                                                                aria-label="Wishlist"
                                                                                onclick="event.stopPropagation(); window.location.href='<%= ctxPath %>/pages/auth/login.jsp'">
                                                                                <svg width="18" height="18" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2"
                                                                                    viewBox="0 0 24 24">
                                                                                    <path
                                                                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                                                                </svg>
                                                                            </button>
                                                                            <div class="property-available">AVAILABLE
                                                                                NOW
                                                                            </div>
                                                                        </div>
                                                                        <div class="property-content">
                                                                            <div class="property-top-row">
                                                                                <h3 class="property-name">Serenity Villa
                                                                                    Kemang</h3>
                                                                                <span class="property-price">Rp
                                                                                    12jt/bln</span>
                                                                            </div>
                                                                            <p class="property-location">
                                                                                <svg width="13" height="13" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2"
                                                                                    viewBox="0 0 24 24">
                                                                                    <path
                                                                                        d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z" />
                                                                                    <circle cx="12" cy="9" r="2.5" />
                                                                                </svg>
                                                                                Kemang, Jakarta Selatan
                                                                            </p>
                                                                            <div class="property-meta"
                                                                                style="display: flex; gap: 16px; border-top: 1px solid var(--border); padding-top: 16px; font-size: 13.5px; font-weight: 500; color: var(--deep);">
                                                                                <span
                                                                                    style="display: flex; align-items: center; gap: 6px;">
                                                                                    <i class="fa-solid fa-bed"></i>
                                                                                    2 Kamar
                                                                                </span>
                                                                                <span
                                                                                    style="display: flex; align-items: center; gap: 6px;">
                                                                                    <i class="fa-solid fa-bath"></i>
                                                                                    2 Mandi
                                                                                </span>
                                                                                <span
                                                                                    style="display: flex; align-items: center; gap: 6px;">
                                                                                    <i class="fa-solid fa-maximize"></i>
                                                                                    85m&sup2;
                                                                                </span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="property-card reveal-card"
                                                                        style="cursor: pointer;"
                                                                        onclick="window.location.href='<%= ctxPath %>/pages/auth/login.jsp'">
                                                                        <div class="property-img-wrapper">
                                                                            <img src="assets/images/landing/property3.jpg"
                                                                                alt="Skyline Suites Sudirman"
                                                                                onerror="this.style.visibility = 'hidden'" />
                                                                            <span class="badge-verified">
                                                                                <i class="fa-solid fa-circle-check"></i>
                                                                                VERIFIED
                                                                            </span>
                                                                            <button class="property-wishlist"
                                                                                aria-label="Wishlist"
                                                                                onclick="event.stopPropagation(); window.location.href='<%= ctxPath %>/pages/auth/login.jsp'">
                                                                                <svg width="18" height="18" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2"
                                                                                    viewBox="0 0 24 24">
                                                                                    <path
                                                                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                                                                </svg>
                                                                            </button>
                                                                            <div class="property-available">AVAILABLE
                                                                                NOW
                                                                            </div>
                                                                        </div>
                                                                        <div class="property-content">
                                                                            <div class="property-top-row">
                                                                                <h3 class="property-name">Skyline Suites
                                                                                    Sudirman</h3>
                                                                                <span class="property-price">Rp
                                                                                    12jt/bln</span>
                                                                            </div>
                                                                            <p class="property-location">
                                                                                <svg width="13" height="13" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2"
                                                                                    viewBox="0 0 24 24">
                                                                                    <path
                                                                                        d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z" />
                                                                                    <circle cx="12" cy="9" r="2.5" />
                                                                                </svg>
                                                                                Sudirman, Jakarta Selatan
                                                                            </p>
                                                                            <div class="property-meta"
                                                                                style="display: flex; gap: 16px; border-top: 1px solid var(--border); padding-top: 16px; font-size: 13.5px; font-weight: 500; color: var(--deep);">
                                                                                <span
                                                                                    style="display: flex; align-items: center; gap: 6px;">
                                                                                    <i class="fa-solid fa-bed"></i>
                                                                                    3 Kamar
                                                                                </span>
                                                                                <span
                                                                                    style="display: flex; align-items: center; gap: 6px;">
                                                                                    <i class="fa-solid fa-bath"></i>
                                                                                    2 Mandi
                                                                                </span>
                                                                                <span
                                                                                    style="display: flex; align-items: center; gap: 6px;">
                                                                                    <i class="fa-solid fa-maximize"></i>
                                                                                    85m&sup2;
                                                                                </span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <% } %>
                                                        </div>
                                                    </div>
                                                </section>
                                                <section class="curation">
                                                    <div class="container">
                                                        <div class="curation-content">
                                                            <div class="curation-left">
                                                                <h2 class="section-title">Standar Kurasi<br />SewaIn
                                                                </h2>
                                                                <p class="curation-desc">
                                                                    Kami memastikan setiap properti yang terdaftar
                                                                    memenuhi
                                                                    standar
                                                                    kenyamanan dan keamanan yang tinggi. Kenali lencana
                                                                    status kami.
                                                                </p>
                                                                <div class="curation-list">
                                                                    <div class="curation-box verified-box">
                                                                        <div class="curation-icon verified-icon">
                                                                            <svg width="20" height="20" fill="none"
                                                                                stroke="currentColor" stroke-width="2"
                                                                                viewBox="0 0 24 24">
                                                                                <path
                                                                                    d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                                            </svg>
                                                                        </div>
                                                                        <div>
                                                                            <h3>Verified Property</h3>
                                                                            <p>
                                                                                Properti telah dikunjungi, difoto, dan
                                                                                diverifikasi
                                                                                keasliannya oleh tim kurator kami.
                                                                                Transaksi
                                                                                dijamin aman.
                                                                            </p>
                                                                        </div>
                                                                    </div>
                                                                    <div class="curation-box review-box">
                                                                        <div class="curation-icon review-icon">
                                                                            <svg width="20" height="20" fill="none"
                                                                                stroke="currentColor" stroke-width="2"
                                                                                viewBox="0 0 24 24">
                                                                                <circle cx="12" cy="12" r="10" />
                                                                                <path d="M12 6v6l4 2" />
                                                                            </svg>
                                                                        </div>
                                                                        <div>
                                                                            <h3>Under Review</h3>
                                                                            <p>
                                                                                Properti sedang dalam tahap verifikasi
                                                                                dokumen dan
                                                                                penjadwalan kunjungan fisik oleh tim
                                                                                kami.
                                                                            </p>
                                                                        </div>
                                                                    </div>
                                                                    <div class="curation-box rejected-box">
                                                                        <div class="curation-icon rejected-icon">
                                                                            <svg width="20" height="20" fill="none"
                                                                                stroke="currentColor" stroke-width="2"
                                                                                viewBox="0 0 24 24">
                                                                                <circle cx="12" cy="12" r="10" />
                                                                                <path d="M15 9l-6 6M9 9l6 6" />
                                                                            </svg>
                                                                        </div>
                                                                        <div>
                                                                            <h3>Rejected Property</h3>
                                                                            <p>
                                                                                Properti yang tidak memenuhi standar
                                                                                kualitas dan keamanan
                                                                                kami akan ditolak untuk menjaga
                                                                                kepercayaan
                                                                                komunitas.
                                                                            </p>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="curation-right">
                                                                <div class="curation-img-wrapper">
                                                                    <img src="assets/images/landing/verification.png"
                                                                        alt="Verification process" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </section>
                                                <section class="trust">
                                                    <div class="container">
                                                        <div class="trust-wrapper">
                                                            <div class="trust-left">
                                                                <h2 class="section-title">
                                                                    Kepercayaan &amp;<br />Kenyamanan
                                                                    Anda<br />Prioritas
                                                                    Kami
                                                                </h2>
                                                                <p class="trust-desc">
                                                                    Setiap properti di SewaIn melewati proses verifikasi
                                                                    ketat untuk
                                                                    memastikan kualitas dan keamanan. Transaksi
                                                                    transparan
                                                                    tanpa biaya
                                                                    tersembunyi.
                                                                </p>
                                                                <div class="trust-list">
                                                                    <div class="trust-item">
                                                                        <div class="trust-icon">
                                                                            <svg width="18" height="18" fill="none"
                                                                                stroke="white" stroke-width="2"
                                                                                viewBox="0 0 24 24">
                                                                                <path
                                                                                    d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                                            </svg>
                                                                        </div>
                                                                        <span>100% Verifikasi Properti &amp;
                                                                            Pemilik</span>
                                                                    </div>
                                                                    <div class="trust-item">
                                                                        <div class="trust-icon">
                                                                            <svg width="18" height="18" fill="none"
                                                                                stroke="white" stroke-width="2"
                                                                                viewBox="0 0 24 24">
                                                                                <rect x="1" y="4" width="22" height="16"
                                                                                    rx="2" ry="2" />
                                                                                <line x1="1" y1="10" x2="23" y2="10" />
                                                                            </svg>
                                                                        </div>
                                                                        <span>Pembayaran Aman &amp; Fleksibel</span>
                                                                    </div>
                                                                    <div class="trust-item">
                                                                        <div class="trust-icon">
                                                                            <svg width="18" height="18" fill="none"
                                                                                stroke="white" stroke-width="2"
                                                                                viewBox="0 0 24 24">
                                                                                <path
                                                                                    d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
                                                                            </svg>
                                                                        </div>
                                                                        <span>Dukungan Pelanggan 24/7</span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="trust-right">
                                                                <img src="assets/images/landing/trust.png"
                                                                    alt="Trust & Safety" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </section>
                                                <jsp:include page="pages/components/footer.jsp" />
                                                <script src="assets/js/landing/landing.js"></script>
                                            </body>

                                            </html>