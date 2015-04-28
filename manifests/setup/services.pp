class nagioscinder::setup::services (
  $service_list = ['openvswitch-switch', 'nova-compute', 'libvirt-bin'],
) {
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
