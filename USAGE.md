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

The MacOS module performs checks to ensure that the configuration script is working on a supported platform.  It is
highly recommended that you do not modify this setting, unless you are actively developing or modifying the product.

To skip compatibility checks, set `macos` to `false` in your profile configuration:

```yml
macos: false
```

Alternatively, you can specify a major and minor version, which will act as the minimum version supported for the
profile:

```yml
macos: 10.13
```

_Note: Reversion version checks are not supported at this time._

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




[apple-sudo]:   https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man8/sudo.8.html
