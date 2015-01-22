# Definition: usermanager::user
#
# Manage deployment of users and groups.
#
# Parameters:
# - $uid is the userid
# - $ensure 
# - $shell
# - $groups
# - $password
# - $managehome
# - $home
# - $comment
#

define usermanager::user(
  $uid        = undef,  
  $ensure     = 'present', 
  $shell      = '/bin/bash', 
  $groups     = undef, 
  $password   = undef, 
  $managehome = true,
  $home       = undef,
  $comment    = undef,
){
  
  if $home {
    $_home = $home
  }  else {
    $_home = "/home/${uid}"
  }
  
  ::user{ $title:
    ensure => $ensure,
    uid    => $uid,
    gid    => $uid,
    home   => $_home,
    comment => $comment,
    shell   => $shell,
    groups  => $groups,
    managehome => $managehome,
    require    => Group[$uid],
  }

  
  usermanager::group { $title:
    ensure => $ensure,
    gid    => $uid,
  }
  
  file { $_home:
    ensure => directory,
    owner  => $uid,
    group  => $uid,
    mode   => '0700',
  }
  
}