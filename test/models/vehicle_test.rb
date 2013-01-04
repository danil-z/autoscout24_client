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
          proc {vehicle.send(attr.to_sym)}.must_raise NoMethodError
        end
      end
    end

  end
  describe "shortcuts" do
    let(:attrs) { %w(mileage accident_free body_color kilowatt) }

    it "provides reader for standart attributes" do
      attrs.each do |attr|
        vehicle = Autoscout24Client::Vehicle.new(attr => 135)
        vehicle.send(attr.to_sym).must_equal 135
      end
    end

  end
end
