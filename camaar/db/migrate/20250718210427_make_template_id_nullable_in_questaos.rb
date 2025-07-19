class MakeTemplateIdNullableInQuestaos < ActiveRecord::Migration[8.0]
  def change
    change_column_null :questaos, :template_id, true
    change_column_null :questaos, :formulario_id, true
  end
end
