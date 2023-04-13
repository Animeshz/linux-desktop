# https://github.com/chef/chef/pull/13683
#
# # Tasks
# directory "/sys/firmware/efi/efivars" do
#   owner "root"
#   group "root"
# end
# 
# mount "/sys/firmware/efi/efivars" do
#   device "efivarfs"
#   fstype "efivarfs"
#   options "nosuid,noexec,nodev"
#   pass 0
#   action [:enable, :mount]
# end