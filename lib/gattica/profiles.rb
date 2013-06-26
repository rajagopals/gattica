require 'rubygems'
require 'ox'

module Gattica
  class Profiles
    include Convertible
    
    attr_reader :id, :updated, :title, :table_id, :account_id, :account_name,
                :profile_id, :web_property_id, :goals

  
    def initialize(xml)
      @id = xml.at_xpath('xmlns:id').text
      @updated = DateTime.parse(xml.at_xpath('xmlns:updated').text)
      @account_id = xml.at_xpath("dxp:property[@name='ga:accountId']").attributes['value'].value.to_i
      @account_name = xml.at_xpath("dxp:property[@name='ga:accountName']").attributes['value'].value

      @title = xml.at_xpath("dxp:property[@name='ga:profileName']").attributes['value'].value
      @table_id = xml.at_xpath("dxp:property[@name='dxp:tableId']").attributes['value'].value
      @profile_id = xml.at_xpath("dxp:property[@name='ga:profileId']").attributes['value'].value.to_i
      @web_property_id = xml.at_xpath("dxp:property[@name='ga:webPropertyId']").attributes['value'].value

      # @goals = xml.search('ga:goal').collect do |goal| {
      #   :active => goal.attributes['active'],
      #   :name => goal.attributes['name'],
      #   :number => goal.attributes['number'].to_i,
      #   :value => goal.attributes['value'].to_f,
      # }
      # end
    end
    
  end
end
