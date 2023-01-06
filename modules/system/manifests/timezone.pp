# This module manages the system's timezone setting.
class system::timezone(
  String[1] $timezone = 'UTC',
) {
  file {'/etc/localtime':
    ensure => link,
    target => "/usr/share/zoneinfo/${timezone}",
  }
}
