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
}
