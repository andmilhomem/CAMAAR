class Template < ApplicationRecord
  has_many :questaos, dependent: :destroy
  accepts_nested_attributes_for :questaos
end
