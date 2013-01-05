require "minitest_helper"
#require File.expand_path("../../minitest_helper", __FILE__)

describe Autoscout24Client::Vehicle do
  describe "fetching names for id attributes" do
    let(:attrs) { %w(gear_type fuel brand) }
    let(:attrs_keys) { %w(gear_type_id fuel_type_id brand_id) }

    it "returns name of attribute instead of id" do
      attrs.each_with_index do |attr,i|
        vehicle = Autoscout24Client::Vehicle.new(attrs_keys[i] => "X")
        Autoscout24Client::Vehicle.stub attr.pluralize.to_sym, [{"id" => "M", "text" => "Wrong"},{"id" => "X", "text" => "Name of attr"}] do
          vehicle.send(attr.to_sym).must_equal "Name of attr"
        end
      end
    end

    it "returns nil if attribute absent in source" do
      attrs.each do |attr|
        vehicle = Autoscout24Client::Vehicle.new({})
        Autoscout24Client::Vehicle.stub attr.pluralize.to_sym, [{"id" => "M", "text" => "Wrong"},{"id" => "X", "text" => "Name of attr"}] do
          vehicle.send(attr.to_sym).must_be_nil
        end
      end
    end

    it "raises exception if value of attribute is unknown" do
      attrs.each_with_index do |attr,i|
        vehicle = Autoscout24Client::Vehicle.new(attrs_keys[i] => "Unknown")
        Autoscout24Client::Vehicle.stub attr.pluralize.to_sym, [{"id" => "M", "text" => "Wrong"},{"id" => "X", "text" => "Name of attr"}] do
          vehicle.send(attr.to_sym).must_be_nil
        end
      end
    end

  end

  describe ".method_missing" do
    it "searches in source method name key" do
      vehicle = Autoscout24Client::Vehicle.new("mykey" => 135)
      vehicle.send("mykey".to_sym).must_equal 135
    end
    it "searches in source keys (method name splited by _)" do
      vehicle = Autoscout24Client::Vehicle.new("mykey" => 135, owners: [{adress: {"zip" => "344000"}}])
      vehicle.send("mykey_zip".to_sym).must_equal [135, "344000"]
    end
  end

  describe ".name" do
    let(:mod_tree){
      [
          {"name"=>"brand", "id"=>"15", "text"=>"Bugatti", "nodes"=>{"node"=>[{"name"=>"model", "id"=>"15677", "text"=>"EB 110"}, {"name"=>"model", "id"=>"18843", "text"=>"Veyron"}]}},
          {"name"=>"brand", "id"=>"16337", "text"=>"Galloper", "nodes"=>{"node"=>[{"name"=>"model", "id"=>"16562", "text"=>"GALLOPER"}]}}
      ]
    }
    it "return model name by model_id (a4, lancer, x5 and etc...)" do
      Autoscout24Client::Vehicle.stub :make_model_tree, mod_tree do
        vehicle = Autoscout24Client::Vehicle.new("brand_id"=>15, "model_id"=> 18843)
        vehicle.name.must_equal "Veyron"
      end
    end
  end


end
