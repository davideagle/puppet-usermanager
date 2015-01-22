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
  $sshkey     = undef,
){
  # Set username
  $username = $title
  
  include stdlib
  
  if $home {
    $_home_path = $home
  }  else {
    $_home_path = "/home/${uid}"
  }
  
  user{ $username:
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
  usermanager::create_group{ $username:
    ensure => $ensure,
    gid    => $uid,
    
  }
  
  # Create groups for user
  if $groups{
    ensure_resource(Usermanager::Create_group, $groups, {'ensure' => 'present'})
  }
  
  file { $_home_path:
    ensure => directory,
    owner  => $uid,
    group  => $uid,
    mode   => '0700',
  }
  
  # Manage ssh keys
  if $sshkey {
    
    # Ensure .ssh directory is present
    file { "${_home_path}/.ssh":
      ensure => directory,
      owner  => $uid,
      group  => $uid,
      mode   => '0700',
    }
    
    # Create authorized_keys file
    file { "${_home_path}/.ssh/authorized_keys":
      ensure  => present,
      content => $sshkey,
      owner   => $uid,
      group   => $uid,
      mode    => '0600',
      require => File["${_home_path}/.ssh"]
    }
  }
  
}