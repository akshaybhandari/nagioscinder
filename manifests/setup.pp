class nagioscinder::setup {
  file { '/etc/nagios/nrpe.d/nrpe_command.cfg':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['nagios-nrpe-server'],
    require => Package['nagios-nrpe-server'],
  }
  class { 'nagioscinder::setup::host':
    require => [ File['/etc/nagios/nrpe.cfg'], Package['nagios-nrpe-plugin', 'nagios-nrpe-server'] ],
  } ->
  class { 'nagioscinder::setup::services':
    service_list          => $::nagioscinder::service_list,
  } ->
  class { 'nagioscinder::setup::files': } ->
  class { 'nagioscinder::setup::commands':
    service_list          => $::nagioscinder::service_list,
  }
}
