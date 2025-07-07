class Questao < ApplicationRecord
  belongs_to :template
  belongs_to :formulario, optional: true
  has_many :opcaos, dependent: :destroy
  validates :num_questao, presence: true
  validates :tipo, presence: true, inclusion: {in: ["Radio", "Texto"], message: "%{value} não é um valor válido"}
  validates :enunciado, presence: true
  accepts_nested_attributes_for :opcaos
end
