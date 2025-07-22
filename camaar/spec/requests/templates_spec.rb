require 'rails_helper'

RSpec.describe "Templates", type: :request do
  let(:admin) { Usuario.create!(nome: 'Admin', formacao: 'Doutor', ocupacao: 'docente', num_usuario: 1, email: 'admin@admin.com', e_admin: true, esta_ativo: true, password: 'Senh@123', password_confirmation: 'Senh@123') }
  let(:usuario) { Usuario.create!(nome: 'User', formacao: 'Graduando', ocupacao: 'discente', num_usuario: 2, email: 'user@user.com', e_admin: false, esta_ativo: true, password: 'Senh@123', password_confirmation: 'Senh@123') }
  let(:template) { create(:template) }

  before do
    post "/login_para_teste", params: { email: admin.email }
  end

  describe 'acesso restrito a admin' do
    it 'permite admin acessar index' do
      get templates_path
      expect(response).to have_http_status(:success)
    end

    it 'não permite usuário comum acessar index' do
      post "/login_para_teste", params: { email: usuario.email }
      get templates_path
      expect(response).to redirect_to(root_path)
      follow_redirect!
    end
  end

  describe 'GET /templates' do
    it 'retorna lista de templates' do
      template1 = create(:template, nome: 'Template 1')
      template2 = create(:template, nome: 'Template 2')
      
      get templates_path
      
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Template 1')
      expect(response.body).to include('Template 2')
    end
  end

  describe 'GET /templates/new' do
    it 'retorna formulário de novo template' do
      get new_template_path
      
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Criar')
    end
  end

  describe 'POST /templates' do
    context 'com parâmetros válidos' do
      let(:valid_params) do
        {
          template: {
            nome: 'Novo Template',
            questaos_attributes: [
              {
                num_questao: 1,
                tipo: 'Texto',
                enunciado: 'Pergunta 1?'
              },
              {
                num_questao: 2,
                tipo: 'Radio',
                enunciado: 'Pergunta 2?',
                opcaos_attributes: [
                  { num_opcao: 1, texto_opcao: 'Sim' },
                  { num_opcao: 2, texto_opcao: 'Não' }
                ]
              }
            ]
          }
        }
      end

      it 'cria template com sucesso' do
        expect {
          post templates_path, params: valid_params
        }.to change(Template, :count).by(1)
          .and change(Questao, :count).by(2)
          .and change(Opcao, :count).by(2)

        expect(response).to redirect_to(templates_path)
        follow_redirect!
        expect(response.body).to include('Template criado com sucesso!')
      end

      it 'cria template via AJAX com sucesso' do
        post templates_path, params: valid_params, xhr: true
        
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be true
        expect(json_response['redirect_url']).to eq(templates_path)
      end
    end

    context 'com parâmetros inválidos' do
      let(:invalid_params) do
        {
          template: {
            nome: '', # nome vazio
            questaos_attributes: []
          }
        }
      end

      it 'não cria template e renderiza formulário com erros' do
        expect {
          post templates_path, params: invalid_params
        }.not_to change(Template, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Erro ao criar template')
      end

      it 'retorna erro via AJAX' do
        post templates_path, params: invalid_params, xhr: true
        
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be false
        expect(json_response['errors']).to include("Nome can't be blank")
      end
    end

    context 'com nome duplicado' do
      before { create(:template, nome: 'Template Existente') }

      let(:duplicate_params) do
        {
          template: {
            nome: 'Template Existente',
            questaos_attributes: []
          }
        }
      end

      it 'não cria template com nome duplicado' do
        expect {
          post templates_path, params: duplicate_params
        }.not_to change(Template, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /templates/:id/edit' do
    it 'retorna formulário de edição' do
      get edit_template_path(template)
      
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Salvar')
      expect(response.body).to include(template.nome)
    end

    it 'retorna 404 para template inexistente' do
      get edit_template_path(999999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PATCH /templates/:id' do
    let(:template_with_questions) { create(:template, :com_duas_questoes) }

    context 'com parâmetros válidos' do
      let(:update_params) do
        {
          template: {
            nome: 'Template Atualizado',
            questaos_attributes: [
              {
                num_questao: 1,
                tipo: 'Texto',
                enunciado: 'Nova pergunta?'
              }
            ]
          }
        }
      end

      it 'atualiza template com sucesso' do
        patch template_path(template_with_questions), params: update_params
        
        expect(response).to redirect_to(templates_path)
        follow_redirect!
        expect(response.body).to include('Template atualizado com sucesso!')
        
        template_with_questions.reload
        expect(template_with_questions.nome).to eq('Template Atualizado')
        expect(template_with_questions.questaos.count).to eq(1)
      end

      it 'atualiza template via AJAX com sucesso' do
        patch template_path(template_with_questions), params: update_params, xhr: true
        
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be true
        expect(json_response['redirect_url']).to eq(templates_path)
      end

      it 'remove questões antigas ao atualizar' do
        original_question_count = template_with_questions.questaos.count
        expect(original_question_count).to be > 0

        patch template_path(template_with_questions), params: update_params
        
        template_with_questions.reload
        expect(template_with_questions.questaos.count).to eq(1)
      end
    end

    context 'com parâmetros inválidos' do
      let(:invalid_update_params) do
        {
          template: {
            nome: '', # nome vazio
            questaos_attributes: []
          }
        }
      end

      it 'não atualiza template e renderiza formulário com erros' do
        original_nome = template_with_questions.nome
        
        patch template_path(template_with_questions), params: invalid_update_params
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Erro ao atualizar template')
        
        template_with_questions.reload
        expect(template_with_questions.nome).to eq(original_nome)
      end

      it 'retorna erro via AJAX' do
        patch template_path(template_with_questions), params: invalid_update_params, xhr: true
        
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be false
        expect(json_response['errors']).to include("Nome can't be blank")
      end
    end

    it 'retorna 404 para template inexistente' do
      patch template_path(999999), params: { template: { nome: 'Teste' } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /templates/:id' do
    let(:template_to_delete) { create(:template) }

    it 'deleta template com sucesso' do
      # Verificar se o template existe antes
      expect(template_to_delete).to be_persisted
      expect(Template.find(template_to_delete.id)).to eq(template_to_delete)
      
      expect {
        delete template_path(template_to_delete)
      }.to change(Template, :count).by(-1)

      expect(response).to redirect_to(templates_path)
      follow_redirect!
      expect(response.body).to include('Template deletado com sucesso!')
    end

    it 'deleta questões não utilizadas por formulários' do
      template_with_questions = create(:template, :com_duas_questoes)
      question_count = template_with_questions.questaos.count
      
      expect {
        delete template_path(template_with_questions)
      }.to change(Template, :count).by(-1)
        .and change(Questao, :count).by(-question_count)

      expect(response).to redirect_to(templates_path)
    end

    it 'retorna 404 para template inexistente' do
      delete template_path(999999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'validações de parâmetros' do
    it 'permite parâmetros válidos' do
      valid_params = {
        template: {
          nome: 'Template Teste',
          questaos_attributes: [
            {
              num_questao: 1,
              tipo: 'Texto',
              enunciado: 'Pergunta?',
              opcaos_attributes: [
                { num_opcao: 1, texto_opcao: 'Opção 1' }
              ]
            }
          ]
        }
      }

      post templates_path, params: valid_params
      expect(response).to redirect_to(templates_path)
    end

    it 'rejeita parâmetros não permitidos' do
      # Este teste verifica se o strong parameters está funcionando
      # Parâmetros não permitidos devem ser ignorados
      invalid_params = {
        template: {
          nome: 'Template Teste',
          created_at: Time.current, # parâmetro não permitido
          questaos_attributes: []
        }
      }

      post templates_path, params: invalid_params
      expect(response).to redirect_to(templates_path)
      
      template = Template.last
      expect(template.created_at).not_to eq(invalid_params[:template][:created_at])
    end
  end
end