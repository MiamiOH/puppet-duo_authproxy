# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Param `compile_package` to optionally disable package compilation.
- Param `compile_package_timeout` to specifically how long Puppet should wait for the make `exec` operation.
- Param `manage_package_dependencies` to optionally disable managing dependency packages required to compile Duo Authentication Proxy from source.
- Added support to install `python` and `python-devel`, which are required to run Duo Authentication Proxy.  It is recommend to use [puppet-python](https://forge.puppet.com/puppet/python) from Vox Pupuli to manage `python` and `python-devel`.
### Fixed
- Removed `python_version` fact check due to the fact needing to be present before catalog run. If `Package['python']` was not present before including this module, the module init would fail.
### Changed
- Moved init params into module hiera and restructued `osfamily` specific values.
- Renamed param `dep_packages` to `package_dependencies`.
- Removed module dependecy on [puppet-python](https://forge.puppet.com/puppet/python).

## [v1.0.0]
- Initial release.

[unreleased]: https://github.com/jmcnatt/jmcnatt-duo_authproxy/compare/v0.1.1...HEAD
[v1.0.0]: https://github.com/jmcnatt/jmcnatt-duo_authproxy/releases/tag/v1.0.0