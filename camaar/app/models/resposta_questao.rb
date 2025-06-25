class RespostaQuestao < ApplicationRecord
  belongs_to :resposta_formulario
  validates :texto_resposta, presence: true
end
