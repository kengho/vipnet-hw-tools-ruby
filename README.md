# VipnetGetter gem

## Summary

Allows to get configuration files like iplir.conf (and more) from ViPNet™ products such as HW1000; no `enable` and `admin escape` needed, just readonly ssh access. Currently implemented only `iplir.conf` file getting from ViPNet™ Coordinator HW v3.

## Installing

Add this to your Gemfile

`gem "vipnet_getter"`

or run

`gem install vipnet_getter`

## Usage

* allow to connect from your machine to coordinator via ssh (by `[local]` section rule or installing ViPNet™ Client)

```
firewall.conf:

[local]
...
rule= name "vipnet_getter access" proto tcp from 192.0.2.1 to 192.0.2.2:22 pass
```

* have fun
```
irb(main):001:0> require "vipnet_getter"
=> true
irb(main):002:0> VipnetGetter::iplirconf({ hostname: "192.0.2.2", password: "mypassword" })
entering password
iplir show config
=> "/tmp/iplirconf20160616-13792-yhljnn"
irb(main):003:0> VipnetGetter::iplirconf({ hostname: "192.0.2.2", password: "mypassword", output_file_path: "/home/user/iplir.conf" })
entering password
iplir show config
=> "/home/user/iplir.conf"
irb(main):004:0>
```

## TODO

* implement getting more configuration files like `firewall.conf`
* support for ViPNet™ HW v4 and ViPNet™ Coordinator Windows
* make more clean and understandable code

## Testing

* `git clone`
* put `iplir.conf` to `spec/fixtures/` folder (you may get it via `nc`, USB Flash Drive or another way)
* fill out `spec/vipnet_data.yml` file using example
* allow ssh access to coordinator
* `rake`

## License

VipnetGetter is distributed under the MIT-LICENSE.

ViPNet™ is registered trademark of InfoTeCS Gmbh, Russia.
