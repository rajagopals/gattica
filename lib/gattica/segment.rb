require 'rubygems'
require 'ox'

module Gattica
  class Segment
    include Convertible
    
    attr_reader :id, :name, :definition
  
    def initialize(xml)
      @id = xml.attributes['id']
      @name = xml.attributes['name']
      @definition = xml.at_xpath("dxp:definition").text
    end
    
  end
end
