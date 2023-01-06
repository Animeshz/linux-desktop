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
system::grub::conf {
  'GRUB_DEFAULT':               value => 'saved';
  'GRUB_SAVEDEFAULT':           value => true;
  'GRUB_HIDDEN_TIMEOUT':        value => 0;
  'GRUB_HIDDEN_TIMEOUT_QUIET':  value => false;
  'GRUB_TIMEOUT':               value => 2;
  'GRUB_CMDLINE_LINUX_DEFAULT': value => '"loglevel=4 acpi_osi=\\\'Windows 2020\\\' net.ifnames=0 i915.enable_psr=1 intel_pstate=disable nvme.noacpi=1 intel_iommu=on rd.driver.pre=vfio-pci kvm.ignore_msrs=1"';
  'GRUB_DISABLE_OS_PROBER':     value => false;
}

# class {'packages':}
