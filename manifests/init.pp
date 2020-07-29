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
  Stdlib::Absolutepath $install_dir,
  Hash $settings = {},
  $proxy_server = undef,
  $proxy_type = undef,
) {

  contain 'duo_authproxy::install'
  contain 'duo_authproxy::config'
  contain 'duo_authproxy::service'

  Class['::duo_authproxy::install']
  -> Class['::duo_authproxy::config']

  Class['::duo_authproxy::install']
  ~> Class['::duo_authproxy::service']

  Class['::duo_authproxy::config']
  ~> Class['::duo_authproxy::service']
}
