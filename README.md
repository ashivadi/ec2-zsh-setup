# ec2-zsh-setup
I use this to quickly configure any EC2 to mimic my local mac settings

```
#Ubuntu
sudo apt update && sudo apt upgrade -y

```
```
#RHEL/AL2
sudo yum install git -y
```

```
git clone https://github.com/ashivadi/ec2-zsh-setup.git
chmod a+x ec2-zsh-setup/startup-abhshia.sh
./ec2-zsh-setup/startup-abhshia.sh
```

## Hammerspoon (macOS)

The configuration is backed up in `Hammerspoon/.hammerspoon/init.lua`.
Install [Hammerspoon](https://www.hammerspoon.org/) and grant it access in
System Settings → Privacy & Security → Accessibility.

From the repository root, restore the config with the commands below. Back up
any existing `~/.hammerspoon/init.lua` before replacing it.

```sh
mkdir -p ~/.hammerspoon
cp Hammerspoon/.hammerspoon/init.lua ~/.hammerspoon/init.lua
```

Choose **Reload Config** from Hammerspoon's menu bar menu.
Option + Shift + 1–9 jumps the pointer to a display; the laptop is first when
its built-in display is detected, followed by external displays left to right.
The config also provides Spectacle-style window positioning shortcuts.
Comments in the Lua file explain each shortcut and credit
[Spectacle](https://github.com/eczarny/spectacle) and
[CatchMouse](https://github.com/round/CatchMouse).
