# @summary Configures the Duo Authentication Proxy by setting the config file.
#
# @api private
#
class duo_authproxy::config {

  $config_file = 'authproxy.cfg'

  # Determine if settings are available in hiera and apply them
  $hiera_settings = lookup('duo_authproxy::settings', { merge => 'deep' })
  $settings = $hiera_settings ? {
    undef   => $duo_authproxy::settings,
    default => $hiera_settings,
  }

  file { $config_file:
    ensure  => file,
    path    => "${duo_authproxy::install_dir}/conf/${config_file}",
    owner   => 'nobody',
    group   => 'root',
    mode    => '0400',
    content => Sensitive(template("${module_name}/${config_file}.erb")),
  }

}
