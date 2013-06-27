module Gattica
  class Account
    include Convertible
    
    attr_reader :id, :updated, :title, :table_id, :account_id, :account_name,
                :profile_id, :web_property_id, :goals
 
    def initialize(xml)
      @id = xml.locate("link").first.attributes[:href]
      @updated = DateTime.parse(xml.locate('updated').first.text)
      @account_id = find_account_id(xml)
      @title = xml.locate("dxp:property").select{|x| x.attributes[:name]== "ga:profileName" }.first.attributes[:value]
      @table_id = xml.locate("dxp:property").select{|x| x.attributes[:name]== "dxp:tableId" }.first.attributes[:value]
      @profile_id = find_profile_id(xml)
      @web_property_id =xml.locate("dxp:property").select{|x| x.attributes[:name]== "ga:webPropertyId" }.first.attributes[:value]
      @goals = []
    end

    def find_profile_id(xml)
      xml.locate("dxp:property").select{|x| x.attributes[:name]== "ga:profileId" }.first.attributes[:value]
    end

    def find_account_id(xml)
      xml.locate("dxp:property").select{|x| x.attributes[:name]== "ga:accountId" }.first.attributes[:value]
    end

    def find_account_name(xml)
      xml.locate("dxp:property").select{|x| x.attributes[:name]== "ga:accountName" }.first.attributes[:value]
    end

    def set_account_name(account_feed_entry)
      if @account_id == find_account_id(account_feed_entry)
        @account_name = find_account_name(account_feed_entry)
      end
    end

    def set_goals(goals_feed_entry)
      if @profile_id == find_profile_id(goals_feed_entry)
        goals_feed_entry.locate('ga:goal').each do |g|
          @goals.push({
            :active => g.attributes[:active],
            :name => g.attributes[:name],
            :number => g.attributes[:number].to_i,
            :value => g.attributes[:value].to_f
          })
        end
      end
    end
  end
end
