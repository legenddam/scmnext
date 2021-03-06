# == Schema Information
#
# Table name: facility_groups
#
#  id                :bigint(8)        not null, primary key
#  name              :string(255)      not null
#  company_id        :bigint(8)
#  district_id       :bigint(8)
#  bg_member_id      :bigint(8)
#  contract_id       :bigint(8)
#  voltage_type_id   :bigint(8)
#  contract_capacity :string(255)
#  created_by        :integer
#  updated_by        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class FacilityGroup < ApplicationRecord
  has_many :supply_points
  has_many :facilities, through: :supply_points
  belongs_to :voltage_type
  # don't use this relation.
  # belongs_to :company
  # belongs_to :district
  belongs_to :bg_member, required: false
  belongs_to :contract

  scope :includes_for_index, lambda {
    includes([{bg_member: [:company, {balancing_group: :district}]}, :contract, :voltage_type])
  }

  class << self
    def json_option
      {
        include: [
          :contract,
          :voltage_type,
          {
            bg_member: {
              include: [
                :company,
                {
                  balancing_group: {
                    include: :district
                  }
                }
              ]
            }
          }
        ]
      }
    end
  end

  def sales_cost_adjustment
    return 0 if voltage_type.nil?

    case voltage_type.to_voltage_mode
    when :high
      0
    when :low
      -0.43
    end
  end

  def sales_special_discount_rate_at(date)
    return 0 if voltage_type.nil?

    case voltage_type.to_voltage_mode
    when :high
      facility.sales_special_discount_rate_at(date)
    when :low
      0
    end
  end

  def facility
    raise '高圧顧客以外は使用できません。' unless voltage_type.to_voltage_mode == :high

    facilities.first
  end
end
