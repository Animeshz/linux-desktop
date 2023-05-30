include_recipe "apps::graphic-drivers"

# Tasks
execute "Install intel drivers" do
    command "xbps-install -y mesa-vulkan-intel intel-video-accel xf86-video-intel linux-firmware-intel"
end