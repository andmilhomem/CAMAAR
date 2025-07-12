require 'rails_helper'


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

