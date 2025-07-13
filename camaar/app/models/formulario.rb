class Formulario < ApplicationRecord
  belongs_to :turma
  has_many :questaos, dependent: :destroy
  has_many :resposta_formularios, dependent: :destroy
  has_and_belongs_to_many :usuarios
  accepts_nested_attributes_for :questaos
  scope :respondidos, -> { where.associated(:resposta_formularios) }
end
