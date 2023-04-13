include_recipe "apps::rust"
include_recipe "apps::fonts"

target_user = ENV["SUDO_USER"]
target_user_home = Paths.user(target_user)
destination = target_user_home.join("Projects/others")

# Tasks
git "Clone elkowar/eww repository" do
  repository "https://github.com/elkowar/eww"
  destination "#{destination}/eww"
  revision "master"
  user target_user
  group node["CHEF_GROUP"]
  only_if { Internet.online? }
end

execute "Install eww dependencies" do
    command "xbps-install -y gcc pkg-config glib-devel gdk-pixbuf atk-devel cairo-devel pango-devel gtk+3-devel gtk-layer-shell-devel"
end

execute "Build eww" do
  command "rm -f rust-toolchain.toml && cargo build --release"
  cwd "#{destination}/eww"
  user target_user
  environment ({ "HOME" => "#{target_user_home}" })
end
