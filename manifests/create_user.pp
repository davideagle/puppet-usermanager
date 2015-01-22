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
  
  include stdlib
  
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
  }
  
  # Create default user group
  usermanager::create_group{ $title:
    ensure => $ensure,
    gid    => $uid,
    
  }
  
  # Create groups for user
  if $groups{
    # Check if group has been 
    #if ! defined_with_params(Usermanager::Create_group[$groups], {'ensure' => 'present'}){
    #  usermanager::create_group{$groups:
    #    ensure => present,
    #  }
    #}
    ensure_resource(Usermanager::Create_group, $groups, {'ensure' => 'present'})
  }
  
  file { $_home_path:
    ensure => directory,
    owner  => $uid,
    group  => $uid,
    mode   => '0700',
  }
  
}