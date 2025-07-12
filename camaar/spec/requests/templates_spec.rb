require 'rails_helper'
RSpec.describe "Templates", type: :request do

  describe 'acesso restrito a admin' do
    let(:admin) { Usuario.create!(nome: 'Admin', formacao: 'Doutor', ocupacao: 'docente', num_usuario: 1, email: 'admin@admin.com', e_admin: true, esta_ativo: true, password: 'Senh@123', password_confirmation: 'Senh@123') }
    let(:usuario) { Usuario.create!(nome: 'User', formacao: 'Graduando', ocupacao: 'discente', num_usuario: 2, email: 'user@user.com', e_admin: false, esta_ativo: true, password: 'Senh@123', password_confirmation: 'Senh@123') }

    it 'permite admin acessar index' do
      post "/login_para_teste", params: { email: admin.email}
      get templates_path
      expect(response).to have_http_status(:success)
    end

    it 'não permite usuário comum acessar index' do
      post "/login_para_teste", params: { email: usuario.email}
      get templates_path
      expect(response).to redirect_to(root_path)
      follow_redirect!
    end
  end
end