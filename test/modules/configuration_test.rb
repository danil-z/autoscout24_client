require "minitest_helper"

describe Autoscout24Client do
  let(:custom_config){
    {
        username: "your_username",
        password: "your_password",
        culture_id: "ru-RU",
        default_search_params:
            {
                countries: %w(B CH D F I NL),
                show_with_images_only: "True",
                show_private_vehicles: "False"
            }
    }
  }
  it "configures via hash" do
    Autoscout24Client.configure(custom_config)
    Autoscout24Client.config.must_equal custom_config
  end

  it "configures via yaml" do
    Autoscout24Client.configure(custom_config)
    Autoscout24Client.configure_with(File.expand_path("../../assets/config_sample.yml", __FILE__))
    Autoscout24Client.config.wont_equal custom_config

  end

  it "uses defaults settings if specified yaml not found or invalid format" do
    Autoscout24Client.configure(custom_config)
    Autoscout24Client.configure_with("non_existing.yml")
    Autoscout24Client.configure_with(File.expand_path("../../assets/invalid_config_sample.yml", __FILE__))
    Autoscout24Client.config.must_equal custom_config
  end


end