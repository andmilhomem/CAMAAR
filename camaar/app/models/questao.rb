class Questao < ApplicationRecord
  belongs_to :template
  has_many :opcaos, dependent: :destroy
  validates :num_questao, presence: true
  validates :tipo, presence: true, inclusion: {in: ["Radio", "Texto"], message: "%{value} não é um valor válido"}
  validates :enunciado, presence: true
end
