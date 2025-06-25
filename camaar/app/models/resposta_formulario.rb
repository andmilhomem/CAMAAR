class RespostaFormulario < ApplicationRecord
  belongs_to :formulario
  has_many :resposta_questaos, dependent: :destroy

end
