# Definition: usermanager::user
#
# Manage deployment of users and groups.
#
# Parameters:
# - $ensure
# - $gid is the groupid
# - $ensure
# - $system
#
define usermanager::group(
  $ensure = present,
  $gid    = undef,
  $system = false,
  

){
  ::group{ $title:
    ensure => $ensure,
    gid    => $gid,
    system => $system,
  }
}