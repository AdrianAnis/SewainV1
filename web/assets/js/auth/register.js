document.addEventListener("DOMContentLoaded", function () {
  const passInput = document.getElementById("password");
  const toggle = document.querySelector(".toggle-pass");
  const inputs = document.querySelectorAll(".field input");


  if (toggle && passInput) {
    toggle.addEventListener("click", function () {
      const isPwd = passInput.getAttribute("type") === "password";
      passInput.setAttribute("type", isPwd ? "text" : "password");
      toggle.setAttribute(
        "aria-label",
        isPwd ? "Hide password" : "Show password",
      );
    });
  }


  function toggleValueClass(el) {
    if (el.value && el.value.trim() !== "") el.classList.add("has-value");
    else el.classList.remove("has-value");
  }

  inputs.forEach((inp) => {
    toggleValueClass(inp);
    inp.addEventListener("input", () => toggleValueClass(inp));
    inp.addEventListener("focus", () => inp.classList.add("focus"));
    inp.addEventListener("blur", () => inp.classList.remove("focus"));
  });


  const form = document.getElementById("registerForm");
  if (form) {
    form.addEventListener("submit", (e) => {
      const fullname = document.getElementById("fullname");
      const email = document.getElementById("email");
      const phone = document.getElementById("phone");
      const password = document.getElementById("password");
      if (!fullname.value || !email.value || !phone.value || !password.value) {
        e.preventDefault();
        if (!fullname.value) fullname.focus();
      }
    });
  }
});
