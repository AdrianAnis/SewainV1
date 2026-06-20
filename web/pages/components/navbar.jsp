<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="model.User" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
            <% User currentUser=(User) session.getAttribute("userSession"); 
               String roleSession=(String) session.getAttribute("roleSession");
               String role=currentUser !=null ? currentUser.getRole() : null; 
               String contextPath=request.getContextPath(); 
               
               String effectiveRole = role;
               if ("Owner".equalsIgnoreCase(role) && "tenant".equalsIgnoreCase(roleSession)) {
                   effectiveRole = "Tenant";
               }
            %>
                <nav class="navbar">
                    <div class="nav-wrapper">
                        <% if ("Owner".equalsIgnoreCase(effectiveRole)) { %>
                            <a href="<%= contextPath %>/pages/owner/dashboard_owner.jsp" class="logo">SewaIn</a>
                            <% } else if ("Admin".equalsIgnoreCase(effectiveRole)) { %>
                                <a href="<%= contextPath %>/pages/admin/dashboard_admin.jsp" class="logo">SewaIn</a>
                                <% } else { %>
                                    <a href="<%= contextPath %>/landing" class="logo">SewaIn</a>
                                    <% } %>

                                        <div class="nav-auth">
                                            <% if (currentUser==null) { %>
                                                <a href="<%= contextPath %>/login" class="btn-login">Login / Daftar</a>
                                                <% } else { %>
                                                    <% if ("Tenant".equalsIgnoreCase(effectiveRole)) { %>
                                                        <a href="<%= contextPath %>/pages/tenant/wishlist.jsp"
                                                            class="nav-icon-btn" aria-label="Favorit">
                                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2"
                                                                stroke-linecap="round" stroke-linejoin="round">
                                                                <path
                                                                    d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                                                </path>
                                                            </svg>
                                                        </a>
                                                        <% } %>
                                                            <div class="nav-profile-container">
                                                                <button class="nav-avatar-btn" id="avatarBtn"
                                                                    aria-label="Menu Profil">
                                                                    <span class="nav-avatar-circle">
                                                                        <svg width="20" height="20" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="1.8">
                                                                            <path
                                                                                d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                                                            <circle cx="12" cy="7" r="4" />
                                                                        </svg>
                                                                    </span>
                                                                    <span class="nav-username">
                                                                        <%= currentUser.getName() %>
                                                                    </span>
                                                                    <svg class="chevron-icon" width="14" height="14"
                                                                        viewBox="0 0 24 24" fill="none"
                                                                        stroke="currentColor" stroke-width="2">
                                                                        <polyline points="6 9 12 15 18 9"></polyline>
                                                                    </svg>
                                                                </button>
                                                                <div class="profile-dropdown" id="profileDropdown">
                                                                    <div class="dropdown-user-info">
                                                                        <div class="name">
                                                                            <%= currentUser.getName() %>
                                                                        </div>
                                                                        <div class="email">
                                                                            <%= currentUser.getEmail() %>
                                                                        </div>
                                                                        <span class="badge">
                                                                            <%= effectiveRole.toUpperCase() %>
                                                                        </span>
                                                                    </div>
                                                                    <div class="dropdown-menu-list">
                                                                        <a href="<%= contextPath %>/profile"
                                                                            class="dropdown-item">
                                                                            <i class="fa-solid fa-circle-user"></i>
                                                                            Edit Profil
                                                                        </a>

                                                                        <% if ("Owner".equalsIgnoreCase(currentUser.getRole())) { 
                                                                            if (!"tenant".equalsIgnoreCase(roleSession)) { %>
                                                                                <a href="<%= contextPath %>/owner/reports" class="dropdown-item">
                                                                                    <i class="fa-solid fa-triangle-exclamation"></i>
                                                                                    Report
                                                                                    <c:if test="${not empty pendingReportsCount and pendingReportsCount > 0}">
                                                                                        <span class="report-badge-notification">${pendingReportsCount}</span>
                                                                                    </c:if>
                                                                                </a>
                                                                                <a href="<%= contextPath %>/switch-role" class="dropdown-item" style="color: var(--primary);">
                                                                                    <i class="fa-solid fa-arrows-rotate"></i>
                                                                                    View as Tenant
                                                                                </a>
                                                                            <% } else { %>
                                                                                <a href="<%= contextPath %>/report-history" class="dropdown-item">
                                                                                    <i class="fa-solid fa-triangle-exclamation"></i>
                                                                                    Riwayat Laporan
                                                                                </a>
                                                                                <a href="<%= contextPath %>/switch-role" class="dropdown-item" style="color: var(--primary);">
                                                                                    <i class="fa-solid fa-arrows-rotate"></i>
                                                                                    View as Owner
                                                                                </a>
                                                                            <% } %>
                                                                        <% } else if ("Tenant".equalsIgnoreCase(currentUser.getRole())) { %>
                                                                            <a href="<%= contextPath %>/report-history" class="dropdown-item">
                                                                                <i class="fa-solid fa-triangle-exclamation"></i>
                                                                                Riwayat Laporan
                                                                            </a>
                                                                            <a href="#" id="upgradeOwnerLink" class="dropdown-item upgrade">
                                                                                <i class="fa-solid fa-arrow-up-right-dots"></i>
                                                                                Daftar Jadi Owner
                                                                            </a>
                                                                        <% } else if ("Admin".equalsIgnoreCase(currentUser.getRole())) { %>
                                                                                                <a href="<%= contextPath %>/pages/admin/dashboard_admin.jsp"
                                                                                                    class="dropdown-item">
                                                                                                    <i
                                                                                                        class="fa-solid fa-gauge"></i>
                                                                                                    Dashboard Admin
                                                                                                </a>
                                                                                                <% } %>

                                                                                                    <a href="<%= contextPath %>/logout"
                                                                                                        class="dropdown-item logout">
                                                                                                        <i
                                                                                                            class="fa-solid fa-right-from-bracket"></i>
                                                                                                        Keluar (Logout)
                                                                                                    </a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <% } %>
                                        </div>
                    </div>
                </nav>