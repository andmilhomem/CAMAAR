document.addEventListener('DOMContentLoaded', function () {
      const botao = document.getElementById('botao');
      const modal = document.getElementById('meuModal');
      const botaoFechar = document.getElementById('fecharModal');

      botao.addEventListener('click', function () {
        modal.style.display = 'flex';
      });

      botaoFechar.addEventListener('click', function () {
        modal.style.display = 'none';
      });

      modal.addEventListener('click', function (event) {
        if (event.target === modal) {
          modal.style.display = 'none';
        }
      });
    });