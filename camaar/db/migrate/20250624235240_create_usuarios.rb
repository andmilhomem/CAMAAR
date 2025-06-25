class CreateUsuarios < ActiveRecord::Migration[8.0]
  def change
    create_table :usuarios do |t|
      t.string :nome, null: false
      t.string :formacao, null: false
      t.string :ocupacao, null: false
      t.integer :num_usuario, null: false, unique: true
      t.string :email, null: false, unique: true
      t.boolean :e_admin, null: false, default: false
      t.boolean :esta_ativo, null: false, default: false
      t.string :password_digest, null: false
      t.string :curso
      t.integer :matricula, unique: true
      t.string :departamento

      t.timestamps
    end
  end
end
