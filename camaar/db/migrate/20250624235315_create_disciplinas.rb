class CreateDisciplinas < ActiveRecord::Migration[8.0]
  def change
    create_table :disciplinas do |t|
      t.string :codigo, null: false
      t.string :nome, null: false
      t.timestamps
    end
    add_index :disciplinas, :codigo, unique: true
    add_index :disciplinas, :nome, unique: true
  end
end
