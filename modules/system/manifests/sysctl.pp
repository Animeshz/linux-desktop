# This module manages the sysctl setting.
class system::sysctl (
  String[1] $sysctl_file = '/etc/sysctl.conf',
) {
  file { $sysctl_file:
    ensure => present,
  }

  package { 'augeas': ensure => installed }
  package { 'augeas-devel': ensure => installed }  # TODO: Make optional for non-debian/non-void systems
  package { 'ruby-augeas': ensure => installed, provider => gem, require => [Package['augeas'], Package['augeas-devel']] }

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
    context => '/files/etc/sysctl.conf',
    onlyif  => "get ${key} != '${value}'",
    changes => "set ${key} '${value}'",
    require => Package['ruby-augeas'],
    notify  => Exec['sysctl-load'],
  }
}
