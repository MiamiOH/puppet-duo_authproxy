# duo_authproxy::service
#
# Private class that manages the service of the auth proxy
#
# @summary manage the service
#
# @example
#   don't use this class directly
class duo_authproxy::service {

  if $duo_authproxy::use_systemd {
    file { '/etc/systemd/system/duoauthproxy.service':
      ensure  => file,
      path    => '/etc/systemd/system/duoauthproxy.service',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => Sensitive(template("${module_name}/duoauthproxy.service")),
    }
    service { 'duoauthproxy':
      ensure     => running,
      enable     => true,
      hasrestart => true,
      provider   => systemd,
    }
  } else {
    service { 'duoauthproxy':
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => false, # the status on the init scrip does not return correct codes
      status     => "${duo_authproxy::install_dir}/bin/authproxyctl status",
    }
  }
}
