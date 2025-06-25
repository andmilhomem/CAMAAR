class Questao < ApplicationRecord
  belongs_to :template
  has_many :opcaos, dependent: :destroy
end
