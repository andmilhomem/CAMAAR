class RespostaFormulario < ApplicationRecord
  belongs_to :formulario
  has_many :resposta_questaos, dependent: :destroy
  accepts_nested_attributes_for :resposta_questaos
end
