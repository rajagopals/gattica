require 'rubygems'
require 'ox'

module Gattica
  class Segment
    include Convertible
    
    attr_reader :id, :name, :definition
  
    def initialize(xml)
      @id = xml.attributes['id']
      @name = xml.attributes['name']
      @definition = xml.locate("dxp:definition").first.text
    end
    
  end
end
