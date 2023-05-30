cli_utils = %w[
  7zip
  alsa-utils
  btop
  iwd
  neovim
  pulsemixer
  wmctrl
]

execute "Install utilities" do
  command "xbps-install -y #{cli_utils.join(" ")}"
end
