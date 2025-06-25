class Usuario < ApplicationRecord
  has_and_belongs_to_many :formularios
  has_and_belongs_to_many :turmas
end
