if node["platform"] == "void"
  node.default["platform_family"] = "void"
end
node.default["CHEF_GROUP"] = "chef"

# Tasks
group node["CHEF_GROUP"] do
  append true
  members %w[animesh]
end
