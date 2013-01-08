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

  describe "#method_missing" do
    it "searches in source method name key" do
      vehicle = Autoscout24Client::Vehicle.new("mykey" => 135)
      vehicle.send("mykey".to_sym).must_equal 135
    end
    it "searches in source keys (method name splited by __)" do
      vehicle = Autoscout24Client::Vehicle.new("mykey" => 135, owners: [{adress: {"zip" => "344000"}}])
      vehicle.send("mykey__zip".to_sym).must_equal [135, "344000"]
    end
  end


  describe "#name" do
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

  describe "#vat_rate" do
    it "returns vat rate in integer for country" do
      vehicle = Autoscout24Client::Vehicle.new( price: { "vat_type_id"=> "True"}, "country" => "D")
      vehicle.vat_rate.must_equal 19
    end

    it "value > 0  for known countries" do
      countries = %w(A B BG CH D E F HR I L LT LV NL PL RO RUS S SK SLO TR UA)
      countries.each do |country|
        vehicle = Autoscout24Client::Vehicle.new( price: { "vat_type_id"=> "True"}, "country" => country)
        vehicle.vat_rate.wont_be_same_as 0
      end
    end
    it "0 for uknown country" do
      vehicle = Autoscout24Client::Vehicle.new( price: { "vat_type_id"=> "True"}, "country" => "Unknown")
      vehicle.vat_rate.must_equal 0
    end
    it "0 if vehicle doesn't include vat" do
      vehicle = Autoscout24Client::Vehicle.new( price: { "vat_type_id"=> "False"}, "country" => "D")
      vehicle.vat_rate.must_equal 0
    end
  end

  describe "#netto" do
    it "calculate netto if vat included" do
      vehicle = Autoscout24Client::Vehicle.new( price: {"value" => 11900, "vat_type_id"=> "True"}, "country" => "D")
      vehicle.netto.must_equal 10000
    end
    it "calculate netto if vat NOT included" do
      vehicle = Autoscout24Client::Vehicle.new( price: {"value" => 11900, "vat_type_id"=> "False"}, "country" => "D")
      vehicle.netto.must_equal 11900
    end

  end


end
