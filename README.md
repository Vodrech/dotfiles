# dotfiles

Welcome to Vodrech dotfiles, this consists of system setup and other type of configurations

OS: Arch Linux x86_64
OS-Setup: archinstall

Package-Manager: Pacman (Default)
AUR-Package-Helper: Yay (Needs configurations)

# WM - Window Manager

## I3

This setup consits of `tiling` format.
Launch scripts are specified in the bottom of the i3 configurations and is created in each respective section.
The `exec` is used for only startup events of the i3.
The `exec_always` is used for restart & startup events of the i3.

### I3 - ADDITIONAL

These programs are setup with a launch scripts in the i3 configuration to make a more friendly desktop environment.

- Nitrogen (Wallpaper engine)
- Polybar (Statusbar)
- Picom (Compositor) [Xorg]
- Dunst (Notification Daemon)

# DS - Display Server

## Xorg

UI-Setup: `arandr`
CMD-Setup: `xrandr`

# AUDIO

## Pulseaudio

Using Pulseaudio as my audio manager which is built on top of ALSA, more info can be found in:
(PulseAudio - Arch)[https://wiki.archlinux.org/title/PulseAudio]

UI-Setup: `pavucontrol`
CMD-Setup: `pacmd`
Config: ~/.config/pulse

# ADDITIONAL

These are additional packages/programs that is used on a daily basis

- Nvim (Text Editor/PDE/IDE) [config: nvim]
- Spotify-TUI (Music) [config: spotify-tui, needs: spotifyd]
- Cava (Music Visualizer) [config: cava]
- Neofetch (OS Describer) [config: neofetch]
- Git (Version Control) [config: etc/gitconfig, auto-create: NO]
- Timer (Time Visualizer) [config: timer-bin]
