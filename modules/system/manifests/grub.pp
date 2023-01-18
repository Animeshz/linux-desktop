# This module manages the grub setting.
class system::grub (
  String[1] $grub_file = '/etc/default/grub',
) {
  include packages::augeas

  package { 'grub': ensure => installed }

  file { $grub_file:
    ensure  => present,
    require => Package['grub'],
  }

  exec { 'grub-update':
    command     => 'sh -c "update-grub || grub-mkconfig -o /boot/grub/grub.cfg"',
    refreshonly => true,
    require     => Package['grub'],
    subscribe   => File[$grub_file],
  }
}

# Applies grub config
define system::grub::config ($value) {
  include system::grub
  $key = $title

  augeas { "grub_conf/${key}":
    context => "/files/${system::grub::grub_file}",
    onlyif  => "get ${key} != '${value}'",
    changes => "set ${key} '${value}'",
    notify  => Exec['grub-update'],
  }
}
