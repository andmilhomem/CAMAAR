class CreateTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :templates do |t|
      t.datetime :data_versao

      t.timestamps
    end
  end
end
