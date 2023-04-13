target_user = ENV["SUDO_USER"]
destination = Paths.user(target_user).join("Projects/void-packages")
subpkg_destination = Paths.user(target_user).join("Projects/main")

subpkg_repositories = %w[
  https://github.com/Animeshz/void-xpackages
]

# Tasks
["#{destination}", "#{subpkg_destination}"].each do |dir|
  directory dir do
    user target_user
    group node["CHEF_GROUP"]
  end
end

git "Clone void-packages upstream repository" do
  repository "https://github.com/void-linux/void-packages"
  destination "#{destination}"
  revision "master"
  user target_user
  group node["CHEF_GROUP"]
  only_if { Internet.online? }
end

subpkg_repositories.each do |repo|
  dest = "#{subpkg_destination}/#{repo.split("/")[-1].delete_suffix(".git")}"

  git "Clone subpkg-repository: #{repo}" do
    repository repo
    destination dest
    revision "main"
    user target_user
    group node["CHEF_GROUP"]
    only_if { Internet.online? }
    notifies :run, "execute[Copy subpkg-repository: #{repo}, to upstream clone]", :immediately
  end

  execute "Copy subpkg-repository: #{repo}, to upstream clone" do
    command "cp -r #{dest}/* #{destination}/srcpkgs"
    action :nothing
    user target_user
    group node["CHEF_GROUP"]
  end
end
