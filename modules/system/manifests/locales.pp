# This module manages the system's locales setting.
class system::locales (
  Array[String] $locales        = ['en_US.UTF-8 UTF-8'],
  String[1]     $config_file    = $facts['os']['family'] ? { 'Void' => '/etc/locale.conf',                        default => '/etc/locale.gen' },
  String[1]     $default_file   = $facts['os']['family'] ? { 'Void' => '/etc/default/libc-locales',               default => '/etc/locale.conf' },
  String[1]     $locale_gen_cmd = $facts['os']['family'] ? { 'Void' => 'xbps-reconfigure --force glibc-locales',  default => '/usr/bin/locale-gen' },
  String[1]     $package        = $facts['os']['family'] ? { 'Void' => 'glibc-locales',                           default => 'glibc' },
  String[1]        $default_locale      = split($locales[0], / /)[0],
  Optional[String] $language            = undef,
  Optional[String] $lc_ctype            = undef,
  Optional[String] $lc_collate          = 'C',
  Optional[String] $lc_time             = undef,
  Optional[String] $lc_numeric          = undef,
  Optional[String] $lc_monetary         = undef,
  Optional[String] $lc_messages         = undef,
  Optional[String] $lc_paper            = undef,
  Optional[String] $lc_name             = undef,
  Optional[String] $lc_address          = undef,
  Optional[String] $lc_telephone        = undef,
  Optional[String] $lc_measurement      = undef,
  Optional[String] $lc_identification   = undef,
  Optional[String] $lc_all              = undef,
) {
  package { $package: ensure => present }

  file { $config_file:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/locale.conf.erb"),
    require => Package[$package],
    notify  => Exec['locale-gen'],
  }

  file { $default_file:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/libc-locales.erb"),
    require => Package[$package],
  }

  exec { 'locale-gen':
      command     => $locale_gen_cmd,
      refreshonly => true,
      require     => Package[$package],
      timeout     => 900, # seconds
    }
}
