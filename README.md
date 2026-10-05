# duo_authproxy

## Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with duo_authproxy](#setup)
    * [What duo_authproxy affects](#what-duo_authproxy-affects)
    * [Beginning with duo_authproxy](#beginning-with-duo_authproxy)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

Puppet Module to install/configure [Duo Authentication Proxy](https://duo.com/docs/authproxy_reference)

## Setup

### What duo_authproxy affects

* source code download/install
* config file
* service

### Beginning with duo_authproxy

Minimal duo_authproxy setup:

```puppet
class { 'duo_authproxy':
  settings  => {
    # All required config sections and settings
    'ad_client' => {
      'transport'           => 'ldaps',
      'ssl_ca_certs_file'   => 'ca-bundle.crt',
      'ssl_verify_hostname' => true,
    },
    'ldap_server_auto' => {
        'client'              => 'ad_client',
        'ssl_key_path'        => "${facts['fqdn']}.key",
        'ssl_cert_path'       => "${facts['fqdn']}.crt",
        'minimum_tls_version' => 'tls1.2',
    },
  },
}
contain 'duo_authproxy'
```

## Usage

### Configure with hiera yaml

```puppet
include duo_authproxy

```

```yaml
---
duo_authproxy::version: 6.5.2
duo_authproxy::build_dir: /tmp
duo_authproxy::extract_dir: /tmp
duo_authproxy::install_dir: /opt/duoauthproxy
duo_authproxy::install_proto: https
duo_authproxy::install_src: dl.duosecurity.com
duo_authproxy::use_systemd: false
duo_authproxy::settings:
  ad_client:
    transport: ldaps
    ssl_ca_certs_file: ca-bundle.crt
    ssl_verify_hostname: true
  ldap_server_auto:
    client: ad_client
    ssl_key_path: "%{facts.fqdn}.key"
    ssl_cert_path: "%{facts.fqdn}.crt"
    minimum_tls_version: tls1.2
```

## Reference

### Classes

* duo_authproxy

#### Parameters

##### `dep_packages`

  Array list of packages to install prior to build

##### `version`

  Version of duoauthproxy to install (default: 6.5.2)

##### `python_env`

  Executable for python

##### `use_systemd`

  Use systemd (default: false)

##### `build_dir`

  Absolute path to source directory

##### `extract_dir`

  Absolute path for extracted source files

##### `install_dir`

  Absolute path for installed binaries

##### `install_src`

  Site from which to download source code (default: dl.duosecurity.com)

##### `install_proto`

  Protocol to use for download (default: https)

##### `settings`

  Hash of values for main config

##### `proxy_server`

  Address of proxy server (if needed)

##### `proxy_type`

  Type of proxy (none|http|https|ftp) (defaults to none if proxy_server is undef, otherwise defaults to $duo_authproxy::install_proto)

##### `exec_timeout`

  Timeout for exec resources (defaults to undef)

##### `checksum`

  REQUIRED: [sha-256 checksum](https://duo.com/docs/checksums#duo-authentication-proxy) of downloaded tgz file

##### `service_user`

  Service will run as specific user (default: duo_authproxy_svc)

##### `log_group`

  Syslog group for logging (default: duo_authproxy_grp)

##### `init_script`

  Whether to install systemd scripts (default: true)

##### `selinux`

  Whether to install the Authentication Proxy SELinux module (default: true)

## Limitations

Only tested on Supported puppet versions; RedHat and Debian flavors

## Development

* Pull Requests welcome
* Include spec tests
* All tests need to pass
