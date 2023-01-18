# Manages config for chromium-based browser
# $user => $title, if not passed explicitly
define packages::chromium::config (
  String[1]            $config_location,
  Optional[String]     $user        = undef,
  Array[String]        $cli_flags   = [],
  Hash[String, Hash]   $extensions  = {},
) {
  if !$user {
    $_user = $title
  }

  $extensions.each |$name, $overwrite| {
    $data = { ensure => present } + $overwrite
    $file = "${config_location}/External Extensions/${data['id']}.json"
    file { $file:
      ensure  => $data['ensure'],
      owner   => $_user,
      group   => 'puppet',
      mode    => '0644',
      content => '{"external_update_url": "https://clients2.google.com/service/update2/crx"}'
    }
  }
}
