require 'rails_helper'

# RSpec da feature/resposta
RSpec.describe "RespostaFormularios", type: :request do
  let!(:usuario)    { create(:usuario, :admin, password: "Senh@123", password_confirmation: "Senh@123") }
  let!(:disciplina) { create(:disciplina) }
  let!(:turma)      { create(:turma, disciplina: disciplina) }
  let!(:template)   { create(:template) }
  let!(:formulario) { create(:formulario, turma: turma) }

  before do
    # login real
    post "/login_para_teste", params: { email: usuario.email}

    usuario.turmas << turma

    @q_texto = create(:questao, formulario: formulario,
                               template:   template,
                               tipo:       'Texto',
                               num_questao:1)
    @q_radio = create(:questao, :radio,
                               formulario:  formulario,
                               template:    template,
                               num_questao:2)
    create(:opcao, questao: @q_radio, num_opcao: 1, texto_opcao: 'Sim')
    create(:opcao, questao: @q_radio, num_opcao: 2, texto_opcao: 'Não')
  end

  describe "GET /resposta_formularios/new" do
    it "exibe o form de resposta" do
      get new_resposta_formulario_path, params: { formulario_id: formulario.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include(@q_texto.enunciado)
    end
  end

  describe "POST /resposta_formularios" do
    context "com dados validos" do
      let(:respostas) do
        {
          @q_texto.id.to_s => "resposta texto",
          @q_radio.id.to_s => @q_radio.opcaos.first.id.to_s
        }
      end

      it "salva e redireciona com notice" do
        post resposta_formularios_path,
             params: { formulario_id: formulario.id, respostas: respostas }
        expect(usuario.formularios).to include(formulario)
      #  expect(session[:formularios_respondidos]).to include(formulario.id)
        expect(response).to redirect_to(formularios_path)

        follow_redirect!
        expect(response.body).to include("Resposta enviada com sucesso!")

        expect(RespostaFormulario.count).to eq(1)
        expect(RespostaQuestao.count).to    eq(2)
      end
    end

    context "com dados invalidos" do
      it "re-renderiza new com alert" do
        post resposta_formularios_path,
             params: { formulario_id: formulario.id, respostas: {} }

        expect(response).to have_http_status(:success)
        expect(response.body).to include("Todos os campos devem ser preenchidos!")
      end
    end

    context "quando ocorre erro interno" do
      before do
        # stubamos para lançar quando o create! for chamado
        allow(RespostaFormulario).to receive(:create!).and_raise("DB error")
      end

      it "exibe flash alert de erro" do
        # payload válido, com texto + rádio
        respostas_error = {
          @q_texto.id.to_s => "resposta texto",
          @q_radio.id.to_s => @q_radio.opcaos.first.id.to_s
        }

        post resposta_formularios_path,
             params: { formulario_id: formulario.id,
                       respostas: respostas_error }

        expect(response).to have_http_status(:success)
        # agora deve aparecer a mensagem do rescue
        expect(response.body).to include("Erro ao enviar: DB error")
      end
    end
  end
end

# RSpec da feature/formulario

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
        expect(response.body).to include "Nenhum formulário respondido!"
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
        expect(response.body).not_to include "Nenhum formulário respondido!"
      end
    end
  end

  describe "GET /resposta_formularios com parâmetro form_id" do
    context "quando o formulário possui respostas" do

      before do
        Formulario.destroy_all
        RespostaFormulario.destroy_all
        @resposta_1 = create(:resposta_formulario, :com_duas_questoes)
        @resposta_outro_formulario = create(:resposta_formulario, :com_duas_questoes)
      end
      
      it "deve realizar download do arquivo .csv" do
        get "/resposta_formularios?form_id=#{@resposta_1.formulario_id}"
        expect(response.headers['Content-Disposition'])
          .to include ".csv"
        expect(response.headers['Content-Disposition'])
          .to include "attachment;"
      end
      
      it "arquivo deve ter cabeçalho" do
        get "/resposta_formularios?form_id=#{@resposta_1.formulario_id}"
        primeira_linha = response.body.split("\n")[0]
        expect(primeira_linha).to eq "id,data_resposta,num_questao,texto_resposta"
      end

      it "arquivo deve mostrar APENAS respostas do formulario especificado" do
        get "/resposta_formularios?form_id=#{@resposta_1.formulario_id}"
        resposta_questao = @resposta_1.resposta_questaos[0]
        expect(response.body)
          .to include "#{@resposta_1.id.to_s},#{@resposta_1.data_resposta},#{resposta_questao.num_questao.to_s},#{resposta_questao.texto_resposta}"
        expect(response.body)
          .not_to include "#{@resposta_outro_formulario.formulario_id},#{@resposta_outro_formulario.data_resposta}"
      end
    end
  end
end