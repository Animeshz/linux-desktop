Exec {
  path => ['/usr/local/bin', '/usr/bin', '/bin', '/usr/local/sbin', '/usr/sbin', '/sbin'],
}

$primary_user = 'animesh'

# === System ===

class { 'system::timezone': timezone => 'Asia/Kolkata' }
class { 'system::locales':  locales  => ['en_US.UTF-8 UTF-8']}

# Uses agueas, doesn't override other options present in the file
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
mount { '/sys/firmware/efi/efivars':
  ensure  => 'mounted',
  device  => 'efivarfs',
  fstype  => 'efivarfs',
  options => 'nosuid,noexec,nodev',
}


# === Users ===

user { $primary_user:
  ensure     => present,
  system     => false,
  managehome => true,
  home       => '/home/animesh',
  shell      => '/usr/bin/fish',
  groups     => ['wheel'],
  membership => 'minimum',
  # require    => [Class['packages::fish']],
  password   => file('configs/private/password'),
}


# === Packages ===

class {'packages::vscode':
  ensure          => installed,
  config_location => "/home/${primary_user}/.config/Code - OSS/",
  settings        => file('configs/vscode/settings.json'),
  extensions      => [
    'asvetliakov.vscode-neovim',
    'brettm12345.nixfmt-vscode',
    'Equinusocio.vsc-material-theme',
    'ms-python.python',
    # 'ms-toolai.jupyter'
    # ms-vscode-remote.remote-ssh
    # ms-vscode-remote.remote-containers
    'ms-vscode.cpptools',
    'rust-lang.rust-analyzer',
  ],
}

