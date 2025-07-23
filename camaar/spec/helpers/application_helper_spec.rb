require 'rails_helper'
describe ApplicationHelper, type: :helper do
  describe "método nome_da_pagina" do
    it "retorna nome da página associada ao login_path" do
      request.path = login_path
      expect(helper.nome_da_pagina).to eq("Login")
    end

    it "retorna nome da página associada ao redefinir_senha_path" do
      request.path = redefinir_senha_path
      expect(helper.nome_da_pagina).to eq("Redefinição de senha")
    end

    it "retorna nome da página associada ao resposta_formularios_path" do
      request.path = resposta_formularios_path
      expect(helper.nome_da_pagina).to eq("Gerenciamento - Resultados")
    end
  end
end