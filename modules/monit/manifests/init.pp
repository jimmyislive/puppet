

class monit {

    require common

    $config_file = '/etc/monit/monitrc'

    package { 'monit':
        ensure => present,
    }

    file { $config_file:
        ensure  => present,
        mode    => 0700,
        content => template('monit/monitrc.erb'),
        require => Package['monit'],
    }

}
