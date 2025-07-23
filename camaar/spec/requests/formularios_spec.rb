require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  let!(:usuario)    { create(:usuario, :admin, password: "Senh@123", password_confirmation: "Senh@123") }
  let!(:disciplina) { create(:disciplina) }
  let!(:turma)      { create(:turma, disciplina: disciplina) }
  let!(:template) {create(:template, :com_duas_questoes)}


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

  describe "GET /formularios/new" do
    context "quando não há templates ou turmas disponíveis" do
      
      it "redireciona para tela de admin com mensagem de erro" do
        Turma.destroy_all
        get "/formularios/new"
        expect(response).to redirect_to(admin_path)
        expect(flash[:alert]).to eql "Nenhuma turma disponível!"
      end

      it "redireciona para tela de admin com mensagem de erro" do
        Template.destroy_all
        get "/formularios/new"
        expect(response).to redirect_to(admin_path)
        expect(flash[:alert]).to eql "Nenhum template disponível!"
      end
    end

    context "quando há templates e turmas disponíveis" do
      let!(:turma2) {create(:turma)}
      let!(:template2) {create(:template, :com_duas_questoes)}
      let!(:template3) {create(:template, :com_duas_questoes)}

      it "retorna sucesso e exibe turmas disponiveis" do
        get "/formularios/new"
        expect(response).to have_http_status(:success)
        expect(response.body).to include turma.disciplina.nome
        expect(response.body).to include turma2.disciplina.nome
        expect(response.body.scan('type="checkbox"').size).to equal 2
      end

      it "exibe templates disponíveis em um dropdown" do
        get "/formularios/new"
        expect(response.body).to include "<select"
        expect(response.body).to match (/\<option.*\>#{template.nome}/)
        expect(response.body).to match (/\<option.*\>#{template2.nome}/)
        expect(response.body).to match (/\<option.*\>#{template3.nome}/)
      end
    end
  end

  describe 'POST /formularios' do
    context 'com parâmetros válidos' do
      it 'cria novos formulários para as turmas selecionadas' do
        expect {
          post "/formularios", params: { turma_ids: [turma.id], template_id: template.id }
        }.to change(Formulario, :count).by(1)
      end

      it 'copia questões do template para cada formulário' do
        expect {
          post "/formularios", params: { turma_ids: [turma.id], template_id: template.id }
        }.to change(Questao, :count).by(2)
      end

      it 'copia opções para questões do tipo rádio' do
        expect {
          post "/formularios", params: { turma_ids: [turma.id], template_id: template.id }
        }.to change(Opcao, :count).by(2)
      end

      it 'define o formulario_id nas questões copiadas' do
        post "/formularios", params: { turma_ids: [turma.id], template_id: template.id }
        expect(Questao.last.formulario_id).to eq(Formulario.last.id)
      end

      it 'redireciona para admin_path com mensagem de sucesso' do
        post "/formularios", params: { turma_ids: [turma.id], template_id: template.id }
        expect(response).to redirect_to(admin_path)
        expect(flash[:notice]).to be_present
      end
    end

    context 'com múltiplas turmas' do
      let(:turma2) { create(:turma, disciplina: disciplina) }

      it 'cria formulários para cada turma selecionada' do
        expect {
          post "/formularios", params: { turma_ids: [turma.id, turma2.id], template_id: template.id }
        }.to change(Formulario, :count).by(2)
      end
    end

    context 'com parâmetros inválidos' do
      it 'redireciona quando nenhum template é selecionado' do
        post "/formularios", params: { turma_ids: [turma.id], template_id: nil }
        expect(response).to redirect_to(new_formulario_path)
        expect(flash[:alert]).to eq('Preencha todas as informações necessárias!')
      end

      it 'redireciona quando nenhuma turma é selecionada' do
        post "/formularios", params: { turma_ids: nil, template_id: template.id }
        expect(response).to redirect_to(new_formulario_path)
        expect(flash[:alert]).to eq('Preencha todas as informações necessárias!')
      end
    end
  end
end