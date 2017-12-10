# How I use Ansible to manage servers #

Ansible is a great tool for running templated commands and ensuring you don't miss anything when configuring new virtualhosts. My preference of server OS is Ubuntu LTS or Debian so these playbooks and configs are made for and tested on those platforms.

I prefer Ansible as it uses SSH and Python which are typically already installed and doesn't require any additional agent. Naturally this means that if you are managing multiple servers, you need to use the same username and key (or password) across all of them.

If you are given a `root` user by default (e.g. on a DigitalOcean droplet) instead of a sudo user (e.g. on an AWS EC2 instance) you should create yourself a sudo user and use that in your playbooks.

`# mkdir /home/wh && useradd wh --shell /bin/bash && passwd wh && chown -R wh:wh /home/wh && adduser wh sudo`

A passwordless sudo user is easier to work with but only makes sense when you are using keys, `$ sudo visudo` and `wh ALL=(ALL) NOPASSWD:ALL` will do the trick but remember the lines are applied in order so add that towards the end of the file.

Once you have a sudo user, you should remove the ability to log in as `root` on SSH by setting `PermitRootLogin no` in `/etc/ssh/sshd_config`.

The approach I use is to have all configuration for a server in a git repository which is then cloned onto the server and the configuration files simlinked. This means all changes are tracked and new servers can be set up very quickly.

In some cases I do not tend to use dedicated Ansible modules such as `git` or `file` because the commands I would like to run are shorter than repeated slightly varied tasks.

For redirects that aren't www related, (i.e. something.com to example.com) I prefer to keep those in the registrars configuration but theres nothing stopping you adding them to your configuration.

## Using Ansible ##

These should work with Ansible 2.4 but I know some things like `include` are being deprecated so this will need amending shortly.

#### Windows ####

Windows 10 is my main OS so I use WSL (Ubuntu on Windows) and use the PPA installation over whatever is available in the standard APT repositories.

You can use cygwin but an extra command is required `$ export ANSIBLE_SSH_ARGS="-o ControlMaster=no"`

See more here: http://translate.google.co.uk/translate?hl=en&sl=ja&u=http://blog.s-uni.net/2013/08/27/ansible-running-on-cygwin/&prev=/search%3Fq%3Dcygwin%2Bansible%2Bmux_client_request_session:%2Bsend%2Bfds%2Bfailed%26client%3Dfirefox-a%26hs%3DZLp%26rls%3Dorg.mozilla:en-US:official%26channel%3Dfflb%26biw%3D1366%26bih%3D664

#### Mac ####

Using Python and PIP is the best way here. If you are having issues with PIP not installing stuff on your Mac without homebrew, try `--ignore-installed` as an option on it.

## Using this repository ##

You should make your own copy of this repository and change probably every instance of `organisation` to the name of your organisation or brand.

Using your terminal of choice, `cd` to root of this repository. Use `head` to get the top lines of the playbook you want to use and copy paste the command. Answer the questions and the actions will be made.

When generating new files, you will have to commit and push them yourself which gives you the option to review and adjust the contents as necessary.

### Log Files ###

You will notice that the log files are generated in the website directories. This means you won't find them in `/var/log` as it makes them more accessible to the system user running the website (which may be shared with a third party) and also means if you ever shut down the website, you will remove the log files for that website as well.
