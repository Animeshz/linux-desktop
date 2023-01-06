# Ensures augeas package and ruby bindings are present
class packages::augeas (
  $ensure = installed,
) {
  $augeas = $facts['os']['family'] ? {
    'Void'  => ['augeas', 'augeas-devel'],
    default => ['augeas']
  }

  package { $augeas:
    ensure => $ensure,
    before => Package['ruby-augeas']
  }

  package { 'ruby-augeas':
    ensure   => $ensure,
    provider => gem
  }
}
