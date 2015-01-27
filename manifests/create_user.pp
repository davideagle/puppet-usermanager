# Definition: usermanager::create_user
#
# Manage deployment of users and groups.
#
# Parameters:
# - $uid is the userid
# - $ensure  
# - $shell
# - $groups additional groups for user that will be created if not present
# - $password hash
# - $managehome defualt is true
# - $home directory for user, default is /home/username
# - $comment for the user
# - $sshkey source file
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
    $_home_path = "/home/${username}"
  }
  
  user{ $username:
    ensure     => $ensure,
    uid        => $uid,
    gid        => $uid,
    password   => $password,
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
      source  => $sshkey,
      owner   => $uid,
      group   => $uid,
      mode    => '0600',
      require => File["${_home_path}/.ssh"]
    }
  }
  
}