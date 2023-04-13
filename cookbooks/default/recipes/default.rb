if node["platform"] == 'void'
  node.default['platform_family'] = 'void'
end
node.default['CHEF_GROUP'] = 'chef'

group node['CHEF_GROUP'] do
  append true
  members %w[animesh]
end

include_recipe "system"
include_recipe "apps"
