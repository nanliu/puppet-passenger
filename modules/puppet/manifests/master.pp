class puppet::master(
  $passenger_version = hiera('passenger_version')
){

  include apache
  include passenger

  Class['passenger'] -> Class['setup-puppet']

  package { ['puppet', 'puppet-server']:
    ensure => latest,
  }

  # Disable the service since we want httpd to serve puppet
  service { 'puppetmaster':
    ensure    => stopped,
    enable    => false,
    hasstatus => true,
    require   => Package['puppet-server'],
  }

  # Can't use resource defaults because of include class.
  file { '/etc/puppet/rack':
    ensure => directory,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0755',
    require => Package['puppet'],
  }

  file { '/etc/puppet/rack/public':
    ensure => directory,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0755',
    require => Package['puppet'],
  }

  file { '/etc/puppet/rack/tmp/':
    ensure => directory,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0755',
    require => Package['puppet'],
  }

  file { '/etc/puppet/rack/config.ru':
    source => '/usr/share/puppet/ext/rack/files/config.ru',
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0644',
    require => Package['puppet'],
    notify  => Service['httpd'],
  }

}
