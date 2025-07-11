class ImportacaoDado < ApplicationRecord
  belongs_to :usuario
  validates :usuario, presence: true
end
