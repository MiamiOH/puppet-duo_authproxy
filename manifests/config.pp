# @summary Configures the Duo Authentication Proxy by setting the config file.
#
# @api private
#
class duo_authproxy::config {

  $config_file = 'authproxy.cfg'

  # Determine if settings are available in hiera and apply them
  $hiera_settings = lookup('duo_authproxy::settings', { merge => 'deep' })
  if ($hiera_settings == $duo_authproxy::settings) {
    $settings = $duo_authproxy::settings
  }

  else {
    $settings = $hiera_settings
  }

  file { $config_file:
    ensure  => file,
    path    => "${duo_authproxy::install_dir}/conf/${config_file}",
    owner   => $duo_authproxy::user,
    group   => $duo_authproxy::group,
    mode    => '0400',
    content => Sensitive(template("${module_name}/${config_file}.erb")),
  }

}
