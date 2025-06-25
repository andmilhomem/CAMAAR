class CreateDisciplinas < ActiveRecord::Migration[8.0]
  def change
    create_table :disciplinas do |t|
      t.string :codigo, null: false, unique: true
      t.string :nome, null: false, unique: true

      t.timestamps
    end
  end
end
