if node["platform"] == "void"
  node.default["platform_family"] = "void"
end
node.default["CHEF_GROUP"] = "chef"

target_user = ENV["SUDO_USER"]

# Tasks
group node["CHEF_GROUP"] do
  append true
  members [target_user]
end
