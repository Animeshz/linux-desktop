<p align="center">
    <img src="https://i.imgur.com/YHr1OMl.png" align="center">
</p>


## Info

```
os      void x86_64
ker     5.13.12_1
init    runit
de/wm   herbstluftwm
bar     eww
term    kitty
prompt  starship
sh      fish
editor  nvim / micro / vscode
font    CaskaydiaCove Nerd Font
```


## Screenshots

**Bar:**

![Screenshots/eww_bar_early.jpg](https://github.com/Animeshz/linux-desktop/blob/media/Screenshots/eww-bar.jpg)


## Tree

Generated using `make tree`, see [Animeshz/scripts](https://github.com/Animeshz/scripts).

```
$HOME
├── .bashrc
├── .config
│   ├── eww
│   │   ├── eww.scss
│   │   ├── eww.yuck
│   │   └── scripts
│   │       ├── headphone
│   │       ├── volume
│   │       └── xworkspaces
│   ├── fish
│   │   └── config.fish
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
│   ├── starship.toml
│   └── yadm
│       └── bootstrap
├── .xinitrc
├── Makefile
├── README.md
├── Screenshots
│   └── capture.jpg
└── UNLICENSE
```


## Install

#### NOTICE:
**This section is still WIP don't use this section right now (Makefile contains non implemented recipies rn). Use `git clone` and copy/use manually for now :3**

Read the [Makefile](https://github.com/Animeshz/linux-desktop/blob/main/Makefile) to understand the things being done easily!

### Complete Bootstrap

Requirements: git, [yadm](https://github.com/TheLocehiliosan/yadm), make

**NOTE: This will override your current dotfiles, please backup your original dotfiles before running any of the following commands.**

```bash
yadm clone https://github.com/Animeshz/linux-desktop
yadm bootstrap  # if didn't prompted in above command
```

This hides Makefile, README.md and UNLICENSE. To unhide, run `dotunhide` to hide them back `dothide` (since these are alias, you may need to reopen the shell).

### Partial Bootstrap (take as you like)

Requirements: git, make

```bash
git clone https://github.com/Animeshz/linux-desktop
cd linux-desktop
make
```

This will list all the possible user-interfacing options available.

Then run the following for whatever you like to setup.

**NOTE: This will override your current dotfiles, please backup your original dotfiles before running any of the following commands.**

```bash
make <option>
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

