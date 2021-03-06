# == Schema Information
#
# Table name: balancing_groups
#
#  id                :bigint(8)        not null, primary key
#  code              :string(5)        not null
#  name              :string(40)       not null
#  district_id       :bigint(8)
#  leader_company_id :bigint(8)
#  created_by        :integer
#  updated_by        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class BalancingGroup < ApplicationRecord
  has_many :bg_members, inverse_of: :balancing_group, dependent: :destroy
  has_many :companies, through: :bg_members
  has_many :occto_plans, class_name: Occto::Plan.to_s
  belongs_to :district
  belongs_to :leader_company, class_name: Company.to_s, required: false

  scope :includes_for_index, lambda {
    includes([:district, :leader_company])
  }

  class << self
    def json_option
      {
        include: [:district, :leader_company]
      }
    end
  end
end
