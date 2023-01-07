# This module manages system-wide environment variable configuration
class system::environment_variables {
  $env_file = '/etc/environment'

  file { $env_file:
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  echo { 'env-changed':
    message => 'Please relogin/reboot to refresh changes to the environment variables',
    refreshonly => true,
  }
}

# Applies environment variable config
define system::environment_variables::new ($value) {
  include system::environment_variables

  $key = $title
  augeas { "shell_conf/${key}":
    context => "/files/${system::environment_variables::env_file}",
    onlyif  => "get ${key} != '${value}'",
    changes => "set ${key} '${value}'",
    notify  => Echo['env-changed'],
  }
}
