# Definition: usermanager::create_user
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

define usermanager::create_user(
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
    $_home_path = $home
  }  else {
    $_home_path = "/home/${uid}"
  }
  
  user{ $title:
    ensure     => $ensure,
    uid        => $uid,
    gid        => $uid,
    home       => $_home_path,
    comment    => $comment,
    shell      => $shell,
    groups     => $groups,
    managehome => $managehome,
    require    => Usermanager::Create_group[$title],
  }
  
  usermanager::create_group{ $title:
    gid => $uid,
  }
  
  file { $_home_path:
    ensure => directory,
    owner  => $uid,
    group  => $uid,
    mode   => '0700',
  }
  
}