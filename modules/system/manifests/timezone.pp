# This module manages the system's timezone setting.
class system::timezone(
  String[1] $hwclock = lookup('system.timezone.hwclock'),
  String[1] $localtime = lookup('system.timezone.localtime'),
) {
  if ($hwclock == 'localtime') {
    augeas {:}
  }

  file {'/etc/localtime':
    ensure => link,
    target => "/usr/share/zoneinfo/${localtime}",
  }
}
