# Ensures augeas package and ruby bindings are present
class packages::augeas {
  package { 'augeas': ensure => installed }
  package { 'augeas-devel': ensure => installed }  # TODO: Make optional for non-debian/non-void systems
  package { 'ruby-augeas': ensure => installed, provider => gem, require => [Package['augeas'], Package['augeas-devel']] }
}
