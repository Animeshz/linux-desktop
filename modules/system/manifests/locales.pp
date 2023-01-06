# This module manages the system's locales setting.
class system::locales (
  String[1]     $locale_gen_cmd,
  Array[String] $locales        = ['en_US.UTF-8 UTF-8'],
  String[1]     $config_file    = '/etc/locale.conf',
  String[1]     $default_file   = '/etc/default/libc-locales',
  String[1]     $package        = 'glibc-locales',
  String[1]        $default_locale      = $locales[0],
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
