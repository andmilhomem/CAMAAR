class Opcao < ApplicationRecord
  belongs_to :questao
  validates :num_opcao, presence: true
  validates :texto_opcao, presence: true
end
