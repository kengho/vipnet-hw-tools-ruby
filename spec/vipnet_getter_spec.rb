require_relative "../lib/vipnet_getter"
require_relative "spec_helper"

RSpec.describe VipnetGetter do
  describe "iplirconf" do
    require "yaml"
    data = YAML.load_file("spec/vipnet_data.yml")

    it "should get it" do
      expected_iplirconf = file_fixture("iplir.conf")
      tmp_iplirconf_path = "../tmp/iplir.conf"
      output_file_path = File.expand_path(tmp_iplirconf_path, __FILE__)
      gotten_iplirconf_file = VipnetGetter::iplirconf({
        hostname: data["hostname"],
        password: data["password"],
        output_file_path: output_file_path,
      })
      gotten_iplirconf = file_fixture(tmp_iplirconf_path)
      expect(gotten_iplirconf).to eq(expected_iplirconf)
      File.delete(output_file_path)
    end

    it "should be able to make tmpfile out of it" do
      expected_iplirconf = file_fixture("iplir.conf")
      gotten_iplirconf_file = VipnetGetter::iplirconf({
        hostname: data["hostname"],
        password: data["password"],
      })
      gotten_iplirconf = open(File.join(gotten_iplirconf_file)).read
      expect(gotten_iplirconf).to eq(expected_iplirconf)
    end
  end
end
