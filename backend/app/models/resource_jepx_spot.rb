# == Schema Information
#
# Table name: resources
#
#  id           :bigint(8)        not null, primary key
#  bg_member_id :bigint(8)
#  type         :string(255)      not null
#  code         :string(255)      not null
#  name         :string(255)      not null
#  supply_value :text(65535)
#  created_by   :integer
#  updated_by   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ResourceJepxSpot < Resource
  protected

  #
  # JEPXスポット調達のレートを取得する
  # @params date [Date] 日付
  # @params time_index [Integer] 時間枠ID
  # @return [Integer] レート
  def get_rate_at(date, time_index)
    raise "method not impremented."
  end
end
