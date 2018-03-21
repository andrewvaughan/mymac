# Usage

This file contains details on how to prepare a profile for use with this playbook.  Provided examples include:

* `profiles/noop.yml` - prevents all operations from performing (default)
* `profiles/personal.yml` - Andrew's settings he uses for his personal computers

These profiles can be referred to, in combination with this document, to create a custom MyMac profile.  For details
on how to run a profile, please refer to the [readme](README.md).

**Note** when using encryption either in files or for strings, it is important that the same Vault Password be used
for each encryption.  At this time, multiple vault IDs are not supported.

> ***NOTE:*** This playbook has the ability to cause significant harm to your system.  This software is provided "as
> is", without warranty of any kind, express or implied.  The authors and maintainers provide no warranty of any kind,
> and are not liable for any claim, damages, or other liability, as described in the project [LICENSE](LICENSE):
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
> WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
> COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
> OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Quick-Reference

The following are modules available in MyMac by default:

| Module                        | Description                                                              |
|:-----------------------------:|--------------------------------------------------------------------------|
| [macos](#macos)               | Checks the system for compatibility and, optionally, upgrades the system |
| [sudoers](#sudoers)           | Adds user and alias configurations for sudo                              |
| [identity](#identity)         | Sets the computer and user's identity, including encryption keys         |
| [dev_tools](#dev_tools)       | Installs developer tools, such as XCode and Command Line Tools           |
| [app_store](#app_store)       | Installs applications from the Apple AppStore                            |
| [time_machine](#time_machine) | Configures TimeMachine backups for the computer                          |

## Using Profiles

Profiles are [YAML][yaml-url] files that configure various modules and options in MyMac.  This file describes each
module in detail, including all available options.  This file should be set as the `MYMAC_PROFILE` environment
variable before or during execution.  Optionally, the included file can be encrypted using
[Ansible Vault][ansible-vault-url] to prevent sensitive information from being exposed or committed.

## Creating a Custom Profile

To create a custom profile, create a YML file in a format similar to one of the examples in the
[profiles][profiles-url].  Any sections that are not included or explicitly set to `false`, as shown in the
[no-op profile][no-op-url], will be skipped during setup.

### Running a Local Profile

Common practice is to create a file called `.mymac.yml` in the main user's home directory, which would be included as
follows:

```bash
MYMAC_PROFILE=~/.mymac.yml /bin/bash <(curl -fsSL https://raw.githubusercontent.com/andrewvaughan/mymac/master/install)
```

Alternatively, a GitHub project can be created that includes this profile and a bash script to call MyMac from above.

### Running a Remote Profile

Alternatively, a URL can be provided as the profile, such as a raw [GitHub gist][gist-url] file,:

```bash
export MYMAC_PROFILE=http://bit.do/mymacprofile
/bin/bash <(curl -fsSL https://raw.githubusercontent.com/andrewvaughan/mymac/master/install)
```

As given by the example above, all redirects will be honored.  Profiles are not cached; the profile will be
downloaded at the beginning of each launch.  These profiles can also be encrypted using Ansible Vault.

## Profile Options

Each of the following are modules available to configure a Mac using the MyMac system.  If a section is omitted, it
will be skipped entirely.  Unless otherwise noted, any sections or options can be explicitly skipped by setting the
value to `false`.

### macos

The MacOS module checks for version compatibility and updates the system.

```yml
macos:
  version_check : 10.13
  system_update : true
  filevault     : true

  defaults:
    update_frequency : 1

  bash_profile:
    exports:
      EDITOR : /usr/bin/vi

    aliases:
      ll : 'ls -GFalh'

  finder:
    default_view             : "column" # Which view to use by default (options "cover", "list", "column", "icon")
    extension_change_warning : false    # Suppress the file-extension change warning
    hide_desktop_files       : false    # Show files on the desktop
    open_on_mount            : true     # Open Finder when a drive is connected
    posix_title              : true     # Show POSIX path in Finder window title
    quit_menu_item           : true     # Allow Finder to close like a regular application
    show_extensions          : true     # Show file extensions in Finder
    show_hidden_files        : true     # Show hidden files in Finder
    show_user_library        : true     # Show the user's ~/Library/ folder in Finder

  keyboard:
    auto_correct             : false    # Turn off Apple's global auto-correct
```

#### macos.version_check

If `version_check` is set, the script will not run unless the system is, at least, the version specified.  For
reference, these are the versions of macOS and OSX at the time of this writing:

| Version | Codename      | Released   |
|:-------:|:-------------:|------------|
| `10.13` | High Sierra   |  9/25/2017 |
| `10.12` | Sierra        |  9/20/2016 |
| `10.11` | El Capitan    |  9/30/2015 |
| `10.10` | Yosemite      | 10/16/2014 |
| `10.9`  | Mavericks     | 10/22/2013 |
| `10.8`  | Mountain Lion |  7/25/2012 |
| `10.7`  | Lion          |  7/20/2011 |
| `10.6`  | Snow Leopard  |  8/28/2009 |
| `10.5`  | Leopard       | 10/26/2007 |
| `10.4`  | Tiger         |  4/29/2005 |
| `10.3`  | Panther       | 10/24/2003 |
| `10.2`  | Jaguar        |  8/24/2002 |
| `10.1`  | Puma          |  9/24/2001 |
| `10.0`  | Cheetah       |  3/24/2001 |

**Note** that the `version_check` must match one of the major and minor revision pairs from the table above.

#### macos.system_update

Setting `system_update` to `true` will install any system updates that are outstanding for the system, bringing it to
the latest version available.  This can take some time, with minimal output on the display, as many updates can be
large in size.

**Note** that this does *not* update App Store items or any other software, just the base operating system.  To update
other applications, see the [appstore](#appstore) option.

**Note** that most updates require a system restart (sometimes several) to be effective.  Because of this, the
version check may fail, even if the `system_update` command is set to true.  If your version check fails with
`system_update` enabled, you should restart your computer and run the profile again.

#### macos.filevault

The `filevault` parameter can be either set to `true`, `false`, or omitted.  If omitted, the state of FileVault will
not be changed on the system.  However, if the parameter is set to either `true` or `false`, the system will either
enable or disable FileVault on the system, respectively.

**Note** that encrypting the disk with FileVault can take some time.  Instead of waiting for the disk to encrypt, a
flag will be set to enable FileVault the next time you restart your computer.  Because of this, you will likely be
asked to enter your computer's password upon your next restart.

#### macos.bash_profile

These are settings that will be inserted into the user's `~/.bash_profile` and loaded for every terminal.  This
section provides two lists:

`exports`

The exports list is a set of key-value pairs that will be exported as environment variables.

`aliases`

The aliases list is a set of key-value pairs that will become commands in the terminal, acting as aliases in the
system command prompt.

#### macos.finder

These are settings that affect the functionality of the included Finder application in MacOSX:

| Feature                    | Options                             | Default | Description                                                                 |
|:--------------------------:|:-----------------------------------:|:-------:|-----------------------------------------------------------------------------|
| `default_view`             | `cover`, `list`, `column` or `icon` | `icon`  | Sets the default view for Finder                                            |
| `extension_change_warning` | `true` or `false`                   | `true`  | Whether to display a warning when an extension is being changed             |
| `hide_desktop_files`       | `true` or `false`                   | `false` | Whether to hide the desktop files                                           |
| `open_on_mount`            | `true` or `false`                   | `true`  | Whether to open a new Finder window when a drive is connected to the system |
| `posix_title`              | `true` or `false`                   | `false` | Whether to show the POSIX path in the Finder window title                   |
| `quit_menu_item`           | `true` or `false`                   | `false` | Whether to allow Finder to close like a normal application                  |
| `show_extensions`          | `true` or `false`                   | `false` | Whether show file extensions in Finder                                      |
| `show_hidden_files`        | `true` or `false`                   | `false` | Whether to show hidden files in Finder                                      |
| `show_user_library`        | `true` or `false`                   | `false` | Whether to show the `~/Library` folder in Finder                            |

#### macos.keyboard

These are settings that affect the functionality of the MacOSX keyboard and interaction in MacOSX:

| Feature                    | Options           | Default | Description                                           |
|:--------------------------:|:-----------------:|:-------:|-------------------------------------------------------|
| `auto_correct`             | `true` or `false` | `true`  | Whether to turn Apple's global auto-correct on or off |

### sudoers

The Sudoers module adds aliases and user configurations for the system's [sudo functionality][apple-sudo].  The
existing `sudoers` file is not modified.  These configurations are included after the main `sudoers` file, meaning
it will append or override those settings.

```yml
sudoers:
  user_aliases:
    - "FULLTIMERS = millert, mikef, dowdy"
  runas_aliases:
    - "OP = root, operator"
  host_aliases:
    - "CSNETS = 128.138.243.0, 128.138.204.0/24, 128.138.242.0"
  cmnd_aliases:
    - "PAGERS = /usr/bin/more, /usr/bin/pg, /usr/bin/less"
  users:
    - "bob     ALL = (ALL) ALL"
    - "%group  ALL = (ALL) ALL"
```

Any sections that are omitted or set explicitly to `false` will be skipped in the configuration.

**Note** setting this section to `false` will *remove* any previously-configured `sudoers` configurations by MyMac.
Only by omitting the section entirely will no action be taken.

#### sudoers.user_aliases

`user_aliases` are used to specify groups of users. You can specify usernames, system groups (prefixed by a `%`) and
netgroups (prefixed by a `+`).

More details can be found [here](https://help.ubuntu.com/community/Sudoers#User_Aliases).

#### sudoers.runas_aliases

`runas_aliases` are almost the same as `user_aliases`, but you are allowed to specify users by uid's. This is helpful,
as usernames and groups are matched as strings, so two users with the same uid but different usernames will not be
matched by entering a single username, but can be matched with a uid.

More details can be found [here](https://help.ubuntu.com/community/Sudoers#Runas_Aliases).

#### sudoers.host_aliases

A `host_alias` is a list of hostname, ip addresses, networks and netgroups (prefixed with a `+`). If you do not
specify a netmask with a network, the netmask of the hosts ethernet interface(s) will be used when matching.

More details can be found [here](https://help.ubuntu.com/community/Sudoers#Host_Aliases).

#### sudoers.cmnd_aliases

`cmnd_aliases` are lists of commands and directories. You can use this to specify a group of commands. If you
specify a directory it will include any file within that directory but not in any subdirectories.

More details can be found [here](https://help.ubuntu.com/community/Sudoers#Command_Aliases).

#### sudoers.users

`users` are where the sudoers file sets who can run what as who. It is the key part of the file and all the aliases
have just been set up for this very point. If this was a film this part is where all the key threads of the story come
together in the glorious unveiling before the final climatic ending.

Users are defined in this format:

```
<user list> <host list> = <operator list> <tag list> <command list>
```

For example, this is often the MacOS default:

```
root    ALL = (ALL) ALL
%admin  ALL = (ALL) ALL
```

More details can be found [here](https://help.ubuntu.com/community/Sudoers#User_Specifications).

### identity

The Identity module sets the computer and user's identities.  It also will setup and distribute SSH and GPG keys to
services that need it.  All changes happen to the user who is running the script.

```yml
identity:
  names:
    computer : Andrew's Macbook
    host     : andrew-macbook

  ssh_key:
    bits     : 4096
    comment  : Andrew Vaughan's Personal MacBook <hello@andrewvaughan.io>
    password : !vault |
          $ANSIBLE_VAULT;1.1;AES256
          33313034646564636330326338356565306336373065623439616539373938613832356665613338
          3862383938383732366262353335643461646130363832310a613231376637623065326235383133
          37353766343438626639333262663261623565383430306338303865343833633266643263303032
          3330656539306439360a633534383538393466363930386563363366656233336530316330656264
          3530

  gpg_key:
    id            : E2FF2F42817D427CC18D1D793DCB06CACAFD44DC
    files:
      public_key  : ./profiles/keys/personal/gpg.pub.asc
      private_key : ./profiles/keys/personal/gpg.asc
```

#### identity.names.computer

This is the name of the computer for use on things like network and services.  If omitted or explicitly set to
`false`, the computer name will not be changed.

#### identity.names.host

This is the hostname of the computer for use on the network.  If omitted or explicitly set to `false`, the
hostname will not be changed.

**Note** that there are two types of hostnames on MacOSX computers: *primary* and *bonjour* hostnames.  This script
will set both, with the former having a `.local` suffix.  **Do not** include the `.local` suffix when setting the
hostname, or your result will end up with something like `hostname.local.local`.

#### identity.ssh_key.bits

The number of bits for the RSA algorithm when generating the SSH key.  By default, the value is `4096`.  RSA keys have
a minimum of `1024` bits, and need to be a factor of 2, but this is not checked by the system.  The underlying
software may or may not throw an error if these are malformed.

#### identity.ssh_key.comment

The comment to include at the end of the SSH key.  This is often useful to distinguish the SSH key when multiple are
placed on external services or servers.  If omitted, no comment will be included.

#### identity.ssh_key.password

The password for the SSH key.  If omitted, the SSH key will be generated without a password; however, this is usually
not recommended for security reasons.

**Note** it is recommended to use [Ansible Vault][ansible-vault-url] to encrypt the `password` string so it does not
sit in plain text.

#### identity.gpg_key.id

The long-format ID of the GPG key being copied.  This can be found on a computer with the existing key by entering
the following command:

```bash
gpg --list-secret-keys --keyid-format LONG
```

#### identity.gpg_key.files.public_key

The location of the public key data for the GPG key being installed.  This file can, optionally, be encrypted by
[Ansible Vault][ansible-vault-url].  To export a GPG public key on an existing machine, use the following command:

```bash
gpg --export -a [YOUR_KEY_ID] > gpg.pub.asc
```

#### identity.gpg_key.files.private_key

The location of the private key data for the GPG key being installed.  To export a GPG private key on an existing
machine, and encrypt it using Ansible Vault, use the following commands:

```bash
gpg --export-secret-keys -a [YOUR_KEY_ID] > gpg.asc
ansible-vault encrypt gpg.asc
```

**Note** it is recommended to use [Ansible Vault][ansible-vault-url] to encrypt the private key file so this
sensitive data does not get stored in plain-text.  The configuration agent will automatically decrypt this file when
it is found.

### dev_tools

Installs a number of development tools on the system, including Homebrew, MAS, XCode, and XCode Command Line Tools.

```yml
dev_tools: true
```

**Note** there are no options for the `dev_tools` module.

**Note** that this module relies on Homebrew and the AppStore to install development tools.  While credentials for the
App Store do not need to be configured, you may experience a failure if you are not currently logged into the AppStore
without them.

### app_store

Installs and updates applications that are managed via the Apple AppStore.

```yml
app_store:
  update_frequency : 1
  email            : andrew@undoubtedly.me
  password         : !vault |
        $ANSIBLE_VAULT;1.1;AES256
        37636666386265393735656530376232353039616132393363616339383037353965666664616635
        3765613831393663333766366533343936323434393463350a363661623265616534343963383634
        32643337333561623664623165653562643631313365663930623533653633303133653530366264
        3561343830303661310a333738616437623035666239336339343131616661396464656633666666
        3363
```

#### app_store.email

This is a number that dictates, in days, the interval between checking for updates.  MacOSX defaults this to 7.

#### app_store.email

This is the email used to login to the Apple AppStore.  This is an optional field - if the user is already logged in
to the AppStore, the credentials will not be used.

#### app_store.password

This is the password used to login to the Apple AppStore.  This is an optional field - if the user is already logged
in to the AppStore, the credentials will not be used.

**Note** it is recommended to use [Ansible Vault][ansible-vault-url] to encrypt the `password` string so it does not
sit in plain text.

### time_machine

Manages and configures Time Machine backups for the computer:

```yml
time_machine:
  connection_prompts : false
  backup_interval    : 3600
  volumes:
    - /Volumes/FandomHD
  exclude:
    - /Users/Shared/adi
    - ~/Downloads
    - ~/Dropbox
```

**Note** if the `time_machine` setting is set to `false`, the Time Machine will be disabled.  To prevent updating of
any Time Machine settings, simply omit this configuration entirely.

**Note** that the ability to turn off local snapshots was removed in High Sierra (10.13), and thus was removed from
MyMac.

#### time_machine.connection_prompts

This is a boolean that tells the system whether it should prompt the user about making a drive a Time Machine disk
when it is connected for the first time.  The default for this is set to `true`.

#### time_machine.backup_interval

The backup interval is the amount of time, in seconds, to wait before starting a new backup.  By default on the
system, the backup interval is `3600` seconds, or a backup every hour.

**Note** this configuration can only be changed if [System Integrity Protection][spi-url] is turned off.  This can be
done by entering the terminal in Recovery Mode and typing:

```bash
csrutil disable
```

A warning will be displayed if SPI has not been disabled; however, the configuration script will not halt.

#### time_machine.volumes

This is a list of Volumes to set as backup destinations for Time Machine.  The volumes must already be mounted before
running the Time Machine configuration.

#### time_machine.exclude

This is a list of directories and/or files that Time Machine should exclude when making backups.  Common
configurations for this are download folders, Dropbox, etc...



[yaml-url]:          http://yaml.org/
[ansible-vault-url]: https://docs.ansible.com/ansible/latest/vault.html
[gist-url]:          https://gist.github.com/

[profiles-url]:      https://github.com/andrewvaughan/mymac/tree/latest/profiles
[no-op-url]:         https://github.com/andrewvaughan/mymac/tree/latest/profiles/noop.yml

[apple-sudo]:        https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man8/sudo.8.html
[spi-url]:           http://osxdaily.com/2015/10/05/disable-rootless-system-integrity-protection-mac-os-x/
