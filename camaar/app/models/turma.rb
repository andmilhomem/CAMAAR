class Turma < ApplicationRecord
  belongs_to :disciplina
  has_many :formularios, dependent: :destroy
  has_and_belongs_to_many :usuarios
end
