# MacOS Configuration Control

[![Codename][codename-image]][codename-url]
[![Version][version-image]][codename-url]

This tool configures macOS to the default environment used by Andrew Vaughan on his devices.  These configurations
have been tested on the following models:

* MacBook Pro (Retina, 15-inch, Late 2016)
* MacBook Pro (Retina, 15-inch, Late 2013)

The scripts included will automatically adjust their configurations depending on what model is being configured, when
applicable.

  **NOTE** Use this script at your own risk.  These scripts change critical components of your devices.  By installing
  or using this software, you agree to take ownership of all liability and changes to your system.  You own your
  device, and you should fully understand the changes this tool performs on your system prior to execution.


## Quick Start

A remote install script is available to install all required dependencies and execute the standard Ansible playbook:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/andrewvaughan/mymac/master/install)"
```


## Installation

Alternatively, the following can be manually installed:

* [Ansible][ansible-url] (Along with a [Homebrew Extension][ansible-homebrew-url])
* [Homebrew][homebrew-url]
* [pip][pip-url]

Once dependencies are installed, the provided playbook can be run via Ansible:

```bash
ansible-playbook playbook.yml --ask-become-pass
```




[version-image]:  https://img.shields.io/badge/macOS-Sierra-blue.svg?style=flat
[version-url]:    http://www.apple.com/macos/sierra/
[codename-image]: https://img.shields.io/badge/Version-10.12.3-blue.svg?style=flat
[codename-url]:   https://developer.apple.com/library/content/releasenotes/MacOSX/WhatsNewInOSX/Articles/OSXv10.html#//apple_ref/doc/uid/TP40017145-SW1

[ansible-url]:    https://www.ansible.com/
[homebrew-url]:   https://brew.sh/
[pip-url]:        https://pypi.python.org/pypi/pip
