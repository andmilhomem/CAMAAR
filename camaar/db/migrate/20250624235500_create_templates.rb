class CreateTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :templates do |t|
      t.string :nome, null: false
      t.datetime :data_versao
    
      t.timestamps
    end
  end
end
