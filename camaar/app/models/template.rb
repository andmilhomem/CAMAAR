# Model que representa um template de formulário
# Um template contém questões que podem ser reutilizadas para criar formulários
# Suporta questões aninhadas com opções para questões do tipo Radio
class Template < ApplicationRecord
  # Associação: um template possui muitas questões
  has_many :questaos, dependent: :destroy
  # Permite atributos aninhados para questões
  accepts_nested_attributes_for :questaos
  # Validações de nome
  validates :nome, presence: true, uniqueness: true, length: { maximum: 100 }

  # Remove todas as questões associadas a este template
  #
  # @return [Array<Questao>] Array de questões destruídas
  # @note Este método altera o banco de dados, removendo registros de questões
  def remover_questoes_antigas
    questaos.destroy_all
  end
end
