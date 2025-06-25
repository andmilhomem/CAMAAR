class CreateUsuarios < ActiveRecord::Migration[8.0]
  def change
    create_table :usuarios do |t|
      t.string :nome
      t.string :formacao
      t.string :ocupacao
      t.integer :num_usuario
      t.string :email
      t.boolean :e_admin
      t.boolean :esta_ativo
      t.string :password_digest
      t.string :curso
      t.integer :matricula
      t.string :departamento

      t.timestamps
    end
  end
end
