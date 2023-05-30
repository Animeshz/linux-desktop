# Tasks
execute "Install graphic drivers" do
    command "xbps-install -y mesa-dri vulkan-loader"
end
