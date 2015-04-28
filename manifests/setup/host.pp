class nagioscinder::setup::host {
  @@nagios_host { $fqdn:
    ensure  => present,
    alias   => $hostname,
    address => $ipaddress,
    use     => 'generic-host',
  }
}
