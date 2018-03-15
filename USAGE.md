# Usage

This file contains details on how to prepare a profile for use with this playbook.  Provided examples include:

* `profiles/noop.yml` - prevents all operations from performing
* `profiles/personal.yml` - Andrew's personal settings used for his personal computers

Each of these profiles is documented for others to potentially use to their beneift.

## Running Scripts

MyMac provides two options for running profiles, a recommended online installer, which can be run from the terminal
and manages all dependencies, or from Ansible directly, which is intended for advanced users.

### Running with the Online Installer

To run a profile from the online installer's latest release, simply provide the profile in the `MYMAC_PROFILE`
environment variable and invoke the online script, such as:

```bash
MYMAC_PROFILE="~/mymac.yml" /bin/bash <(curl -fsSL https://raw.githubusercontent.com/andrewvaughan/mymac/master/install)
```

Alternatively, the development release of MyMac can be run by using the `-m` flag:

```bash
MYMAC_PROFILE="~/mymac.yml" /bin/bash <(curl -fsSL https://raw.githubusercontent.com/andrewvaughan/mymac/master/install) -m
```

### Running directly with Ansible

Advanced users may wish to run their profile directly with Ansible.  In this case, download the repository and, within
the root folder, run the Ansible playbook:

```bash
MYMAC_PROFILE="~/mymac.yml" ansible-playbook playbook.yml
```

## Creating a Custom Profile

To create a custom profile, create a YML file in the format similar to one of the examples in the `profiles` folder
and include that as the `MYMAC_PROFILE` environment variable when starting.  The files do _not_ have to be in the
`profiles` folder to work.  For example, to run this playbook with a configuration profile located at
`~/myprofile.yml`:

```bash
MYMAC_PROFILE="~/myprofile.yml" ansible-playbook playbook.yml
```

This will load the configuration from the `~/myprofile.yml` file and will run the playbook accordingly.  By default,
any sections that are omitted are skipped from execution.

> ***NOTE:*** This playbook has the ability to cause significant harm to your system.  This software is provided "as
> is", without warranty of any kind, express or implied.  The authors and maintainers provide no warranty of any kind,
> and are not liable for any claim, damages, or other liability, as described in the project [LICENSE](LICENSE):
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
> WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
> COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
> OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Configurations

Numerous configurations and installations are made when running this script.  Each is defined by a configuration
variable in a profile.

### macos

The MacOS module performs checks to ensure that the configuration script is working on a supported platform.  
Additionally, it can upgrade the macOS version to the latest version, if requested.  The `macos` section has two
variables:

```yml
# Example...
macos:
  version_check : 10.13
  update        : true
```

To skip compatibility and version checks and updates entirely, disable the entire block:

```yml
macos: false
```

#### version_check

The `version_check` parameter sets the minimum version that must be installed for the application to proceed.  Only
the Major and Minor revisions are supported at this time.  For instance, to support OSX "El Capitan" and later:

```yml
macos:
  version_check: 10.13
```

_Note: Reversion version checks are not supported at this time._

For reference, the labeled versions of OSX and macOS releases are as follows:

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

To skip compatibility checks, you can also set the `version_check` option to `false`:

```yml
macos:
  version_check: false
```

#### update

The `update` option is a boolean metric that will update the macOS version to it's latest version if set to `true`.
By default, this is not enabled, due to the number of restarts often required with system updates:

```yml
macos:
  update: true
```

**Note** that this does *not* update App Store items or any other software, just the base operating system.  To update
other applications, see the [#appstore](appstore) option.

### sudoers

The system's [sudo functionality][apple-sudo], including permissions and aliases, can be configured using this
playbook.  The existing `sudoers` file is not modified, rather, an additional MyMac configuration is placed in a
dependency folder.

This is done with the `sudoers` configuration variable in a profile:

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

Alternatively, only portions of these variables can be set, if needed:

```yml
sudoers:
  users:
    - "sally   ALL = (ALL) ALL"
```

#### user_aliases

`user_aliases` are used to specify groups of users. You can specify usernames, system groups (prefixed by a `%`) and
netgroups (prefixed by a `+`).

More details can be found [here](https://help.ubuntu.com/community/Sudoers#User_Aliases).

#### runas_aliases

`runas_aliases` are almost the same as `user_aliases`, but you are allowed to specify users by uid's. This is helpful,
as usernames and groups are matched as strings, so two users with the same uid but different usernames will not be
matched by entering a single username, but can be matched with a uid.

More details can be found [here](https://help.ubuntu.com/community/Sudoers#Runas_Aliases).

#### host_aliases

A `host_alias` is a list of hostname, ip addresses, networks and netgroups (prefixed with a `+`). If you do not
specify a netmask with a network, the netmask of the hosts ethernet interface(s) will be used when matching.

More details can be found [here](https://help.ubuntu.com/community/Sudoers#Host_Aliases).

#### cmnd_aliases

`cmnd_aliases` are lists of commands and directories. You can use this to specify a group of commands. If you
specify a directory it will include any file within that directory but not in any subdirectories.

More details can be found [here](https://help.ubuntu.com/community/Sudoers#Command_Aliases).

#### users

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

### devtools

The `devtools` option will take care of installing Homebrew (as a dependency), XCode, and the XCode Command Line
Tools.  You will likely get a popup, if Command Line Tools has not been installed, that you will b required to
interact with along the process.  Failure to react to this modal may cause the script to exit prematurely.

All that is needed to ensure `devtools` are created is to set the value to `true` in the profile:

```yaml
devtools: true
```

This is highly recommended, as many other platforms rely on `devtools` to be installed.  An error will be thrown at a
later point in the script if any portion of the configuration relies on `devtools` and it has not been enabled.



[apple-sudo]:   https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man8/sudo.8.html
