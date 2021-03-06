# == Schema Information
#
# Table name: time_indices
#
#  id         :bigint(8)        not null, primary key
#  time       :time
#  created_by :integer
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TimeIndex < ApplicationRecord
  class << self
    #
    # 時間枠IDを時間に変換する
    #
    # @param time_index [Integer] 時間枠ID
    # @return [Tod::TimeOfDay]
    def to_time_of_day(time_index)
      time_index = (time_index.to_i - 1)
      Tod::TimeOfDay.new(time_index / 2, (time_index % 2) * 30)
    end

    #
    # Timeオブジェクトから時間枠IDオブジェクトを取得する
    #
    # @param time [Time] Timeオブジェクト
    # @return [TimeIndex]
    def from_time(time)
      time_index_id = from_time_to_time_index_id(time)
      self.find(time_index_id)
    end

    #
    # Timeオブジェクトから時間枠IDを取得する
    #
    # @param time [Time] Timeオブジェクト
    # @return [Integer] 時間枠IDオブジェクト
    def from_time_to_time_index_id(time)
      (time.hour * 2 + time.min / 30) + 1
    end

    #
    # 対象日におけるその月のコマ数(時間枠の数)を取得する
    #
    # @param target_date [Date] 対象日
    # @return [Integer] その月のコマ数
    def time_index_count_of_month(target_date)
      target_date.end_of_month.day * TimeIndex.count
    end
  end

  def name
    time.strftime("%H:%M")
  end

  private

  ransacker :time_text do
    Arel.sql("time_format(time, '%H:%i')")
  end
end
