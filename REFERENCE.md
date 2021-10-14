# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

#### Public Classes

* [`duo_authproxy`](#duo_authproxy): Installs and configures Duo Authentication Proxy

#### Private Classes

* `duo_authproxy::config`: Configures the Duo Authentication Proxy by setting the config file.
* `duo_authproxy::install`: Installs and/or compiles the Duo Authentication Proxy package
* `duo_authproxy::service`: Manages the service of the Duo Authentication Proxy.

## Classes

### <a name="duo_authproxy"></a>`duo_authproxy`

Installs and configures Duo Authentication Proxy

#### Examples

##### including the module in a profile

```puppet
include duo_authproxy
```

##### in hiera

```puppet
duo_authproxy::version: '4.0.2'
duo_authproxy::install_dir: '/opt/duoauthproxy'
duo_authproxy::settings:
  main:
    debug: true
    http_proxy_host: 'my.proxy.example.com'
    http_proxy_port: 80
  ad_client:
    host: 'host.ad.example.com'
    service_account_username: 'service-account'
    service_account_password: 'password'
    search_dn: 'cn=users,dc=ad,dc=example,dc=com'
  ldap_server_auto:
    ikey: 'ikey'
    skey: 'encrypt-with-eyaml'
    api_host: 'api_host'
```

##### resource-like class declaration with parameters

```puppet
class { 'duo_authproxy':
  version     => '4.0.2',
  install_dir => '/opt/duoauthproxy'
  settings    => {
    # All required config sections and settings
    'main' => {
      'debug' => 'true',
    },
     'ad_client' => {
       'host'                     => 'host.ad.example.com',
       'service_account_username' => 'service-account',
       'service_account_password' => 'password',
       'search_dn'                => 'cn=users,dc=ad,dc=example,dc=com',
    },
  },
}
```

##### Some users have experienced longer compilation times when `compile_package => true`.

```puppet
# Timeout can be extended by setting the `compile_package_timeout` value.
duoauthproxy::compile_package_timeout: 800
```

#### Parameters

The following parameters are available in the `duo_authproxy` class:

* [`version`](#version)
* [`install_dir`](#install_dir)
* [`settings`](#settings)
* [`user`](#user)
* [`group`](#group)
* [`proxy_server`](#proxy_server)
* [`proxy_type`](#proxy_type)
* [`compile_package`](#compile_package)
* [`compile_package_timeout`](#compile_package_timeout)
* [`package_dependencies`](#package_dependencies)
* [`manage_package_dependencies`](#manage_package_dependencies)
* [`manage_python`](#manage_python)
* [`python_package`](#python_package)
* [`python_package_ensure`](#python_package_ensure)

##### <a name="version"></a>`version`

Data type: `String`

The version of Duo Authentication Proxy to install and configure.

##### <a name="install_dir"></a>`install_dir`

Data type: `Stdlib::Absolutepath`

The location on the filesystem where Duo Authentication Proxy will be installed.

##### <a name="settings"></a>`settings`

Data type: `Hash`

A hash containing the settings that will be saved in `authproxy.cfg`.  Supports hiera with deep merging.

##### <a name="user"></a>`user`

The user that owns the files and directories

##### <a name="group"></a>`group`

The group that owns the files and directories

##### <a name="proxy_server"></a>`proxy_server`

Data type: `Optional[String]`

The URL of the proxy, if needed, to download the source code.

##### <a name="proxy_type"></a>`proxy_type`

Data type: `Optional[Enum['none', 'ftp', 'http', 'https']]`

If using an internal proxy for downloading the source code, the type can be speicified here.

##### <a name="compile_package"></a>`compile_package`

Data type: `Boolean`

Whether or not to compile the package source.  If set to false, the package will not be
compiled from source, and it will need to be installed by other means.

##### <a name="compile_package_timeout"></a>`compile_package_timeout`

Data type: `Integer`

Increases the timeout value of the `exec` statement to compile the source package.  Useful when
Puppet times out during the intial run of this module.

##### <a name="package_dependencies"></a>`package_dependencies`

Data type: `Array[String]`

An array of packages that are required to compile Duo Authentication Proxy from source.
See https://duo.com/docs/authproxy-reference#installation for a complete list of packages.

##### <a name="manage_package_dependencies"></a>`manage_package_dependencies`

Data type: `Boolean`

Whether or not to manage the packages required to compile the Duo Authentication Proxy source.

##### <a name="manage_python"></a>`manage_python`

Data type: `Boolean`

Whether or not to manage the `python` and `python-devel` packages.

##### <a name="python_package"></a>`python_package`

Data type: `String`

The name of the python package.  This can be set if `manage_python => true` and the host is
using a versioned or otherwise non-standard python package name.

##### <a name="python_package_ensure"></a>`python_package_ensure`

Data type: `Enum['present', 'latest', 'absent']`

Ensure value for the `python` and `python-devel` packages.
