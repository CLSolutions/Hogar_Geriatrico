/*
 * Módulo de gestión del formulario de contacto público — Casa Trompo
 * Cumple con sanitización XSS (textContent) y retroalimentación accesible WCAG AAA.
 */

const API_CONTACT_ENDPOINT = '/api/contact';

/**
 * Muestra retroalimentación accesible en el DOM sin usar innerHTML.
 * @param {HTMLElement} container
 * @param {string} message
 * @param {'success' | 'danger'} variant
 */
function renderFeedback(container, message, variant) {
  container.textContent = '';
  container.setAttribute('role', variant === 'danger' ? 'alert' : 'status');

  const alertBox = document.createElement('div');
  alertBox.className = `alert alert-${variant} fw-semibold`;
  alertBox.textContent = message;

  container.appendChild(alertBox);
}

/* ------Inicializa el listener del formulario de contacto. ------*/
function initContactForm() {
  const form = document.getElementById('contactForm');
  const feedbackContainer = document.getElementById('contactFeedback');

  if (!form || !feedbackContainer) {
    return;
  }

  form.addEventListener('submit', async (event) => {
    event.preventDefault();

    if (!form.checkValidity()) {
      form.classList.add('was-validated');
      renderFeedback(
        feedbackContainer,
        'Por favor completa correctamente todos los campos obligatorios.',
        'danger'
      );
      return;
    }

    const submitButton = form.querySelector('button[type="submit"]');
    const formData = new FormData(form);

    // Construcción del payload JSON esperado por POST /api/contact
    const payload = {
      fullName: String(formData.get('fullName') || '').trim(),
      email: String(formData.get('email') || '').trim(),
      phone: String(formData.get('phone') || '').trim(),
      subject: String(formData.get('subject') || '').trim(),
      message: String(formData.get('message') || '').trim(),
    };

    try {
      if (submitButton) {
        submitButton.disabled = true;
      }

      const response = await fetch(API_CONTACT_ENDPOINT, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });

      const data = await response.json().catch(() => ({}));

      if (!response.ok) {
        throw new Error(
          data.error || 'No fue posible registrar tu consulta. Intenta nuevamente.'
        );
      }

      form.reset();
      form.classList.remove('was-validated');
      renderFeedback(
        feedbackContainer,
        data.message || 'Consulta recibida correctamente. Nuestro equipo se comunicará pronto.',
        'success'
      );
    } catch (error) {
      renderFeedback(
        feedbackContainer,
        error instanceof Error ? error.message : 'Error de conexión con el servidor.',
        'danger'
      );
    } finally {
      if (submitButton) {
        submitButton.disabled = false;
      }
    }
  });
}

document.addEventListener('DOMContentLoaded', initContactForm);