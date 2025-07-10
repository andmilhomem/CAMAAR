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

  describe "GET /formulario/:id" do
    context "quando o formulário possui respostas" do

      before do
        Formulario.destroy_all
        RespostaFormulario.destroy_all
        @resposta_1 = create(:resposta_formulario, :com_duas_questoes)
        @resposta_outro_formulario = create(:resposta_formulario, :com_duas_questoes)
      end
      
      it "deve realizar download do arquivo .csv" do
        get "/resposta_formularios/#{@resposta_1.formulario_id}"
        expect(response.headers['Content-Disposition'])
          .to include ".csv"
        expect(response.headers['Content-Disposition'])
          .to include "attachment;"
      end
      
      it "arquivo deve ter cabeçalho" do
        get "/resposta_formularios/#{@resposta_1.formulario_id}"
        primeira_linha = response.body.split("\n")[0]
        expect(primeira_linha).to eq "id,data_resposta,num_questao,texto_resposta"
      end

      it "arquivo deve mostrar APENAS respostas do formulario especificado" do
        get "/resposta_formularios/#{@resposta_1.formulario_id}"
        resposta_questao = @resposta_1.resposta_questaos[0]
        expect(response.body)
          .to include "#{@resposta_1.id.to_s},#{@resposta_1.data_resposta},#{resposta_questao.num_questao.to_s},#{resposta_questao.texto_resposta}"
        expect(response.body)
          .not_to include "#{@resposta_outro_formulario.formulario_id},#{@resposta_outro_formulario.data_resposta}"
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