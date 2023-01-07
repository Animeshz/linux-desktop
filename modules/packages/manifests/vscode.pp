# Ensures vscode package is present and extensions are installed
class packages::vscode (
  String[1]             $config_location,
  String                $ensure     = 'installed',
  String                $package    = 'vscode',
  Optional[String]      $settings,
  Optional[Array[Any]]  $extensions,
) {
  package { $package: ensure => $ensure }

  file { "${config_location}/User/settings.json":
    ensure  => present,
    content => $settings,
  }

  if $extensions {
    package { $extensions: ensure => installed, provider => 'vscode' }
  }
}
