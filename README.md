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

A remote install script is available to install all required dependencies and execute the standard Ansible playbook:

```bash
PROFILE=personal /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/andrewvaughan/mymac/master/install)"
```

The `PROFILE` value equates to any `config.PROFILE.yml` file in the root directory of the folder.  By defauly, a
`work` and `personal` set of configurations are provided.  Additional profiles can be added to suit your needs.

> *Note:* This installer can take some time.  It is recommended that this script be monitored.  You may be asked to
> enter your `sudo` password multiple times during installation, due to timeouts in the base system.


## Installation

Alternatively, the playbook can be run directly from [Ansible][ansible-url], assuming it has been installed:

```bash
PROFILE=personal ansible-playbook -v playbook.yml --ask-become-pass
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
[codename-image]: https://img.shields.io/badge/Version-10.12.3-blue.svg?style=flat
[codename-url]:   https://developer.apple.com/library/content/releasenotes/MacOSX/WhatsNewInOSX/Articles/OSXv10.html#//apple_ref/doc/uid/TP40017145-SW1
[license-image]:  https://img.shields.io/badge/License-MIT-orange.svg?style=flat
[license-url]:    https://github.com/andrewvaughan/mymac/blob/master/LICENSE
[build-image]:    https://travis-ci.org/andrewvaughan/mymac.svg?branch=master
[build-url]:      https://travis-ci.org/andrewvaughan/mymac

[ansible-url]:    https://www.ansible.com/
