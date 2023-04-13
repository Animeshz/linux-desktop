include_recipe "apps::utilities"

pkg_fonts = %w[
  noto-fonts-ttf
  noto-fonts-emoji
  font-unifont-bdf
]

zipped_fonts = {
  "Caskaydia Cove Nerd Font" => "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/CascadiaCode.zip",
}

execute "Install fonts" do
  command "xbps-install -y #{pkg_fonts.join(" ")}"
end

zipped_fonts.each do |font, link|
  file = link.split("/")[-1]

  execute "Install selective nerd-font: #{file.delete_suffix(".zip")}" do
    cwd "/tmp"
    # not working?
    command "wget -c #{link} &&
             7z x -x!'*Windows*' -y #{file} -o/usr/share/fonts/TTF &&
             rm #{file}"
    notifies :run, "execute[Refresh font cache]", :delayed
    not_if "ls /usr/share/fonts/TTF | grep '#{font}'"
  end
end

execute "Refresh font cache" do
  command "fc-cache -fv"
  action :nothing
end
