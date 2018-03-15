# MacOS Configuration Control

[![Codename][codename-image]][codename-url]
[![Version][version-image]][codename-url]
[![License][license-image]][license-url]
[![Build][build-image]][build-url]

This tool configures macOS to the default environment used by Andrew Vaughan on his devices.

  **NOTE** Use this script at your own risk.  These scripts change critical components of your devices.  By installing
  or using this software, you agree to take ownership of all liability and changes to your system.  You own your
  device, and you should fully understand the changes this tool performs on your system prior to execution.

This tool is automatically tested on the following macOS and Xcode combinations:

| macOS Version | macOS Release | Xcode Version |
|:-------------:|:-------------:|:-------------:|
| 10.13         | High Sierra   | 9             |
| 10.12         | Sierra        | 8.3           |
| 10.12         | Sierra        | 8.2           |
| 10.12         | Sierra        | 8.1           |
| 10.11         | El Capitan    | 8             |
| 10.11         | El Capitan    | 7.3           |

## Quick Start

A remote install script is available to install all required dependencies and execute the standard Ansible playbook:

```bash
/bin/bash <(curl -fsSL https://raw.githubusercontent.com/andrewvaughan/mymac/master/install)
```

Optionally, a customized profile can be provided that customizes the settings that the Ansible script executes.  This
file should follow the format explained in the provided [config.yml](defaults/config.yml) file.  To run the custom
file, the `MYMAC_PROFILE` environment variable should be set to the profile's location before running.  One way of
doing this is by prepending it to the execution.

Additionally, a vault file can be included to provide sensitive information in the same manner.  The environment
variable to do so is `MYMAC_VAULT`.  An example of this file, unencrypted, looks akin to:

```yml
# AppStore Credentials
appstore:
  email : your@appstore.email
  pass  : yourappstorepassword
```

And the command to run these configurations would be:

```bash
MYMAC_PROFILE="~/mymac.yml" MYMAC_VAULT="~/mymac.vault.yml" /bin/bash <(curl -fsSL https://raw.githubusercontent.com/andrewvaughan/mymac/master/install)
```

Additional options are available in the script to modify things such as debugging and verbosity.  A complete list of
these can be found by adding the `-h` argument to the end of the script call:

```bash
/bin/bash <(curl -fsSL https://raw.githubusercontent.com/andrewvaughan/mymac/master/install) -h
```

> *Note:* This installer can take some time.  It is recommended that this script be monitored.  You may be asked to
> enter your user's `sudo` password multiple times during installation, due to security timeouts in the base system.


## Installation

Alternatively, the playbook can be run directly from [Ansible][ansible-url], assuming it has been installed:

```bash
MYMAC_PROFILE=custom.yml ansible-playbook -K playbook.yml
```

The playbook can, additionally, be run in debug-mode by changing the strategy and increasing verbosity:

```bash
MYMAC_PROFILE=custom.yml MYMAC_VAULT=vault.yml ANSIBLE_STRATEGY=debug ansible-playbook -K -vv playbook.yml
```

## Configuration

A number of configurations and installations are available using this script.  All are designed to be customized,
overridden, or disabled in a profile's configuration file.  More information can be found in the
[usage documentation](USAGE.md).

## License

All use, interaction, and extension of this project is controlled by the [MIT License](LICENSE) under which this
project is made available.



[version-image]:  https://img.shields.io/badge/macOS-Sierra-blue.svg?style=flat
[version-url]:    http://www.apple.com/macos/sierra/
[codename-image]: https://img.shields.io/badge/Version-10.12.6-blue.svg?style=flat
[codename-url]:   https://developer.apple.com/library/content/releasenotes/MacOSX/WhatsNewInOSX/Articles/OSXv10.html#//apple_ref/doc/uid/TP40017145-SW1
[license-image]:  https://img.shields.io/badge/License-MIT-orange.svg?style=flat
[license-url]:    https://github.com/andrewvaughan/mymac/blob/master/LICENSE
[build-image]:    https://travis-ci.org/andrewvaughan/mymac.svg?branch=master
[build-url]:      https://travis-ci.org/andrewvaughan/mymac

[ansible-url]:    https://www.ansible.com/
