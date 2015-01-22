# Definition: usermanager::user
#
# Manage deployment of users and groups.
#
# Parameters:
# - $catalina_base is the base directory for the Tomcat installation
# - $app_base is the path relative to $catalina_base to deploy the WAR to.
#   Defaults to 'webapps'.
# - The $deployment_path can optionally be specified. Only one of $app_base and
#   $deployment_path can be specified.
# - $war_ensure specifies whether you are trying to add or remove the WAR.
#   Valid values are 'present', 'absent', 'true', and 'false'. Defaults to
#   'present'.
# _ Optionally specify a $war_name. Defaults to $name.
# - $war_purge is a boolean specifying whether or not to purge the exploded WAR
#   directory. Defaults to true. Only applicable when $war_ensure is 'absent'
#   or 'false'. Note: if tomcat is running and autodeploy is on, setting
#   $war_purge to false won't stop tomcat from auto-undeploying exploded WARs.
# - $war_source is the source to deploy the WAR from. Currently supports
#   http(s)://, puppet://, and ftp:// paths. $war_source must be specified
#   unless $war_ensure is set to 'false' or 'absent'.
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
  
  ::user{ $uid:
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

  
  usermanager::group { $uid:
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