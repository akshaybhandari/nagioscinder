class nagioscinder::setup::services (
  $service_list = ['openvswitch-switch', 'nova-compute', 'libvirt-bin'],
) {
  #Basic checks
  @@nagios_service { "check_users_${hostname}":
    check_command       => "check_nrpe_1arg!check_users",
    use                 => "generic-service",
    host_name           => "$fqdn",
    service_description => 'Users',
  }
  @@nagios_service { "check_memory_${hostname}":
    check_command       => "check_nrpe_1arg!check_memory",
    use                 => "generic-service",
    host_name           => "$fqdn",
    service_description => 'Memory',
  }
  @@nagios_service { "check_load_${hostname}":
    check_command       => "check_nrpe_1arg!check_load",
    use                 => "generic-service",
    host_name           => "$fqdn",
    service_description => 'load',
  }
  @@nagios_service { "check_all_disks_${hostname}":
    check_command       => "check_nrpe_1arg!check_all_disks",
    use                 => "generic-service",
    host_name           => "$fqdn",
    service_description => 'Disk',
  }

  #OpenStack related checks
  each($service_list) |$service| {
    @@nagios_service { "check_service_${service}_${hostname}":
      check_command       => "check_nrpe_1arg!check_service_${service}",
      use                 => "generic-service",
      host_name           => "$fqdn",
      service_description => "check_service_${service}",
    }
  }
  @@nagios_service { "check_free_cinder_volume_${hostname}":
    check_command       => "check_nrpe_1arg!check_free_cinder_volume",
    use                 => "generic-service",
    host_name           => "$fqdn",
    service_description => "Free_Cinder_Volume",
  }
}
