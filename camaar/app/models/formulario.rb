class Formulario < ApplicationRecord
  belongs_to :turma
  has_many :resposta_formularios, dependent: :destroy
  has_and_belongs_to_many :usuarios
end
