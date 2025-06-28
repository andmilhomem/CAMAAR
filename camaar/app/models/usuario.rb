class Usuario < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :formularios
  has_and_belongs_to_many :turmas
  validates :nome, presence: true
  validates :formacao, presence: true
  validates :ocupacao, presence: true, inclusion: {in: ["discente", "docente"], message: "%{value} não é um valor válido"}
  validates :num_usuario, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :e_admin, presence: true
  validates :esta_ativo, presence: true
  validates :password_digest, presence: true
  validates :matricula, uniqueness: true
end
