# duo_authproxy::install
#
# Private class that installs the auth proxy
#
# @summary install the proxy
#
# @example
#   don't use this class directly
class duo_authproxy::install {

  ensure_packages($duo_authproxy::dep_packages)

  $inst_cmd = "duoauthproxy-build/install --install-dir ${duo_authproxy::install_dir} --service-user duo_authproxy_svc --log-group duo_authproxy_grp --create-init-script yes"
  $creates_path = "${duo_authproxy::install_dir}/${duo_authproxy::version}"

  archive { "${duo_authproxy::download_loc}/duoauthproxy-${duo_authproxy::version}-src.tgz":
    source       => "${duo_authproxy::mirror_url}/duoauthproxy-${duo_authproxy::version}-src.tgz",
    extract      => true,
    extract_path => $duo_authproxy::download_loc,
    cleanup      => true,
    creates      => $creates_path,
    proxy_server => $duo_authproxy::proxy_server,
    proxy_type   => $duo_authproxy::proxy_type,
  }

  -> exec { 'duoauthproxy-move':
    command => "mv duoauthproxy-${duo_authproxy::version}*-src duoauthproxy-${duo_authproxy::version}-src",
    cwd     => $duo_authproxy::download_loc,
    path    => '/bin',
    creates => $creates_path,
  }

  -> exec { 'duoauthproxy-make':
    command     => 'make > duoauthproxy-make.log',
    cwd         => "${duo_authproxy::download_loc}/duoauthproxy-${duo_authproxy::version}-src",
    environment => ['PYTHON=python'],
    path        => $facts['path'],
    creates     => $creates_path,
    require     => Package[$duo_authproxy::dep_packages],
    timeout     => 3600,
  }

  -> exec { 'duoauthproxy-install':
    command     => "${duo_authproxy::download_loc}/duoauthproxy-${duo_authproxy::version}-src/${inst_cmd} > duoauthproxy-install.log",
    cwd         => "${duo_authproxy::download_loc}/duoauthproxy-${duo_authproxy::version}-src",
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
