# duo_authproxy

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with duo_authproxy](#setup)
    * [What duo_authproxy affects](#what-duo_authproxy-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with duo_authproxy](#beginning-with-duo_authproxy)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

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
  settings => {
    # All required config sections and settings
    'main' => {
      'setting1' => 'value1',
    },
  },
}
```

## Usage

### Configure with hiera yaml

```puppet
include duo_authproxy
```
```yaml
---
duo_authproxy::version: 5.4.1
duo_authproxy::install_dir: /opt/duoauthproxy

duo_authproxy::settings:
  main:
    debug: true
    http_proxy_host: my.proxy.com
    http_proxy_port: 80
  ad_client:
    host: some.host.com
    service_account_username: testing
    service_account_password: secret
    search_dn: something
  ldap_server_auto:
    ikey: ikey
    skey: skey
    api_host: api_host
duo_authproxy::proxy_server: http://my.proxy.com:80
```

## Limitations

See [metadata.json](metadata.json) for supported platforms.

## Development

* Pull Requests welcome
* Include spec tests
* All tests need to pass

### Authors
Original code by Chris Edester.  Forked from https://github.com/MiamiOH.
Updated version by [Jimmy McNatt](https://github.com/jmcnatt).
