# == Schema Information
#
# Table name: supply_points
#
#  id                 :bigint(8)        not null, primary key
#  number             :string(30)       not null
#  supply_start_date  :date
#  supply_end_date    :date
#  supply_method_type :integer          not null
#  base_power         :integer
#  facility_group_id  :bigint(8)
#  facility_id        :bigint(8)
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class SupplyPoint < ApplicationRecord
  # before_validation :set_facility_group_id, if: -> { !facility_id.nil? && facility_group_id.nil? }

  has_many :usage_fixed_headers, class_name: Dlt::UsageFixedHeader.to_s, primary_key: :number, foreign_key: :supply_point_number
  belongs_to :facility_group
  belongs_to :facility, optional: true # 低圧施設の情報を外部提供受けるケースを想定して必須にはしない

  enum supply_method_type: {
    supply_method_type_all: 1,
    supply_method_type_partial: 2
  }

  validates :number,
            presence: true
  validates :facility_group,
            presence: true
  validates :supply_method_type,
            presence: true
  validates :base_power,
            absence: { unless: -> { supply_method_type_partial? } },
            presence: { if: -> { supply_method_type_partial? } }

  class << self
    #
    # 指定された会社・エリアの供給地点番号情報を供給地点番号をkeyにしたhashで返す
    #
    # @param [Integer] company_id 会社ID
    # @param [Integer] district_id エリアID
    # @return [Hash] 供給地点番号をkey,supply_pointオブジェクトを値とするHash
    def get_map_filter_by_compay_id_and_district_id(company_id, district_id)
      eager_load(:facility_group)
        .where('facility_groups.company_id' => company_id, 'facility_groups.district_id' => district_id)
        .map do |supply_point|
        [supply_point.number, supply_point]
      end.to_h
    end
  end

  # パラメータで指定された日においてインスタンスの供給地点番号が有効かをチェックする
  # (開始日未指定の場合は常にfalse)
  #
  # @param date [Date] チェックする日付
  # @return [Boolean] 有効な場合はtrueを返す
  def is_active_at?(date)
    return false if supply_start_date.nil?
    (supply_start_date <= date) && (supply_end_date.nil? || (supply_end_date >= date))
  end

  private

  def set_facility_group_id
    return if facility.nil? || facility.voltage_type_id >= 99 || facility.consumer.nil?

    facility_group = FacilityGroup.find_or_initialize_by(
      company_id: facility.consumer.company_id,
      district_id: facility.district_id,
      contract_id: (contract.nil? ? nil : contract.id),
      voltage_type_id: facility.voltage_type_id,
      contract_capacity: facility.contract_capacity_for_facility_group
    )
    if facility_group.new_record?
      facility_group.name = facility.name_for_facility_group
      facility_group.save
    end
    self.facility_group_id = facility_group.id
  end
end
