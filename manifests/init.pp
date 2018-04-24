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
) {

  contain '::duo_authproxy::install'
  contain '::duo_authproxy::config'

  Class['::duo_authproxy::install']
  -> Class['::duo_authproxy::config']
}
