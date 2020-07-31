# @summary Manages the service of the Duo Authentication Proxy.
#
# @api private
#
class duo_authproxy::service {

  service { 'duoauthproxy':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => false, # the status on the init scrip does not return correct codes
    status     => "${duo_authproxy::install_dir}/bin/authproxyctl status",
  }

}
