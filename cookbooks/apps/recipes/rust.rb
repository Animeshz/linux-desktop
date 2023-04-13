target_user = ENV["SUDO_USER"]
target_user_home = Paths.user(target_user)

# Tasks
execute "Install rustup" do
  command "xbps-install -y rustup"
  only_if { Internet.online? }
  not_if { Paths.bin.join("rustup-init").exist? }
end

# TODO: Install latest nightly using rustup
execute "Install rust-nightly" do
  command "rustup-init --default-toolchain nightly -y"
  user target_user
  environment ({ "HOME" => "#{target_user_home}" })
  only_if { Internet.online? }
  not_if { target_user_home.join(".cargo/bin/cargo").exist? }
end