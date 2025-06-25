class CreateJoinTableUsuariosTurmas < ActiveRecord::Migration[8.0]
  def change
    create_join_table :usuarios, :turmas do |t|
      # t.index [:usuario_id, :turma_id]
      # t.index [:turma_id, :usuario_id]
    end
  end
end
