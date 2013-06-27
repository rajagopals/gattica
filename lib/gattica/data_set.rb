module Gattica
  
  # Encapsulates the data returned by the GA API
  class DataSet
    include Convertible
    
    attr_reader :total_results, :start_index, :items_per_page, :start_date,
                :end_date, :points #, :xml
      
    def initialize(xml)
      @total_results = xml.locate('openSearch:totalResults').first.text.to_i
      @start_index = xml.locate('openSearch:startIndex').first.text.to_i
      @items_per_page = xml.locate('openSearch:itemsPerPage').first.text.to_i
      @start_date = Date.parse(xml.locate('dxp:startDate').first.text)
      @end_date = Date.parse(xml.locate('dxp:endDate').first.text)
      @points = xml.locate('entry').collect { |entry| DataPoint.new(entry) }
    end

    # Returns a string formatted as a CSV containing just the data points.
    #
    # == Parameters:
    # +format=:long+::    Adds id, updated, title to output columns
    def to_csv(format=:short)
      output = ''
      columns = []
      case format
        when :long
          ["id", "updated", "title"].each { |c| columns << c }
      end
      unless @points.empty?   # if there was at least one result
        @points.first.dimensions.map {|d| d.keys.first}.each { |c| columns << c }
        @points.first.metrics.map {|m| m.keys.first}.each { |c| columns << c }
      end
      output = CSV.generate_line(columns) 
      @points.each do |point|
        output += point.to_csv(format)
      end
       output
    end

    def to_yaml
      { 'total_results' => @total_results,
        'start_index' => @start_index,
        'items_per_page' => @items_per_page,
        'start_date' => @start_date,
        'end_date' => @end_date,
        'points' => @points }.to_yaml
    end

    def to_hash
      @points.map(&:to_hash)
    end

  end
  
end
