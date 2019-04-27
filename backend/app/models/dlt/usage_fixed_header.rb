# == Schema Information
#
# Table name: dlt_usage_fixed_headers
#
#  id                      :bigint(8)        not null, primary key
#  file_id                 :bigint(8)
#  year                    :integer          not null
#  month                   :integer          not null
#  supply_point_number     :string(22)       not null
#  consumer_code           :string(21)
#  consumer_name           :string(80)
#  supply_point_name       :string(70)
#  voltage_class_name      :string(4)
#  journal_code            :integer
#  can_provide             :boolean
#  usage_all               :decimal(10, 4)
#  usage                   :decimal(10, 4)
#  power_factor            :decimal(10, 4)
#  max_power               :decimal(10, 4)
#  next_meter_reading_date :date
#  created_by              :integer
#  updated_by              :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Dlt::UsageFixedHeader < ApplicationRecord
  has_many :usage_fixed_details, dependent: :delete_all
  belongs_to :supply_point, primary_key: :number, foreign_key: :supply_point_number, required: false

  accepts_nested_attributes_for :usage_fixed_details

  scope :includes_for_index, lambda {
    includes([{ file: [:content_attachment, :content_blob] }])
  }

  def as_json(options = {})
    if options.blank?
      options = {
        include: [{
          file: {
            include:
              [:content_attachment, :content_blob]
          }
        }]
      }
    end
    super options
  end

  class << self
    def import_data(setting, date, force)
      target_name = "#{setting.bg_member.company.name} #{setting.bg_member.balancing_group.district.name}"
      logger.info("[#{target_name}]の確定使用量データの取り込み処理を開始")

      [:high, :low].each do |voltage_mode|
        target_files = setting.files.filter_force(force).where(data_type: :fixed, voltage_mode: voltage_mode, record_date: date).order(revision: :asc, section_number: :asc)
        # ActiveRecordRelation Objectで検索条件に含まれているステータスの変更をブロック内で行っているため
        # 思わぬ動作をしてしまうので、最初に配列にしておく
        file_ids = target_files.pluck(:id)
        file_list = target_files.to_a
        begin
          # 処理以前に作成されたデータを削除する
          Dlt::File.where(id: file_ids).update_all(state: :state_in_progress)
          file_list.each do |file|
            logger.info("#{file.content.filename.to_s}:読込")
            process_each_file file, date
          end
          Dlt::File.where(id: file_ids).update_all(state: :state_complated)
        rescue Exception => ex
          logger.error(ex)
          Dlt::File.where(id: file_ids).update_all(state: :state_exception)
          raise $!
        end
      end
    end

    private
    def process_each_file(file, record_date)
      jptrm = file.xml_document.elements['SBD-MSG/JPMGRP/JPTRM']
      jptrm.elements['JPM00010'].to_a.each do |nodes_by_facility|
        key_attributes = {
          information_type_code: jptrm.elements['JP00002'].text,
          sender_code: jptrm.elements['JP06110'].text,
          receiver_code: jptrm.elements['JP06112'].text,
          year: jptrm.elements['JP06401'].text[0, 4],
          month: jptrm.elements['JP06401'].text[4, 2]
        }
        key_mapping = {
          supply_point_number: { tag: 'JP06400' },
          journal_code: { tag: 'JP06404' }
        }
        key_attributes = set_values_from_xml(key_attributes, nodes_by_facility, key_mapping)
        header = find_or_initialize_by(key_attributes)
        header_mapping = {
          consumer_code: { tag: 'JP06119' },
          consumer_name: { tag: 'JP06120' },
          supply_point_name: { tag: 'JP06402' },
          voltage_class_name: { tag: 'JP06403' },
          can_provide: { tag: 'JP06405', filter: ->(v) { v == '0' } },
          usage_all: { tag: 'JP06426' },
          usage: { tag: 'JP06427' },
          power_factor: { tag: 'JP06406' },
          max_power: { tag: 'JP06445' },
          next_meter_reading_date: { tag: 'JP06446', filter: ->(v) { Time.strptime(v, '%Y%m%d') } }
        }
        header = set_values_from_xml(header, nodes_by_facility, header_mapping)
        header.record_date = record_date
        header.save!
        details = nodes_by_facility.elements['JPM00013'].to_a.map do |nodes_by_day|
          date = Time.strptime(nodes_by_day.elements['JP06423'].text, '%Y%m%d')
          nodes_by_day.elements['JPM00014'].to_a.map do |nodes_by_time|
            detail_attributes = {
              usage_fixed_header_id: header.id,
              date: date
            }
            mapping = {
              time_index_id: { tag: 'JP06219' },
              usage_all: { tag: 'JP06424' },
              usage: { tag: 'JP06425' }
            }
            set_values_from_xml(detail_attributes, nodes_by_time, mapping)
          end
        end.flatten
        Dlt::UsageFixedDetail.where(usage_fixed_header_id: header.id).delete_all
        Dlt::UsageFixedDetail.import(details, validate: false)
      end
    end

    def set_values_from_xml(hash, node, mapping)
      mapping.each do |attribute_name, config|
        element = node.elements[config[:tag]]
        if element.nil?
          value = nil
        else
          value = node.elements[config[:tag]].text
          value = config[:filter].call(value) if config[:filter]
        end
        hash[attribute_name] = value
      end
      hash
    end
  end
end
