class CreateJoinTableUsuariosFormularios < ActiveRecord::Migration[8.0]
  def change
    create_join_table :usuarios, :formularios do |t|
      # t.index [:usuario_id, :formulario_id]
      # t.index [:formulario_id, :usuario_id]
    end
  end
end
