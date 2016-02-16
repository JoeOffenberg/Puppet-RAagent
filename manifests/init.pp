# == Class: raagent
#
# Full description of class raagent here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'raagent':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class raagent {
exec { 'get_raagent':
	cwd     => "/tmp",
	command => "/usr/bin/wget http://${RAServer}:8080/nolio-app/apps/nolio_agent_linux_x64_5_5_2_b191.sh",
	unless  => [ "/usr/bin/test -e nolio_agent_linux_x64_5_5_2_b191.sh" ],
     } 	
file { 'ra_install_file':
	path => "/tmp/nolio_agent_linux_x64_5_5_2_b191.sh",
	mode => 755,
	require => exec['get_raagent'], 
      } 	
	
exec { 'install_raagent':
	cwd     => "/tmp",
	command => "/tmp/nolio_agent_linux_x64_5_5_2_b191.sh -q -Vsys.installationDir=/opt/CA/RAagent -Vnolio.execution.name=${RAServer} -Vnolio.execution.port=6600 -Vnolio.nimi.port=6600 -Vnolio.nimi.secured=false",
	unless => [ "/usr/bin/test -d /opt/CA/RAagent/bin" ],
	require => file['ra_install_file'],

        }
	
# create symlink for RA Server Integration
file { ["/opt/puppet", "/opt/puppet/bin"]:
    ensure => "directory",
     }

file { '/opt/puppet/bin/puppet':
   ensure => 'link',
   target => '/usr/bin/puppet',
     }

}
