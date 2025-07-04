require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  describe "GET /formularios" do
    let(:usuario) { create(:usuario) }

    before do
      allow_any_instance_of(ActionDispatch::Request)
        .to receive(:session).and_return({ usuario_id: usuario.id })
    end

    it "lista formulários não respondidos da turma" do
      turma = create(:turma)
      formulario = create(:formulario, turma: turma)
      usuario.turmas << turma

      get formularios_path

      expect(response.body).to include(formulario.nome)
    end

    it "mostra mensagem quando não há formulários disponíveis" do
      get formularios_path
      expect(response.body).to include("Nenhum formulário disponível para resposta")
    end
  end
end
