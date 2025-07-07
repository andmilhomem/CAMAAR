// Exibe a tela de confirmação de atualização (sobrescrita) de dados
// em resposta a redirect do AdminController#importar_dados

document.addEventListener("turbo:load", () => {
  const params = new URLSearchParams(window.location.search);
  if (params.get("confirmacao") === "true") {
    const modal = document.getElementById("modal-confirmacao-admin");
    if (modal) {
      modal.style.display = "flex";

      const btnDesistir = document.getElementById("botao-desistir-admin");
      if (btnDesistir) {
        btnDesistir.addEventListener("click", () => {
          modal.style.display = "none";
        });
      }

      // Fechar o modal ao enviar o form
      const formAtualizar = document.getElementById("form-atualizar-dados-admin");
      if (formAtualizar) {
        formAtualizar.addEventListener("submit", () => {
          modal.style.display = "none";
        });
      }
    }
  }
});