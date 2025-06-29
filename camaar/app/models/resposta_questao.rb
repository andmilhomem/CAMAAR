class RespostaQuestao < ApplicationRecord
  belongs_to :resposta_formulario
  validates :texto_resposta, presence: true
  validates :num_questao, presence: true
end
