class CreateVoltageTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :voltage_types do |t|
      t.string "name", comment: "名前"
      t.stamp_fileds
    end
  end
end
