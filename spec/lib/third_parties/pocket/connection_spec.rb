require 'rails_helper'

describe ThirdParties::Pocket::Connection do

  let(:user) { FactoryGirl.create(:user) }
  let(:connection) { ThirdParties::Pocket::Connection.new(user: user) }

  describe "connected?" do
    context "has connected pocket account" do
      before(:each) do
        FactoryGirl.create(:authentication_provider, uid: "foobar", provider: "pocket", user: user)
      end

      it "calls on_connected" do
        callback = mock()
        callback.expects(:on_connected).once
        connection.instance_variable_set(:@callback, callback)
        connection.connected?
      end
    end

    context "has not connected pocket account", vcr: true do
      it "calls on_not_connected" do
        callback = mock()
        callback.expects(:on_not_connected).with().once
        connection.instance_variable_set(:@callback, callback)
        connection.connected?
      end
    end
  end
end