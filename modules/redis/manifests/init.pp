
#instructions on what needs to be done to put redis in production can be found at http://redis.io/topics/quickstart
#this manifest goes by that.

class redis {

    require common

    group { 'redis':
        ensure => present,
    }

    user { 'redis':
        ensure              => 'present',
        comment             => 'redis',
        gid                 => 'redis',
        home                => '/var/empty/redis',
        password            => '*',
        password_max_age    => '-1',
        password_min_age    => '-1',
        shell               => '/sbin/nologin',
        uid                 => '508',
        require            => Group['redis'],
    }

    exec { 'download redis':
        command => '/usr/bin/wget http://redis.googlecode.com/files/redis-2.6.11.tar.gz',
        cwd     => '/tmp',
        creates => '/tmp/redis-2.6.11.tar.gz',
        require => User['redis'],
        before  => Exec['untar redis'],
    }

    exec { 'untar redis':
        command => '/bin/tar xzf redis-2.6.11.tar.gz',
        cwd     => '/tmp',
        creates => '/tmp/redis-2.6.11',
        before  => Exec['make'],
    }

    exec { 'make distclean':
        command => '/usr/bin/make distclean',
        cwd     => '/tmp/redis-2.6.11',
        require => Exec['untar redis'],
    }

    exec { 'make':
        command => '/usr/bin/make ; cp src/redis-server /usr/local/bin ; cp src/redis-cli /usr/local/bin ; cp src/redis-benchmark /usr/local/bin ; cp src/redis-check-dump /usr/local/bin',
        cwd     => '/tmp/redis-2.6.11',
        path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/root/bin',
        creates => '/usr/local/bin/redis-server',
        require => Exec['make distclean']
    }

}
