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

class ResourceSelf < Resource
end
