require "minitest_helper"

describe Autoscout24Client::Dictionaries do
  let(:data){[ {"name"=>"body_color", "id"=>"M", "text"=>"Some Text"} ]}
  let(:sucess_mdt_respose){{ "status" => {"statusCode" => "0000"} ,"response" =>{ "stx3_idpool" =>{"nodes" =>{"node" => data } }}} }
  let(:sucess_ld_response) {{ "status" => {"statusCode" => "0000"} ,"response" =>{ "stx3_idpool" =>{"elements" =>{"element" => data } }}}}

  it "raise if credentials is wrong" do
    stub_request(:any, /.+/).to_return(:status => 401)
    proc { Autoscout24Client::Vehicle.make_model_tree }.must_raise RestClient::Request::Unauthorized
    proc { Autoscout24Client::Vehicle.look_up_data }.must_raise RestClient::Request::Unauthorized
  end


  describe "with valid auth" do
    before do
      @expired_token_message =  { "status" => { "statusCode" => "0040" }}
      @token_stub = stub_request(:get, /.+sts\.idm\.telekom\.com.+/).to_return(:status => 200, body: {"token"=>"secret"}.to_json)
    end

    it "body_color and etc..." do
      stub_request(:any, /.+/).to_return(:status => 200, :body=>sucess_mdt_respose.to_json)
      Autoscout24Client::Vehicle.body_colors.must_equal data
    end

    it "return nil on any error with remote server" do
      stub_request(:post, /.+/).to_return(:status => 404)
      Autoscout24Client::Vehicle.fetch_make_model_tree.must_be_nil
      Autoscout24Client::Vehicle.fetch_look_up_data.must_be_nil
     end

    it "make_model_tree refresh token if got message about expire" do
      #Autoscout24Client::Vehicle.reset_token
      main_stub = stub_request(:post, /.+makeModelTree/).to_return(:status => 401, :body => @expired_token_message.to_json)
        .to_return(:status => 200, body: sucess_mdt_respose.to_json)
      Autoscout24Client::Vehicle.fetch_make_model_tree.must_be_nil
      Autoscout24Client::Vehicle.fetch_make_model_tree.must_equal data
    end

    it "look_up_data refresh token if got message about expire" do
      main_stub = stub_request(:post, /.+lookUpData/).to_return(:status => 401, :body => @expired_token_message.to_json)
      .to_return(:status => 200, body: sucess_ld_response.to_json)
      Autoscout24Client::Vehicle.fetch_look_up_data.must_be_nil
      Autoscout24Client::Vehicle.fetch_look_up_data.must_equal data
    end
  end

  describe "look_up_data and makeModelTree" do

    it "return hash of lookupData" do
      stub_request(:any, /.+/).to_return(:status => 200, :body=>sucess_ld_response.to_json)
      Autoscout24Client::Vehicle.look_up_data.must_equal data
    end

    it "return hash of makeModelTree" do
      stub_request(:any, /.+/).to_return(:status => 200, :body=>sucess_mdt_respose.to_json)
      Autoscout24Client::Vehicle.make_model_tree.must_equal data
    end

  end
end