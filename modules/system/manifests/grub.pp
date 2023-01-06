# This module manages the grub setting.
class system::grub (
  String[1] $grub_file = '/etc/default/grub',
) {
  include packages::augeas

  file { $grub_file:
    ensure => present,
  }

  package { 'grub': ensure => installed }

  exec { 'grub-update':
    command     => 'sh -c "update-grub || grub-mkconfig -o /boot/grub/grub.cfg"',
    refreshonly => true,
    require     => Package['grub'],
    subscribe   => File[$grub_file],
  }
}

# Applies grub config
define system::grub::conf ($value) {
  include system::grub
  $key = $title

  augeas { "grub_conf/${key}":
    context => "/files/${system::grub::grub_file}",
    onlyif  => "get ${key} != '${value}'",
    changes => "set ${key} '${value}'",
    notify  => Exec['grub-update'],
  }
}
