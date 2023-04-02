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


## Install

```bash
# change based on your distro
sudo xbps-install just pkg-config ruby ruby-devel

just setup
just apply --noop  # dry-run: check what will it do without doing anything
just apply
```


## LICENSE

Licensed under Creative Commons Attribution 4.0 International, see the [LICENSE](LICENSE) for more information.

## Acknowledgement

  - [LinuxJournal article](https://www.linuxjournal.com/content/managing-linux-using-puppet) for step-by-step use of puppet to manage linux-system.
  - [A sample configuration](https://www.reddit.com/r/linux/comments/1aqiqo/i_switched_to_using_puppet_to_manage_my_desktop) for quickly starting with puppet language (as the docs are messy).

