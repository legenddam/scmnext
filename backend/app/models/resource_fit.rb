# == Schema Information
#
# Table name: resources
#
#  id              :bigint(8)        not null, primary key
#  bg_member_id    :bigint(8)
#  type            :string(255)      not null
#  code            :string(255)      not null
#  name            :string(255)      not null
#  contract_number :string(20)
#  max_value       :decimal(14, )    default(0), not null
#  min_value       :decimal(14, )    default(0), not null
#  unit            :decimal(14, )    default(1), not null
#  created_by      :integer
#  updated_by      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ResourceFit < Resource
  has_many :power_generator_groups, foreign_key: :resource_id
  accepts_nested_attributes_for :power_generator_groups

  class << self
    def json_option_for_show
      {
        methods: [:type],
        include: {
          power_generator_groups: {
            include: :power_generators
          }
        }
      }
    end
  end

  protected
  #
  # FITのレートを取得する
  # @params date [Date] 日付
  # @params time_index [Integer] 時間枠ID
  # @return [Integer] レート
  def get_rate_at(date, time_index)
    raise "method not impremented."
  end

  private
  #
  # 規定値をセットする
  #
  def set_values
    self.name = bg_member.company.name
    self.unit = 1
  end

end
