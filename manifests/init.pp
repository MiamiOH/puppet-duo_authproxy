# @summary Installs and configures Duo Authentication Proxy
#
# @example including the module in a profile
#   include duo_authproxy
#
# @example in hiera
#   duo_authproxy::version: '4.0.2'
#   duo_authproxy::install_dir: '/opt/duoauthproxy'
#   duo_authproxy::settings:
#     main:
#       debug: true
#       http_proxy_host: 'my.proxy.example.com'
#       http_proxy_port: 80
#     ad_client:
#       host: 'host.ad.example.com'
#       service_account_username: 'service-account'
#       service_account_password: 'password'
#       search_dn: 'cn=users,dc=ad,dc=example,dc=com'
#     ldap_server_auto:
#       ikey: 'ikey'
#       skey: 'encrypt-with-eyaml'
#       api_host: 'api_host'
#
# @example resource-like class declaration with parameters
#   class { 'duo_authproxy':
#     version     => '4.0.2',
#     install_dir => '/opt/duoauthproxy'
#     settings    => {
#       # All required config sections and settings
#       'main' => {
#         'debug' => 'true',
#       },
#        'ad_client' => {
#          'host'                     => 'host.ad.example.com',
#          'service_account_username' => 'service-account',
#          'service_account_password' => 'password',
#          'search_dn'                => 'cn=users,dc=ad,dc=example,dc=com',
#       },
#     },
#   }
#
class duo_authproxy (
  Array[String] $dep_packages,
  String $version,
  Stdlib::Absolutepath $install_dir,
  Hash $settings,
  Optional[String] $proxy_server,
  Optional[Enum['none', 'ftp', 'http', 'https']] $proxy_type,
) {

  contain duo_authproxy::install
  contain duo_authproxy::config
  contain duo_authproxy::service

  Class['::duo_authproxy::install']
  -> Class['::duo_authproxy::config']
  ~> Class['::duo_authproxy::service']

}
