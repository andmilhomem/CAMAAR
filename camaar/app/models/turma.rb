class Turma < ApplicationRecord
  belongs_to :disciplina
  has_many :formularios, dependent: :destroy
  has_and_belongs_to_many :usuarios
  validates :codigo, presence: true
  validates :semestre, presence: true
  validates :horario, presence: true

  def nome_professor
    professor = usuarios.find_by :ocupacao => "docente"
    professor ? professor.nome : "N/A"
  end
end