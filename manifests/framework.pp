Exec {
  path => ['/usr/local/bin', '/usr/bin', '/bin', '/usr/local/sbin', '/usr/sbin', '/sbin'],
}

class { 'system::timezone': timezone => 'Asia/Kolkata' }
class { 'system::locales':
  locale_gen_cmd => 'xbps-reconfigure --force glibc-locales',
  locales        => ['en_US.UTF-8 UTF-8'],
}
system::sysctl::conf {
  'vm.swappiness':                  value =>  10;
  'dev.i915.perf_stream_paranoid':  value =>  0;
}

# class {'packages':}
