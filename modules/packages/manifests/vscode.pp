# Ensures vscode package is present and extensions are installed
class packages::vscode (
  String[1]             $config_location,
  Optional[String]      $global_extension_dir = '/var/lib/vscode/extensions',
  String                $ensure               = 'installed',
  String                $package              = 'vscode',
  Optional[String]      $settings,
  Optional[Array[Any]]  $extensions,
) {
  package { $package: ensure => $ensure }

  file { "${config_location}/User/settings.json":
    ensure  => present,
    content => $settings,
    require => Package[$package]
  }

  exec { "mkdir -p ${global_extension_dir}":
    unless => "test -d ${global_extension_dir}"
  } -> file { $global_extension_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0777',
    require => Package[$package]
  }

  system::environment_variables::new { 'VSCODE_EXTENSIONS':
    value => $global_extension_dir
  }
  -> if $extensions {
    package { $extensions: ensure => installed, provider => 'vscode' }
  }
}
