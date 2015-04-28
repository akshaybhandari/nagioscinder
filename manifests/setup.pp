class nagioscinder::setup {
  class { 'nagioscinder::setup::services':
    service_list          => $::nagioscinder::service_list,
  } ->
  class { 'nagioscinder::setup::files': } ->
  class { 'nagioscinder::setup::commands':
    service_list          => $::nagioscinder::service_list,
  }
}
