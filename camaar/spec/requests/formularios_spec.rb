require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  let!(:usuario)    { create(:usuario, :admin, password: "Senh@123", password_confirmation: "Senh@123") }
  let!(:disciplina) { create(:disciplina) }
  let!(:turma)      { create(:turma, disciplina: disciplina) }

  before do
    # faz login para popular session[:usuario_id]
    post "/login_para_teste", params: { email: usuario.email}
    usuario.turmas << turma
  end

  describe "GET /formularios" do
    context "quando ha formularios pendentes" do
      let!(:formularios) { create_list(:formulario, 3, turma: turma) }

      it "retorna sucesso e exibe cards em grid" do
        get formularios_path

        expect(response).to have_http_status(:success)
        expect(response.body).to match(/class=['"]lista-formularios['"]/)

        formularios.each do |f|
          expect(response.body).to include(f.turma.disciplina.nome)
          expect(response.body).to include("#{f.turma.codigo} (#{f.turma.semestre})")
        end

        expect(response.body).not_to include("Nenhum formulário disponível para resposta")
      end
    end

    context "quando nao ha formularios pendentes" do
      it "mostra mensagem de estado vazio" do
        # sem formularios criados para essa turma
        get formularios_path

        expect(response).to have_http_status(:success)
        expect(response.body).to match(/class=['"]empty-state['"]/)
        expect(response.body).to include("Nenhum formulário disponível para resposta")
      end
    end
  end
end
