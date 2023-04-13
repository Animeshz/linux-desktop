pkgs = %w[
  alsa-utils
  wmctrl
  7zip
]

execute "Install utilities" do
  command "xbps-install -y #{pkgs.join(" ")}"
end
