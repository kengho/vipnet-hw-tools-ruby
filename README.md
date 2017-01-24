# VipnetGetter gem

## Summary

Allows to get configuration files like iplir.conf (and more) from ViPNet™ products such as HW1000; no `enable` and `admin escape` needed, just readonly ssh access. Currently implemented only "iplir.conf" file getting from ViPNet™ Coordinator HW v3+.

## Installing

Add this to your Gemfile

`gem "vipnet_getter"`

or run

`gem install vipnet_getter`

## Usage

* Allow to connect from your machine to coordinator via ssh (by "[local]" section rule or installing ViPNet™ Client):

*For ViPNet HW v3*
```
firewall.conf:

[local]
...
rule= name "vipnet_getter access" proto tcp from 192.0.2.1 to 192.0.2.2:22 pass
```

* Have fun:

```
irb(main):001:0> require "vipnet_getter"
=> true
irb(main):002:0> VipnetGetter.iplirconf(hostname: "192.0.2.2", username: "user", password: "mypassword")
Logging to user@192.0.2.2...
Entering password...
iplir show config
=> "/tmp/iplirconf20160616-13792-yhljnn"
irb(main):003:0> VipnetGetter.iplirconf(hostname: "192.0.2.2", password: "mypassword", output_file_path: "/home/user/iplir.conf")
Logging to vipnet@192.0.2.2...
Entering password...
iplir show config
=> "/home/user/iplir.conf"
```

## TODO

* Implement getting more configuration files like "firewall.conf".
* Support for for ViPNet™ Coordinator Windows.
* Make more clean and understandable code.

## Testing

* `git clone`
* Put desirible "iplir.conf" to "spec/fixtures/" folder (you may get it via "nc", USB Flash Drive or another way) and rename it into "#{hostname}iplir.conf" (e.g., "11.0.0.1.iplir.conf").
* Fill out "spec/vipnet_data.yml" file using example.
* Allow ssh access to coordinator.
* `rake`, `spec` or `spec --tag spec00`

*Note: make sure that coordinator's iplir.conf doesn't change while you ran tests (e.g., "firewallip" properties may change rapidly).*

## License

VipnetGetter is distributed under the MIT-LICENSE.

ViPNet™ is registered trademark of InfoTeCS Gmbh, Russia.
