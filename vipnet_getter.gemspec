Gem::Specification.new do |s|
  s.name        = "vipnet_getter"
  s.version     = "0.3"
  s.date        = "2017-01-24"
  s.summary     = "Gem for getting data from ViPNet™ products"
  s.description = "Allows to get configuration files like iplir.conf (and more) from ViPNet™ products such as HW1000; no \"enable\" and \"admin escape\" needed."
  s.authors     = ["Alexander Morozov"]
  s.email       = "ntcomp12@gmail.com"
  s.files       = ["lib/vipnet_getter.rb"]
  s.homepage    = "https://github.com/kengho/vipnet_getter"
  s.license     = "MIT"

  s.add_runtime_dependency "ruby_expect", "~> 1"
end
