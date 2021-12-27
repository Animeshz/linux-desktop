<p align="center">
    <img src="https://i.imgur.com/YHr1OMl.png" align="center">
</p>


## Info

```
os      void x86_64
ker     5.15.4_1
init    runit
de/wm   herbstluftwm
bar     eww
term    kitty
prompt  starship
sh      fish
editor  nvim / vscode
font    CaskaydiaCove Nerd Font
```


## Screenshots

**Bar:**

![GIF/eww-bar.gif](https://github.com/Animeshz/linux-desktop/blob/media/GIF/eww-bar.gif)

<!-- TODO: Rofi image here -->
**All window closed:**

![Screenshots/24-Nov-15-41-12-PM.jpg](https://github.com/Animeshz/linux-desktop/blob/media/Screenshots/24-Nov-15-41-12-PM.jpg)

**Btop:**

![Screenshots/24-Nov-15-45-52-PM.jpg](https://github.com/Animeshz/linux-desktop/blob/media/Screenshots/24-Nov-15-45-52-PM.jpg)


## Tree

Generated using `git-tree --root \$HOME --noreport`, see [Animeshz/scripts](https://github.com/Animeshz/scripts).

```
$HOME
├── .Xresources
├── .bashrc
├── .config
│   ├── btop
│   │   └── btop.conf
│   ├── eww
│   │   ├── eww.scss
│   │   ├── eww.yuck
│   │   └── scripts
│   │       ├── battery
│   │       ├── pconsumption
│   │       ├── temperature
│   │       ├── volume
│   │       ├── weather
│   │       ├── wifi_ssid
│   │       └── xworkspaces
│   ├── fish
│   │   ├── config.fish
│   │   └── fish_variables
│   ├── herbstluftwm
│   │   └── autostart
│   ├── kitty
│   │   ├── kitty.conf
│   │   ├── theme.conf
│   │   └── themes
│   │       ├── Dark_Pastel.conf
│   │       ├── Desert.conf
│   │       ├── Dracula.conf
│   │       ├── FishTank.conf
│   │       ├── OneDark.conf
│   │       ├── TokyoNight.conf
│   │       ├── ayu.conf
│   │       ├── ayu_mirage.conf
│   │       ├── frenzy.conf
│   │       ├── idleToes.conf
│   │       ├── idleToes_bluebrightbg.conf
│   │       ├── idleToes_bluedarkbg.conf
│   │       └── sid_dark.conf
│   ├── micro
│   │   └── settings.json
│   ├── pipewire
│   │   ├── client.conf
│   │   ├── pipewire-pulse.conf
│   │   └── pipewire.conf
│   ├── pipr
│   │   ├── history
│   │   └── pipr.toml
│   ├── ranger
│   │   └── rc.conf
│   ├── starship.toml
│   ├── startup.sh
│   └── yadm
│       └── bootstrap
├── .gitconfig
├── .xinitrc
├── README.md
├── UNLICENSE
└── install-script.sh
```


## Install

#### NOTICE:
**This section is still WIP don't use this section right now (Makefile contains non implemented recipies rn). Use `git clone` and copy/use manually for now :3**

TODO: Build Yadm script for complete bootstrap and install-script.sh for partial stuffs picking.


### Remarks

  * Copy .config/pipewire to /etc/pipewire to use with void's runit services
    ```bash
    sudo mkdir -p /etc/pipewire
    sudo cp ~/.config/pipewire/*.conf /etc/pipewire
    ```


## UNLICENSE

```
Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

For more information, please refer to <http://unlicense.org/>
```


## Acknowledgement

  - [u/elkrien](https://www.reddit.com/user/elkrien) for config of minimal starship prompt
  - [Valeyard1](https://github.com/Valeyard1/dotfiles) for the README inspiration

