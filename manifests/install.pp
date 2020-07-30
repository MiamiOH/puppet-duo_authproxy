# @summary Installs and/or compiles the Duo Authentication Proxy package
#
# @api private
#
class duo_authproxy::install {

  if ($duo_authproxy::manage_compile_package_dependencies) {
    ensure_packages($duo_authproxy::compile_package_dependencies)
  }

  if ($duo_authproxy::compile_package) {

    $inst_cmd = "duoauthproxy-build/install --install-dir ${duo_authproxy::install_dir} --service-user duo_authproxy_svc --log-group duo_authproxy_grp --create-init-script yes"
    $creates_path = "${duo_authproxy::install_dir}/${duo_authproxy::version}"

    archive { "/tmp/duoauthproxy-${duo_authproxy::version}-src.tgz":
      source       => "https://dl.duosecurity.com/duoauthproxy-${duo_authproxy::version}-src.tgz",
      extract      => true,
      extract_path => '/tmp',
      cleanup      => true,
      creates      => $creates_path,
      proxy_server => $duo_authproxy::proxy_server,
      proxy_type   => $duo_authproxy::proxy_type,
    }

    -> exec { 'duoauthproxy-move':
      command => "mv duoauthproxy-${duo_authproxy::version}*-src duoauthproxy-${duo_authproxy::version}-src",
      cwd     => '/tmp',
      path    => '/bin',
      creates => $creates_path,
    }

    -> exec { 'duoauthproxy-make':
      command     => 'make > duoauthproxy-make.log',
      cwd         => "/tmp/duoauthproxy-${duo_authproxy::version}-src",
      environment => ['PYTHON=python'],
      path        => $facts['path'],
      creates     => $creates_path,
      require     => Package[$duo_authproxy::dep_packages],
    }

    -> exec { 'duoauthproxy-install':
      command     => "/tmp/duoauthproxy-${duo_authproxy::version}-src/${inst_cmd} > duoauthproxy-install.log",
      cwd         => "/tmp/duoauthproxy-${duo_authproxy::version}-src",
      environment => ['PYTHON=python'],
      path        => $facts['path'],
      creates     => $creates_path,
    }

    -> exec { 'duoauthproxy-tag':
      command => "touch ${creates_path}",
      path    => $facts['path'],
      creates => $creates_path,
    }

  }

}
