# Ensures vscode package is present and 
class packages::vscode (
  String[1]             $binary_name,
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

  # TODO: actually do things
  notify {$extensions:}
  # $binary_name --list-extensions
  # $binary_name --install-extension ms-vscode.cpptools
  # $binary_name --uninstall-extension ms-vscode.csharp

}
