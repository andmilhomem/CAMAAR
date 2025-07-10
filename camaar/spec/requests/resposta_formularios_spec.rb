require 'rails_helper'

RSpec.describe "RespostaFormularios", type: :request do
  
  before do
    usuario = create(:usuario, :admin)
    post "/login_para_teste", params: {email: usuario.email}
  end

  describe "GET /index" do

    before do
      Formulario.destroy_all
      RespostaFormulario.destroy_all
    end

    context "quando não há nenhuma resposta enviada" do
      it "deve mostrar mensagem" do
        get "/resposta_formularios"
        expect(response).to have_http_status(:success)
        expect(response.body).to include "Nenhum formulário cadastrado!"
      end
    end

    context "quando já existe ao menos uma resposta enviada" do
      before do
        create(:resposta_formulario, :com_duas_questoes)
        create(:resposta_formulario, :com_duas_questoes)
        create(:formulario, :com_duas_questoes)
      end

      it "mostra apenas formularios que já possuem resposta" do
        formulario_sem_resposta = Formulario.where.missing(:resposta_formularios).first
        get "/resposta_formularios"
        expect(response).to have_http_status(:success)
        expect(response.body).not_to include formulario_sem_resposta.turma.disciplina.nome
      end

      it "mostra nome da disciplina dos formulários" do
        formulario = Formulario.respondidos.first
        get "/resposta_formularios"
        expect(response.body).to include formulario.turma.disciplina.nome
        expect(response.body).not_to include "Nenhum formulário cadastrado!"
      end
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/resposta_formularios/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/resposta_formularios/create"
      expect(response).to have_http_status(:success)
    end
  end

end