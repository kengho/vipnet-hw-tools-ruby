#!/usr/bin/ruby

require "./database.rb"
require "./vipnet_coordinator_settings_grabber.rb"
require "yaml"

database = YAML.load_file('database.yml')
token = database["token"]
path = database["path"]
coordinators = database["coordinators"]

coordinators.each do |coordinator|
	puts coordinator["vipnet_id"]
	iplirconf_path = VipnetCoordinatorSettingsGrabber::iplirconf(coordinator["ip"], coordinator["password"])
	request =	"curl -X POST "\
						"-F \"content=@#{iplirconf_path}\" "\
						"-F \"vipnet_id=#{coordinator['vipnet_id']}\" "\
						"-H \"Authorization: Token token=#{token}\" #{path}"
	puts request
	# http://stackoverflow.com/questions/690151/getting-output-of-system-calls-in-ruby
	response = `#{request}`
	puts response
end
