# duo_authproxy
#
# Installs and configures Duo Authentication Proxy
#
# @summary Installs and configures Duo Authentication Proxy
#
# @example
#   include duo_authproxy
class duo_authproxy (
  Array[String] $dep_packages,
  String $version,
  String $python_env,
  String $checksum,
  Stdlib::Absolutepath $build_dir,
  Stdlib::Absolutepath $extract_dir,
  Stdlib::Absolutepath $install_dir,
  Hash $settings = {},
  $proxy_server  = undef,
  $proxy_type    = undef,
) {

  if $facts['os']['family'] == 'RedHat' {
    if versioncmp($facts['os']['release']['major'], '8') < 0 {
      $python_version = $facts['python3_version']
    }
  } elsif $facts['os']['family'] == 'Debian' {
    if versioncmp($facts['operatingsystemrelease'], '18.04') < 0 {
      $python_version = $facts['python3_version']
    }
  } else {
    $python_version = $facts['python_version']
  }

  unless (($python_version == undef) or (versioncmp($python_version, '2.6') >= 0 )) {
    fail("${name} requires at least python version 2.6, you have ${python_version}.")
  }

  contain 'duo_authproxy::install'
  contain 'duo_authproxy::config'
  contain 'duo_authproxy::service'

  Class['duo_authproxy::install']
  -> Class['duo_authproxy::config']

  Class['duo_authproxy::install']
  ~> Class['duo_authproxy::service']

  Class['duo_authproxy::config']
  ~> Class['duo_authproxy::service']
}
