# Ensures vscode package is present and extensions are installed
class packages::vscode (
  String                      $ensure               = 'installed',
  String                      $package              = 'vscode',
  String[1]                   $global_extension_dir = '/var/lib/vscode/extensions',
  Array[String]               $extensions           = [],
) {
  package { $package: ensure => $ensure }

  exec { "mkdir -p ${global_extension_dir}":
    unless => "test -d ${global_extension_dir}"
  }
  -> file { $global_extension_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'puppet',
    mode    => '0777',
    require => Package[$package]
  }
  -> system::environment_variables::new { 'VSCODE_EXTENSIONS':
    value => $global_extension_dir
  }
  -> if $extensions {
    package { $extensions: ensure => installed, provider => 'vscode' }
  }
}

# Defines config for vscode package (can be applied on multiple users)
# $title => user who want to be
define packages::vscode::config (
  String[1]                   $config_location,
  Optional[String]            $user                 = undef,
  Hash[String, Any]           $settings             = {},
  Array[Hash[String, String]] $keybinds             = [],
  Array[Hash[String, Any]]    $tasks                = [],
  Optional[String]            $update_check         = undef,
  Optional[String]            $ext_update_check     = undef,
) {
  if !$user {
    $_user = $title
  }

  $_settings = $settings +
    ($update_check ? {
      present => {'update.mode' => 'default'}, absent => {'update.mode' => 'none'}, default => {}
    }) +
    ($ext_update_check ? {
      present => {'extensions.autoCheckUpdates' => true}, absent => {'extensions.autoCheckUpdates' => false}, default => {}
    })

  # nobody talks about this mess (preserves ' under echo and escapes ")
  $settings_json = inline_template('<%= @_settings.to_json.gsub("\'", "\'\\"\'\\"\'").gsub(/\"/, "\\\\\"") %>')
  $settings_file = "${config_location}/User/settings.json"
  $settings_generate = "jq -s 'reduce .[] as \\\$x ({}; . * \\\$x)' <(sed \\\"s/[ \\t]*\\/\\/.*$//\\\" '${settings_file}') <(echo '${settings_json}')"
  file { $settings_file:
    ensure  => present,
    owner   => $_user,
    group   => 'puppet',
    mode    => '0664',
    require => Class['packages::vscode']
  }
  -> exec { 'update_settings':
    command => "bash -c \"cat <<< \\\$(${settings_generate}) > '${settings_file}'\"",
    unless  => "bash -c \"cmp --silent '${settings_file}' <(${settings_generate})\""
  }

  # nobody talks about this mess (preserves ' under echo and escapes ")
  $keybinds_json = inline_template('<%= @keybinds.to_json.gsub("\'", "\'\\"\'\\"\'").gsub(/\"/, "\\\\\"") %>')
  $keybinds_file = "${config_location}/User/keybindings.json"
  $keybinds_generate = "jq -s 'flatten | group_by(.key) | map(reduce .[] as \\\$x ({}; . * \\\$x))' <(sed \\\"s/[ \\t]*\\/\\/.*$//\\\" '${keybinds_file}') <(echo '${keybinds_json}')"
  file { $keybinds_file:
    ensure  => present,
    owner   => $_user,
    group   => 'puppet',
    mode    => '0664',
    require => Class['packages::vscode']
  }
  -> exec { 'update_keybinds':
    command => "bash -c \"cat <<< \\\$(${keybinds_generate}) > '${keybinds_file}'\"",
    unless  => "bash -c \"cmp --silent '${keybinds_file}' <(${keybinds_generate})\""
  }

  $_tasks = { version => '2.0.0', tasks => $tasks }
  # nobody talks about this mess (preserves ' under echo and escapes ")
  $tasks_json = inline_template('<%= @_tasks.to_json.gsub("\'", "\'\\"\'\\"\'").gsub(/\"/, "\\\\\"") %>')
  $tasks_file = "${config_location}/User/tasks.json"
  $tasks_generate = "jq -s '.[1].tasks=([.[].tasks]|flatten|group_by(.label)|map(reduce .[] as \\\$x ({}; . * \\\$x)))|.[1]' <(sed \\\"s/[ \\t]*\\/\\/.*$//\\\" '${tasks_file}') <(echo '${tasks_json}')"
  file { $tasks_file:
    ensure  => present,
    owner   => $_user,
    group   => 'puppet',
    mode    => '0664',
    require => Class['packages::vscode']
  }
  -> exec { 'update_tasks':
    command => "bash -c \"cat <<< \\\$(${tasks_generate}) > '${tasks_file}'\"",
    unless  => "bash -c \"cmp --silent '${tasks_file}' <(${tasks_generate})\""
  }
}
