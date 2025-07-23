require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the FormulariosHelper. For example:
#
# describe FormulariosHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
# 
describe FormulariosHelper, type: :helper do
  describe "método get_nome_professor" do
    before do
      @docente = create(:usuario, :docente)
      @turma = create(:turma)
      @docente.turmas << @turma
    end
    it "retorna nome do docente associado à turma" do
      expect(helper.get_nome_professor(@turma)).to eq(@docente.nome)
    end
  end
end