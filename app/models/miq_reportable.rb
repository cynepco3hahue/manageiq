module MiqReportable
  # generate a ruport table from an array of db objects
  def self.records2table(records, only_columns)
    return Ruport::Data::Table.new if records.blank?

    data = records.map do|r|
      r.reportable_data_with_columns(:include     => nil,
                                     :only        => only_columns,
                                     :except      => nil,
                                     :tag_filters => nil,
                                     :methods     => nil)
    end

    Ruport::Data::Table.new(:data         => data.collect(&:last).flatten,
                            :column_names => data.collect(&:first).flatten.uniq,
                            :record_class => nil,
                            :filters      => nil)
  end

  # generate a ruport table from an array of hashes where the keys are the column names
  def self.hashes2table(hashes, options)
    return Ruport::Data::Table.new if hashes.blank?

    data = hashes.inject([]) do |arr, h|
      nh = {}
      options[:only].each { |col| nh[col] = h[col] }
      arr << nh
    end

    data = data[0..options[:limit] - 1] if options[:limit] # apply limit
    Ruport::Data::Table.new(:data         => data,
                            :column_names => options[:only],
                            :filters      => options[:filters])
  end
end
