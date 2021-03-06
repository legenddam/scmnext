class CreateMatchingTradeSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :matching_trade_settings, comment: "相対取引設定" do |t|
      t.references :resource, comment: "リソースID"
      t.string :year_pattern, null: false, default: "*", comment: "年パターン"
      t.string :month_pattern, null: false, default: "*", comment: "月パターン"
      t.string :day_pattern, null: false, default: "*", comment: "日パターン"
      t.string :day_of_week_pattern, null: false, default: "*", comment: "曜日パターン"
      t.integer :time_index_1, null: false, default: 0, comment: "時間枠1値"
      t.integer :time_index_2, null: false, default: 0, comment: "時間枠2値"
      t.integer :time_index_3, null: false, default: 0, comment: "時間枠3値"
      t.integer :time_index_4, null: false, default: 0, comment: "時間枠4値"
      t.integer :time_index_5, null: false, default: 0, comment: "時間枠5値"
      t.integer :time_index_6, null: false, default: 0, comment: "時間枠6値"
      t.integer :time_index_7, null: false, default: 0, comment: "時間枠7値"
      t.integer :time_index_8, null: false, default: 0, comment: "時間枠8値"
      t.integer :time_index_9, null: false, default: 0, comment: "時間枠9値"
      t.integer :time_index_10, null: false, default: 0, comment: "時間枠10値"
      t.integer :time_index_11, null: false, default: 0, comment: "時間枠11値"
      t.integer :time_index_12, null: false, default: 0, comment: "時間枠12値"
      t.integer :time_index_13, null: false, default: 0, comment: "時間枠13値"
      t.integer :time_index_14, null: false, default: 0, comment: "時間枠14値"
      t.integer :time_index_15, null: false, default: 0, comment: "時間枠15値"
      t.integer :time_index_16, null: false, default: 0, comment: "時間枠16値"
      t.integer :time_index_17, null: false, default: 0, comment: "時間枠17値"
      t.integer :time_index_18, null: false, default: 0, comment: "時間枠18値"
      t.integer :time_index_19, null: false, default: 0, comment: "時間枠19値"
      t.integer :time_index_20, null: false, default: 0, comment: "時間枠20値"
      t.integer :time_index_21, null: false, default: 0, comment: "時間枠21値"
      t.integer :time_index_22, null: false, default: 0, comment: "時間枠22値"
      t.integer :time_index_23, null: false, default: 0, comment: "時間枠23値"
      t.integer :time_index_24, null: false, default: 0, comment: "時間枠24値"
      t.integer :time_index_25, null: false, default: 0, comment: "時間枠25値"
      t.integer :time_index_26, null: false, default: 0, comment: "時間枠26値"
      t.integer :time_index_27, null: false, default: 0, comment: "時間枠27値"
      t.integer :time_index_28, null: false, default: 0, comment: "時間枠28値"
      t.integer :time_index_29, null: false, default: 0, comment: "時間枠29値"
      t.integer :time_index_30, null: false, default: 0, comment: "時間枠30値"
      t.integer :time_index_31, null: false, default: 0, comment: "時間枠31値"
      t.integer :time_index_32, null: false, default: 0, comment: "時間枠32値"
      t.integer :time_index_33, null: false, default: 0, comment: "時間枠33値"
      t.integer :time_index_34, null: false, default: 0, comment: "時間枠34値"
      t.integer :time_index_35, null: false, default: 0, comment: "時間枠35値"
      t.integer :time_index_36, null: false, default: 0, comment: "時間枠36値"
      t.integer :time_index_37, null: false, default: 0, comment: "時間枠37値"
      t.integer :time_index_38, null: false, default: 0, comment: "時間枠38値"
      t.integer :time_index_39, null: false, default: 0, comment: "時間枠39値"
      t.integer :time_index_40, null: false, default: 0, comment: "時間枠40値"
      t.integer :time_index_41, null: false, default: 0, comment: "時間枠41値"
      t.integer :time_index_42, null: false, default: 0, comment: "時間枠42値"
      t.integer :time_index_43, null: false, default: 0, comment: "時間枠43値"
      t.integer :time_index_44, null: false, default: 0, comment: "時間枠44値"
      t.integer :time_index_45, null: false, default: 0, comment: "時間枠45値"
      t.integer :time_index_46, null: false, default: 0, comment: "時間枠46値"
      t.integer :time_index_47, null: false, default: 0, comment: "時間枠47値"
      t.integer :time_index_48, null: false, default: 0, comment: "時間枠48値"
      t.stamp_fileds
    end
  end
end
