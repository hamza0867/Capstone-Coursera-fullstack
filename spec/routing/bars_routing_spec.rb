require "rails_helper"

RSpec.describe BarsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/bars").to route_to("bars#index")
    end

    it "routes to #show" do
      expect(:get => "/bars/1").to route_to("bars#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/bars").to route_to("bars#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/bars/1").to route_to("bars#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/bars/1").to route_to("bars#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/bars/1").to route_to("bars#destroy", :id => "1")
    end
  end
end
