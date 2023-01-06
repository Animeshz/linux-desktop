# This module deals with installing packages and configuring them
class packages {
  package { 'r10k': ensure => installed, provider => gem }
}
