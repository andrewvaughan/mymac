# Usage

This file contains details on how to prepare a profile for use with this playbook.  All profiles inherit settings, by
default, from the [config.yml](config.yml) file, so this should be reviewed prior to making any changes or adding a
custom profile to this system.

## Creating a Custom Profile

To create a custom profile, simply create a file in the format `config.profile.yml`, where `profile` is replaced by
any name you wish.  By default, a `personal` and `work` profile are available, which can be referenced as a live
example of how profiles work.  To run your custom profile, simply run the playbook setting the appropriate environment
variable:

```bash
PROFILE=profile_name ansible-playbook playbook.yml --ask-become-pass
```

This will load all configurations from `config.yml`, followed by overrides or additions from your custom profile, and
will run the playbook accordingly.

Copyright 2017 Andrew Vaughan

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

> ***NOTE:*** This playbook has the ability to cause significant harm to your system.  This software is provided "as
> is", without warranty of any kind, express or implied.  The authors and maintainers provide no warranty of any kind,
> and are not liable for any claim, damages, or other liability, as described in the project [LICENSE](LICENSE).

## Configurations

Numerous configurations and installations are made when running this script.  Each is defined by a configuration
variable in a profile.

### Disabling Sections

Any section defined in the parent `config.yml` file will be run on each profile.  In order to disable a configuration
entirely, it must be explicitly skipped by setting it's configuration to `false`.  For example, in order to skip the
`sudoers` configuration, the `sudoers` variable should be set in a profile as follows:

```yml
sudoers: false
```

Only this will disable tasks and configurations.  If a variable is ommitted from a profile, it will defer
configuration to the settings defined in the parent `config.yml` file.

### Sudoers

The system's [sudo functionality](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man8/sudo.8.html),
including permissions and aliases, can be configured using this playbook.  This is done with the `sudoers`
configuration variable:

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
    - "root    ALL = (ALL) ALL"
    - "%admin  ALL = (ALL) ALL"
```

Note, if your profile does not make use of one of the five options, do not omit that variable or errors will occur.
Instead, simply set that option to an empty array.  For example:

```yml
sudoers:
  user_aliases: []
  runas_aliases: []
  host_aliases: []
  cmnd_aliases: []
  users: []
```

By setting to a blank array, this will result in the default macOS section to be inserted (blank for all except
`users`).

#### user_aliases

User aliases are used to specify groups of users. You can specify usernames, system groups (prefixed by a %) and
netgroups (prefixed by a +).

More details can be found [here](https://help.ubuntu.com/community/Sudoers#User_Aliases).

#### runas_aliases

Runas Aliases are almost the same as user aliases but you are allowed to specify users by uid's. This is helpful as
usernames and groups are matched as strings so two users with the same uid but different usernames will not be matched
by entering a single username but can be matched with a uid.

More details can be found [here](https://help.ubuntu.com/community/Sudoers#Runas_Aliases).

#### host_aliases

A host alias is a list of hostname, ip addresses, networks and netgroups (prefixed with a +). If you do not specify a
netmask with a network the netmask of the hosts ethernet interface(s) will be used when matching.

More details can be found [here](https://help.ubuntu.com/community/Sudoers#Host_Aliases).

#### cmnd_aliases

Command aliases are lists of commands and directories. You can use this to specify a group of commands. If you
specify a directory it will include any file within that directory but not in any subdirectories.

More details can be found [here](https://help.ubuntu.com/community/Sudoers#Command_Aliases).

#### users

User Specifications are where the sudoers file sets who can run what as who. It is the key part of the file and all
the aliases have just been set up for this very point. If this was a film this part is where all the key threads of
the story come together in the glorious unveiling before the final climatic ending.

Users are defined in this format:

```
<user list> <host list> = <operator list> <tag list> <command list>
```

Unlike other sections, if this section is omitted, it will be replaced by the macOS default:

```
root    ALL = (ALL) ALL
%admin  ALL = (ALL) ALL
```

More details can be found [here](https://help.ubuntu.com/community/Sudoers#User_Specifications).
