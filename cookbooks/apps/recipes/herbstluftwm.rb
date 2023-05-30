include_recipe "apps::graphic-drivers"

# Tasks
execute "Install herbstluftwm" do
    command "xbps-install -y xorg herbstluftwm"
end