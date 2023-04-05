# System utility modules like for setting timezone, grub, services, etc.
class system {}

# 
define system::config ($key, $value, $parameters) {
  $file = $title

  augeas { "${key}_${value}":
    incl    => $file,
    onlyif  => "get ${key} != '${value}'",
    changes => "set ${key} '${value}'",
    *       => $parameters
  }
}
