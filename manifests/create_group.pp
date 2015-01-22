# Definition: usermanager::create_group
#
# Manage deployment of users and groups.
#
# Parameters:
# - $ensure
# - $gid is the groupid
# - $ensure
# - $system
#
define usermanager::create_group(
  $ensure = present,
  $gid    = undef,
  $system = false,
  

){
  group{ $title:
    ensure => $ensure,
    gid    => $gid,
    system => $system,
  }
}