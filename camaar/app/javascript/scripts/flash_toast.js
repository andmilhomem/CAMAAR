function initToasts() {
  document
    .querySelectorAll("#flash-container .toast")
    .forEach(toast => {
      // evita múltiplas inicializações
      if (toast.dataset._toastInitialized) return;
      toast.dataset._toastInitialized = "true";

      // quando a animação (fadeOut) terminar, remove o toast do DOM
      toast.addEventListener("animationend", () => {
        if (toast.parentNode) {
          toast.parentNode.removeChild(toast);
        }
      });
    });
}

// dispara tanto no carregamento inicial quanto em navegações Turbo
document.addEventListener("DOMContentLoaded", initToasts);
document.addEventListener("turbo:load",      initToasts);
