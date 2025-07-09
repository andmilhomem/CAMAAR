class Template < ApplicationRecord
  has_many :questaos, dependent: :destroy
  accepts_nested_attributes_for :questaos
  validates :nome, presence: true, uniqueness: true, length: { maximum: 100 }
end
