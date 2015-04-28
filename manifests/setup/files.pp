class nagioscinder::setup::files {
  file { "check_free_cinder_volume.sh_${hostname}":
    ensure  => present,
    path    => '/usr/lib/nagios/plugins/privileged/check_free_cinder_volume.sh',
    source  => 'puppet:///modules/nagioscinder/check_free_cinder_volume.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File["nagios_privileged_${hostname}"]
  }
}
