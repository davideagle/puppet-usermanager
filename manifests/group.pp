define usermanager::group(
  $ensure = present,
  $gid    = undef,
  $system = false,
  

){
  ::group{ $gid:
    ensure => $ensure,
    gid    => $gid,
    system => $system,
  }
}