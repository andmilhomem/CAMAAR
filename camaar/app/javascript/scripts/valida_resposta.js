document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("resposta-form");

  form.addEventListener("submit", (e) => {
    // percorre cada bloco .questao e verifica se foi preenchido
    let valido = true;
    document.querySelectorAll(".questao").forEach(qBlock => {
      const qid = qBlock.dataset.id;
      const textarea = qBlock.querySelector("textarea");
      const radios   = qBlock.querySelectorAll("input[type=radio]");
      let preenchido = false;

      if (textarea) {
        preenchido = textarea.value.trim() !== "";
      } else if (radios.length) {
        preenchido = Array.from(radios).some(r => r.checked);
      }

      // mostra erro no bloco, se necessário
      let erroTag = qBlock.querySelector(".erro-validacao");
      if (!erroTag) {
        erroTag = document.createElement("div");
        erroTag.className = "erro-validacao";
        erroTag.style.color = "#c00";
        erroTag.style.fontSize = "0.9rem";
        erroTag.style.marginTop = "0.25rem";
        qBlock.appendChild(erroTag);
      }
      if (!preenchido) {
        valido = false;
        erroTag.textContent = "Este campo é obrigatório.";
      } else {
        erroTag.textContent = "";
      }
    });

    if (!valido) {
      e.preventDefault();  // cancela o submit
    }
  });
});
