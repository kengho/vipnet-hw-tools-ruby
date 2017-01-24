require_relative "../lib/vipnet_getter"
require_relative "spec_helper"
require "yaml"

RSpec.describe VipnetGetter do
  describe "iplirconf" do
    data = YAML.load_file("spec/vipnet_data.yml")

    it "should get it", spec00: true do
      data["coordinators"].each do |coordinator|
        iplirconf_filename = "#{coordinator["hostname"]}.iplir.conf"
        tmp_iplirconf_path = "../tmp/#{iplirconf_filename}"
        output_file_path = File.expand_path(tmp_iplirconf_path, __FILE__)

        iplirconf_params = {
          hostname: coordinator["hostname"],
          password: coordinator["password"],
          username: coordinator["username"] || "vipnet",
          output_file_path: output_file_path,
        }


        expected_iplirconf = file_fixture(iplirconf_filename)
        gotten_iplirconf_file = VipnetGetter.iplirconf(iplirconf_params)
        gotten_iplirconf = file_fixture(tmp_iplirconf_path)

        expect(gotten_iplirconf).to eq(expected_iplirconf)
        File.delete(output_file_path)
      end
    end

    it "should be able to make tmpfile out of it", spec01: true do
      data["coordinators"].each do |coordinator|
        iplirconf_filename = "#{coordinator["hostname"]}.iplir.conf"
        iplirconf_params = {
          hostname: coordinator["hostname"],
          password: coordinator["password"],
          username: coordinator["username"] || "vipnet",
        }

        expected_iplirconf = file_fixture(iplirconf_filename)
        gotten_iplirconf_file = VipnetGetter.iplirconf(iplirconf_params)
        gotten_iplirconf = open(File.join(gotten_iplirconf_file)).read

        expect(gotten_iplirconf).to eq(expected_iplirconf)
      end
    end
  end
end
