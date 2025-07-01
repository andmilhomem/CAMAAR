class CreateJoinTableUsuariosTurmas < ActiveRecord::Migration[8.0]
  def change
    create_join_table :usuarios, :turmas do |t|
      t.index [:usuario_id, :turma_id], unique: true
      t.index [:turma_id, :usuario_id], unique: true
    end
  end
end
