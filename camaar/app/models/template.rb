class Template < ApplicationRecord
  has_many :questaos, dependent: :destroy
end
