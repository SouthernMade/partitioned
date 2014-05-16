module Partitioned
  #
  # Partition tables by a time field grouping them by day, with
  # a day defined as 24 hours.
  #
  class ByDailyTimeField < ByTimeField
    self.abstract_class = true

    #
    # Normalize a partition key value by day.
    #
    # @param [Time] time_value the time value to normalize
    # @return [Time] the value normalized
    def self.partition_normalize_key_value(time_value)
      return time_value.at_beginning_of_day
    end

    #
    # The size of the partition table, 1 day (24 hours)
    # 
    # @return [Integer] the size of this partition
    def self.partition_table_size
      return 1.day
    end

    # the field to partition on, `created_at`
    # @return [Symbol] the partition field: `created_at`
    def self.partition_time_field
      return :created_at
    end

    partitioned do |partition|
      partition.base_name lambda { |model, time_field|
        return model.partition_normalize_key_value(time_field).strftime('%Y%m%d')
      }
    end
  end
end
