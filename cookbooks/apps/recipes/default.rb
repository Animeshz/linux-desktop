execute "Sync xbps" do
  command "xbps-install -S"
  only_if { Internet.online? }
end

include_recipe "apps::fonts"
include_recipe "apps::herbstluftwm"
include_recipe "apps::vscode"
include_recipe "apps::rust"
include_recipe "apps::eww"
include_recipe "apps::utilities"
include_recipe "apps::xbps-src"