target_user = ENV["SUDO_USER"]
target_user_home = Paths.user(target_user)

rustup = target_user_home.join(".cargo/bin/rustup")

# Tasks
execute "Install rustup" do
  command "xbps-install -y rustup"
  only_if { Internet.online? }
  not_if { Paths.bin.join("rustup-init").exist? }
end

execute "Install rust-nightly" do
  command "rustup-init --default-toolchain nightly -y"
  user target_user
  environment ({ "HOME" => "#{target_user_home}" })
  only_if { Internet.online? }
  not_if "#{rustup} default | grep nightly"
end
