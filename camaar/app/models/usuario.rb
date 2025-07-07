class Usuario < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :formularios
  has_and_belongs_to_many :turmas

  PASSWORD_REQUIREMENTS = /\A
    (?=.{8,})           # Deve ter no mínimo 8 caracteres
    (?=.*\d)            # Deve conter no mínimo 1 número
    (?=.*[a-z])         # Deve conter no mínimo 1 letra minúscula
    (?=.*[A-Z])         # Deve conter no mínimo 1 letra maiúscula
    (?=.*[[:^alnum:]])  # Deve conter no mínimo 1 caractere especial
  /x

  validates :nome, presence: true
  validates :formacao, presence: true
  validates :ocupacao, presence: true, inclusion: {in: ["discente", "docente"], message: "%{value} não é um valor válido"}
  validates :num_usuario, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :e_admin, inclusion: { in: [true, false] }
  validates :esta_ativo, inclusion: { in: [true, false] }
  validates :password_digest, presence: true
  validates :matricula, uniqueness: true
  validates :password, 
            format: { 
              with: PASSWORD_REQUIREMENTS,
              message: "deve conter no mínimo 8 caracteres, incluindo uma letra maiúscula, uma minúscula, um número e um caractere especial." 
            }, 
            if: -> { new_record? || !password.nil? }

  #faz a diferenciação do usuário comum para o admin
  def admin?
    self.e_admin
  end
end
