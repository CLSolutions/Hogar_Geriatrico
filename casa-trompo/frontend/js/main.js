/* Casa Trompo comportamiento compartido  */
(() => {
  "use strict";

  const $ = (selector, scope = document) => scope.querySelector(selector);
  const $$ = (selector, scope = document) => [
    ...scope.querySelectorAll(selector),
  ];

  /*  Preferencias de accesibilidad compartidas entre páginas  */
  const accessibilityKey = "casatrompo:accesibilidad";
  const accessibilitySettings = [
    "high-contrast",
    "grayscale",
    "large-text",
    "extra-large-text",
    "underlined-links",
    "reduced-motion",
  ];

  const loadAccessibility = () => {
    try {
      return JSON.parse(localStorage.getItem(accessibilityKey) || "{}");
    } catch (_) {
      return {};
    }
  };

  let a11ySettings = loadAccessibility();
  const saveAccessibility = () => {
    try {
      localStorage.setItem(accessibilityKey, JSON.stringify(a11ySettings));
    } catch (_) {
    }
  };

  const applyAccessibility = () => {
    accessibilitySettings.forEach((name) => {
      document.body.classList.toggle(
        `a11y-${name}`,
        Boolean(a11ySettings[name]),
      );
      document.documentElement.classList.toggle(
        `a11y-${name}`,
        Boolean(a11ySettings[name]),
      );
    });
  };

  // Font Awesome aporta el icono visual; el nombre accesible se conserva para lectores de pantalla.
  const a11yToggle = document.createElement("button");
  a11yToggle.type = "button";
  a11yToggle.className = "a11y-toggle";
  a11yToggle.id = "a11y-toggle";
  a11yToggle.setAttribute("aria-expanded", "false");
  a11yToggle.setAttribute("aria-controls", "a11y-panel");
  a11yToggle.setAttribute("aria-label", "Abrir opciones de accesibilidad");
  a11yToggle.innerHTML =
    '<i class="fa-solid fa-universal-access" aria-hidden="true"></i>';

  const panel = document.createElement("section");
  panel.className = "a11y-panel";
  panel.id = "a11y-panel";
  panel.hidden = true;
  panel.setAttribute("role", "dialog");
  panel.setAttribute("aria-modal", "false");
  panel.setAttribute("aria-labelledby", "a11y-title");
  panel.innerHTML = `
    <h2 id="a11y-title">Accesibilidad</h2>
    <div class="a11y-options">
      <button class="a11y-option" type="button" data-a11y="high-contrast" aria-pressed="false">Alto contraste</button>
      <button class="a11y-option" type="button" data-a11y="grayscale" aria-pressed="false">Escala de grises</button>
      <button class="a11y-option a11y-option--unavailable" type="button" disabled aria-describedby="dark-mode-note">Modo oscuro</button>
      <span class="a11y-note" id="dark-mode-note">Modo oscuro: próximamente.</span>
      <button class="a11y-option" type="button" data-a11y="large-text" aria-pressed="false">Texto grande</button>
      <button class="a11y-option" type="button" data-a11y="extra-large-text" aria-pressed="false">Texto extra grande</button>
      <button class="a11y-option" type="button" data-a11y="underlined-links" aria-pressed="false">Subrayar enlaces</button>
      <button class="a11y-option" type="button" data-a11y="reduced-motion" aria-pressed="false">Reducir movimiento</button>
    </div>
    <button class="a11y-option a11y-reset" type="button" data-a11y-reset>Restablecer ajustes</button>
  `;

  document.body.append(a11yToggle, panel);
  applyAccessibility();

  $$("[data-a11y]", panel).forEach((button) => {
    const name = button.dataset.a11y;
    button.setAttribute("aria-pressed", String(Boolean(a11ySettings[name])));
    button.addEventListener("click", () => {
      if (name === "large-text" && !a11ySettings[name])
        a11ySettings["extra-large-text"] = false;
      if (name === "extra-large-text" && !a11ySettings[name])
        a11ySettings["large-text"] = false;
      a11ySettings[name] = !a11ySettings[name];
      saveAccessibility();
      applyAccessibility();
      $$("[data-a11y]", panel).forEach((option) => {
        option.setAttribute(
          "aria-pressed",
          String(Boolean(a11ySettings[option.dataset.a11y])),
        );
      });
    });
  });

  const setPanel = (open) => {
    panel.hidden = !open;
    a11yToggle.setAttribute("aria-expanded", String(open));
    if (open) $(".a11y-option", panel).focus();
  };

  a11yToggle.addEventListener("click", () => setPanel(panel.hidden));
  $("[data-a11y-reset]", panel).addEventListener("click", () => {
    a11ySettings = {};
    saveAccessibility();
    applyAccessibility();
    $$("[data-a11y]", panel).forEach((option) =>
      option.setAttribute("aria-pressed", "false"),
    );
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && !panel.hidden) {
      setPanel(false);
      a11yToggle.focus();
    }
  });

  /* Actualiza el año mostrado en el pie sin editar cada página. */
  $$("[data-year]").forEach((el) => {
    el.textContent = new Date().getFullYear();
  });

  /* ---------- Menú móvil ---------- */
  const header = $(".site-header");
  const toggle = $(".nav-toggle");

  if (header && toggle) {
    const setMenu = (open) => {
      header.classList.toggle("is-open", open);
      toggle.setAttribute("aria-expanded", String(open));
      toggle.setAttribute("aria-label", open ? "Cerrar menú" : "Abrir menú");
    };

    toggle.addEventListener("click", () =>
      setMenu(!header.classList.contains("is-open")),
    );

    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape" && header.classList.contains("is-open")) {
        setMenu(false);
        toggle.focus();
      }
    });

    $$(".site-nav a").forEach((link) =>
      link.addEventListener("click", () => setMenu(false)),
    );

    // Si se agranda la ventana, el menú móvil se cierra
    window.matchMedia("(min-width: 960px)").addEventListener("change", (e) => {
      if (e.matches) setMenu(false);
    });
  }

  /* ---------- Cabecera transparente → cálida al hacer scroll ---------- */
  if (header && header.classList.contains("is-transparent")) {
    const onScroll = () =>
      header.classList.toggle("is-scrolled", window.scrollY > 40);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
  }

  /* ---------- Mostrar / ocultar contraseña ---------- */
  $$("[data-toggle-password]").forEach((button) => {
    const input = document.getElementById(button.dataset.togglePassword);
    if (!input) return;
    button.addEventListener("click", () => {
      const show = input.type === "password";
      input.type = show ? "text" : "password";
      button.textContent = show ? "Ocultar" : "Mostrar";
      button.setAttribute("aria-pressed", String(show));
    });
  });

  /* ---------- Confirmar contraseña (registro.html) ---------- */
  const password = $("#password");
  const confirm = $("#confirm");
  const confirmError = $("#confirm-error");
  const passwordStrength = $("#password-strength");
  const passwordStrengthLabel = $("#password-strength-label");

  const updatePasswordStrength = () => {
    if (!password || !passwordStrength || !passwordStrengthLabel) return;
    const strengthBar = $(".password-strength__bar", passwordStrength);
    if (!strengthBar) return;

    const value = password.value;
    if (!value) {
      passwordStrength.setAttribute("aria-valuenow", "0");
      passwordStrength.setAttribute("aria-valuetext", "Sin evaluar");
      passwordStrength.dataset.strength = "empty";
      strengthBar.style.width = "0";
      passwordStrengthLabel.textContent = "Escribe una contraseña";
      return;
    }

    let score = 1;
    if (value.length >= 8) score++;
    if (value.length >= 12) score++;
    if (/[a-z]/.test(value) && /[A-Z]/.test(value)) score++;
    if (/\d/.test(value)) score++;
    if (/[^A-Za-z0-9]/.test(value)) score++;

    const levels = [
      "",
      "Muy débil",
      "Débil",
      "Aceptable",
      "Buena",
      "Fuerte",
      "Muy fuerte",
    ];
    const strength =
      score <= 2
        ? "weak"
        : score <= 3
          ? "fair"
          : score === 4
            ? "good"
            : "strong";

    passwordStrength.setAttribute("aria-valuenow", String(score));
    passwordStrength.setAttribute("aria-valuetext", levels[score]);
    passwordStrength.dataset.strength = strength;
    strengthBar.style.width = `${(score / 6) * 100}%`;
    passwordStrengthLabel.textContent = levels[score];
  };

  if (password && passwordStrength) {
    password.addEventListener("input", updatePasswordStrength);
  }

  if (password && confirm) {
    const check = () => {
      const mismatch = confirm.value !== "" && confirm.value !== password.value;
      const message = mismatch
        ? "Las contraseñas no coinciden. Revísalas e inténtalo de nuevo."
        : "";
      confirm.setCustomValidity(message);
      if (confirmError) confirmError.textContent = message;
    };
    password.addEventListener("input", check);
    confirm.addEventListener("input", check);
    password.form?.addEventListener("reset", () => {
      window.setTimeout(() => {
        updatePasswordStrength();
        check();
      }, 0);
    });
  }

  /* ---------- Contacto: preseleccionar el motivo (?motivo=visita) ---------- */
  const reason = $("#motivo");
  if (reason) {
    const wanted = new URLSearchParams(window.location.search).get("motivo");
    if (wanted && [...reason.options].some((o) => o.value === wanted))
      reason.value = wanted;
  }

  /* ---------- Login: recordar solo el correo (nunca la contraseña) ---------- */
  const STORAGE_KEY = "casatrompo:correo";
  const loginEmail = $("#email");
  const remember = $("#remember");

  if (loginEmail && remember) {
    try {
      const saved = localStorage.getItem(STORAGE_KEY);
      if (saved) {
        loginEmail.value = saved;
        remember.checked = true;
      }
    } catch (_) {
      /* el navegador bloqueó el almacenamiento: seguimos sin recordar */
    }
  }

  /* ---------- Formularios de demostración ----------
     Todavía no hay servidor. Aquí es donde luego conectas el formulario
     (por ejemplo con fetch() hacia tu API en Node/Express o un script PHP).
     El texto del mensaje sale del atributo data-success de cada <form>. */
  $$("form[data-demo-form]").forEach((form) => {
    const status = $(".form-status", form);

    form.addEventListener("submit", (event) => {
      event.preventDefault();

      if (!form.checkValidity()) {
        form.reportValidity();
        return;
      }

      if (remember && loginEmail) {
        try {
          if (remember.checked)
            localStorage.setItem(STORAGE_KEY, loginEmail.value);
          else localStorage.removeItem(STORAGE_KEY);
        } catch (_) {
          /* sin almacenamiento disponible */
        }
      }

      if (status) {
        status.textContent = form.dataset.success || "Listo.";
        status.hidden = false;
        status.focus();
      }

      if (!form.hasAttribute("data-keep-values")) form.reset();
    });
  });
})();
