# duo_authproxy::config
#
# Private class that configures the auth proxy
#
# @summary configure the proxy
#
# @example
#   don't use this class directly
class duo_authproxy::config {

  create_ini_settings($duo_authproxy::settings, {
      'path' => "${duo_authproxy::install_dir}/conf/authproxy.cfg",
  })
}
