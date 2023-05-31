require "json"

facts = JSON.parse(`facter --json --custom-dir $PWD/inputs --external-dir $PWD/inputs`)

# Dynamic functions:
# https://github.com/Animeshz/linux-desktop/blob/puppet/modules/packages/lib/puppet/provider/package/xbps.rb
System do
  boot :set => "grub"  # uki, zfs-boot-menu
  timezone :set => "Asia/Kolkata"
end
