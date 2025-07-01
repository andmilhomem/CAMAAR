class CreateUsuarios < ActiveRecord::Migration[8.0]
  def change
    create_table :usuarios do |t|
      t.string :nome, null: false
      t.string :formacao, null: false
      t.string :ocupacao, null: false
      t.integer :num_usuario, null: false
      t.string :email, null: false
      t.boolean :e_admin, null: false, default: false
      t.boolean :esta_ativo, null: false, default: false
      t.string :password_digest, null: false
      t.string :curso
      t.integer :matricula
      t.string :departamento
      t.timestamps
    end

    add_index :usuarios, :num_usuario, unique: true
    add_index :usuarios, :email, unique: true
    add_index :usuarios, :matricula, unique: true
  end
end
