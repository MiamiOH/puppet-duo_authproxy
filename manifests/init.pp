# @summary Installs and configures Duo Authentication Proxy
#
# @example Basic usage
#   class { 'duo_authproxy':
#     settings  => {
#       'ad_client' => {
#         'transport'           => 'ldaps',
#         'ssl_ca_certs_file'   => 'ca-bundle.crt',
#         'ssl_verify_hostname' => true,
#       },
#       'ldap_server_auto' => {
#           'client'              => 'ad_client',
#           'ssl_key_path'        => "${facts['fqdn']}.key",
#           'ssl_cert_path'       => "${facts['fqdn']}.crt",
#           'minimum_tls_version' => 'tls1.2',
#       },
#     },
#   }
#   contain 'duo_authproxy'
#
# @see https://github.com/MiamiOH/puppet-duo_authproxy
#
# @param dep_packages
#   Array list of packages to install prior to build
# @param version
#   Version of duoauthproxy to install (default: 6.5.2)
# @param python_env
#   Executable for python
# @param checksum
#   sha-256 checksum of downloaded tgz file
# @param build_dir
#   Absolute path to source directory
# @param extract_dir
#   Absolute path for extracted source files
# @param install_dir
#   Absolute path for installed binaries
# @param service_user
#   Service will run as specific user (default: duo_authproxy_svc)
# @param log_group
#   Syslog group for logging (default: duo_authproxy_grp)
# @param init_script
#   Whether to install systemd scripts (default: true)
# @param selinux
#   Whether to install the Authentication Proxy SELinux module (default: true)
# @param settings
#   Hash of values for main config 
# @param proxy_server
#   Address of proxy server (if needed)
# @param proxy_type
#   Type of proxy (none|http|https|ftp)
class duo_authproxy (
  Array[String] $dep_packages,
  String  $version,
  String  $python_env,
  String  $checksum,
  Stdlib::Absolutepath $build_dir,
  Stdlib::Absolutepath $extract_dir,
  Stdlib::Absolutepath $install_dir,
  String  $service_user  = 'duo_authproxy_svc',
  String  $log_group     = 'duo_authproxy_grp',
  Boolean $init_script   = true,
  Boolean $selinux       = true,
  Hash    $settings      = {},
  String  $proxy_server  = undef,
  String  $proxy_type    = undef,
) {
  if $facts['os']['family'] == 'RedHat' {
    if versioncmp($facts['os']['release']['major'], '8') < 0 {
      $python_version = $facts['python3_version']
    }
  } elsif $facts['os']['family'] == 'Debian' {
    if versioncmp($facts['os']['release']['full'], '18.04') < 0 {
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
