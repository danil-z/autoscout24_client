require "minitest_helper"

describe Autoscout24Client::Finder do

  it "fetches vehicles from remote site" do
    raw_response_file = File.read(File.expand_path(File.dirname(__FILE__) + "/../assets/success_find_response.json"))
    stub_request(:post, /.+/).to_return(body: raw_response_file)
    result = Autoscout24Client::Vehicle.find
    result.must_be_kind_of Hash
    result[:vehicles].must_be_kind_of Array
    result[:vehicles].count.must_equal 20
  end

end