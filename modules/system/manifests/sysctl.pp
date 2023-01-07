# This module manages the sysctl setting.
class system::sysctl (
  String[1] $sysctl_file = '/etc/sysctl.conf',
) {
  include packages::augeas

  file { $sysctl_file:
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  exec { 'sysctl-load':
    command     => 'sysctl -p',
    refreshonly => true,
    subscribe   => File[$sysctl_file],
  }
}

# Applies sysctl config
define system::sysctl::conf ($value) {
  include system::sysctl
  $key = $title

  augeas { "sysctl_conf/${key}":
    context => "/files/${system::sysctl::sysctl_file}",
    onlyif  => "get ${key} != '${value}'",
    changes => "set ${key} '${value}'",
    require => Package['ruby-augeas'],
    notify  => Exec['sysctl-load'],
  }
}
