# == Schema Information
#
# Table name: wheeler_charges
#
#  id                        :bigint(8)        not null, primary key
#  district_id               :bigint(8)
#  voltage_class             :integer          not null
#  start_date                :date             not null
#  basic_charge              :decimal(10, 4)
#  meter_rate_charge         :decimal(10, 4)
#  meter_rate_charge_daytime :decimal(10, 4)
#  meter_rate_charge_night   :decimal(10, 4)
#  peak_shift_discount       :decimal(10, 4)
#  a_charge                  :decimal(10, 4)
#  b_charge                  :decimal(10, 4)
#  created_by                :integer
#  updated_by                :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class WheelerCharge < ApplicationRecord
  include VoltageClass

  belongs_to :district

  scope :includes_for_index, lambda {
    includes([:district])
  }

  class << self
    def json_option
      {
        include: :district
      }
    end
  end

  #
  # 基本料率を返す
  #
  def basic_amount
    0
  end
end
