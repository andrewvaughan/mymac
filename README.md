# MacOS Configuration Control

[![Codename][codename-image]][codename-url]
[![Version][version-image]][codename-url]
[![License][license-image]][license-url]
[![Build][build-image]][build-url]

This tool configures macOS to the default environment used by Andrew Vaughan on his devices.

  **NOTE** Use this script at your own risk.  These scripts change critical components of your devices.  By installing
  or using this software, you agree to take ownership of all liability and changes to your system.  You own your
  device, and you should fully understand the changes this tool performs on your system prior to execution.

## Quick Start

A remote install script is available to install all required dependencies and execute the standard Ansible playbook.
This is intended to be run from a fresh installation of macOS, so no prior installations are required:

```bash
/bin/bash <(curl -fsSL https://raw.githubusercontent.com/andrewvaughan/mymac/master/install)
```

By default, no actions are performed.  In order to perform setup, you must supply a profile.  This is done by creating
a file and passing it's location in as the `MYMAC_PROFILE` environment variable.  For instance:

```bash
MYMAC_PROFILE=~/.mymac.yml /bin/bash <(curl -fsSL https://raw.githubusercontent.com/andrewvaughan/mymac/master/install)
```

For information on creating a profile file, see the [usage documentation](USAGE.md).

If using a profile that has been encrypted using [Ansible Vault][vault-url], the `-e` parameter must be attached to
the end of the command.  This will have the system ask for a vault password before starting.

There are a number of options, including debugging and verbosity, that can be run with the installer.  To see all
possible commands, place the `-h` argument at the end of the script:

```bash
/bin/bash <(curl -fsSL https://raw.githubusercontent.com/andrewvaughan/mymac/master/install) -h
```

> *Note:* This installer can take some time.  It is recommended that this script be monitored.  You may be asked to
> enter your user's `sudo` password multiple times during installation, due to security timeouts in the base system.


## Installation

Alternatively, the playbook can be run directly from [Ansible][ansible-url], assuming it has been installed:

```bash
MYMAC_PROFILE=~/.mymac.yml ansible-playbook -K playbook.yml
```

The `-K` option must be included, as some installations require `sudo` access.

The playbook can, additionally, be run in debug-mode by changing the strategy and increasing verbosity:

```bash
MYMAC_PROFILE=~/.mymac.yml ANSIBLE_STRATEGY=debug ansible-playbook -K -vv playbook.yml
```

## License

All use, interaction, and extension of this project is controlled by the [MIT License](LICENSE) under which this
project is made available.



[version-image]:  https://img.shields.io/badge/Version-0.2.0-blue.svg?style=flat
[version-url]:    https://github.com/andrewvaughan/mymac/releases/tag/0.2.0
[codename-image]: https://img.shields.io/badge/macOS-High_Sierra-blue.svg?style=flat
[codename-url]:   https://www.apple.com/macos/high-sierra/
[license-image]:  https://img.shields.io/badge/License-MIT-orange.svg?style=flat
[license-url]:    https://github.com/andrewvaughan/mymac/blob/master/LICENSE
[build-image]:    https://travis-ci.org/andrewvaughan/mymac.svg?branch=master
[build-url]:      https://travis-ci.org/andrewvaughan/mymac

[ansible-url]:    https://www.ansible.com/
