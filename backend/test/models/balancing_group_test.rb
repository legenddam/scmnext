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

require 'test_helper'

class BalancingGroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
