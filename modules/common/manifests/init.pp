
#we assume that the box has *at least* puppet instaleld and a set of public/private keys
#we also assume that the public key has been added to where your src code is hosted telling them that this is a legit client

class common {

    $config_file = '/etc/postfix/main.cf'
    $s3fs_config_file = '/etc/passwd-s3fs'
    $nginx_config_file = '/usr/local/nginx/conf/nginx.conf'

    package { 'make':
        ensure => present,
    }

    package { 'gcc':
        ensure => present,
    }

    package { 'mailutils':
        ensure => present,
    }

    package { 'pkg-config':
        ensure => present,
    }

    package { 'fuse':
        ensure => present,
    }

    package { 'libxml2-dev':
        ensure => present,
    }

    package { 'libxslt-dev':
        ensure => present,
    }

    package { 'libssl-dev':
        ensure => present,
    }

    package { 'libpcre3':
        ensure => present,
    }

    package { 'libpcre3-dev':
        ensure => present,
    }

    package { 'libcurl4-openssl-dev':
        ensure => present,
    }

    package { 'libfuse-dev':
        ensure => present,
    }

    group { 'jdoe':
        ensure => present,
    }

    file { '/etc/nginx':
        ensure  => absent,
        recurse => true,
        force => true,
        require => Package['libfuse-dev'],
    }

    package {'libshadow-ruby1.8':
        ensure      => installed,
        require     => Group['jdoe'],
    }

    user { 'jdoe':
      ensure           => 'present',
      comment          => 'jdoe',
      gid              => '1001',
      home             => '/home/jdoe',
      #jdoe is the password
      password         => '$6$eZ6wbRWJ$8EdlEELtEJaEU.rWYrGj/p3D0yHmhU.1XWXC7J28.RWjElsuGN9co/iWI8YEjFSV0IJ5yF8vDKRZxexyksOH91',
      password_max_age => '99999',
      password_min_age => '0',
      shell            => '/bin/bash',
      uid              => '507',
    }

    package { 'git':
        ensure => present,
    }

    package { 'wget':
        ensure => latest,
    }

    package { 'nginx':
        ensure => absent,
    }

    package { 'python-software-properties':
        ensure => present,
    }

    package { 'python':
        ensure => present,
    }

    package { 'g++':
        ensure => present,
    }

    #Amateur Packet Radio Node Program on ubuntu
    package { 'node':
        ensure => absent,
    }

    exec { 'add-apt-repository':
        command => '/usr/bin/add-apt-repository --yes ppa:chris-lea/node.js',
        cwd     => '/tmp',
        before  => Package['g++'],
    }

    exec { 'apt-update':
        command     => '/usr/bin/apt-get update',
        refreshonly => true,
        require => Package['g++'],
    }

    ### Your version may be different. Look for "Version:" in /var/lib/apt/lists/ppa.launchpad.net_chris-lea_node.js_[...]_Packages (ellipsised part of path varies with setup)
    exec { '0.10.20-1chl1~raring1':
        command     => '/usr/bin/apt-get -y install nodejs=0.10.20-1chl1~raring1',
        require => Exec['apt-update']
    }

    exec { 'node symbolic link':
        command => '/bin/ln -s /usr/bin/nodejs /usr/bin/node',
        creates =>  '/usr/bin/node',
        require => Exec['0.10.20-1chl1~raring1'],
    }

    exec { 'node-gyp':
        command => '/usr/bin/npm install -g node-gyp',
        cwd     =>  '/home/jdoe/jdoe/web',
        require => Exec['node symbolic link'],
    }

    file { '/home/jdoe/.ssh':
        ensure  => 'directory',
        owner   => 'jdoe',
        group   => 'jdoe',
        mode    => 0600,
        require => User['jdoe'],
    }

    file { '/home/jdoe/.ssh/config':
        ensure  =>  'present',
        owner   =>  'jdoe',
        group   =>  'jdoe',
        mode    =>  '0700',
        content =>  template('common/ssh.config.erb'),
        require =>  File['/home/jdoe/.ssh'],
    }

    #if being done for the first time
    exec { 'git clone':
        command =>  '/usr/bin/git clone git@my_awesome_project.unfuddle.com:my_awesome_project/my_awesome_project.git',
        cwd     =>  '/home/jdoe',
        creates =>  '/home/jdoe/my_awesome_project',
        group   =>  'jdoe',
        user    =>  'jdoe',
        require => File['/home/jdoe/.ssh/config'],
    }

    #get the latest, if it is already there
    exec { 'git pull':
        command =>  '/usr/bin/git pull origin master',
        cwd     =>  '/home/jdoe/my_awesome_project',
        group   =>  'jdoe',
        user    =>  'jdoe',
        require =>  Exec['git clone'],
    }

    exec { 'npm install bcrypt':
        environment => ["HOME=/home/jdoe/"],
        command =>  '/usr/bin/npm install -y bcrypt',
        cwd     =>  '/home/jdoe/my_awesome_project/web',
        group   =>  'jdoe',
        user    =>  'jdoe',
        require =>  Exec['node-gyp'],
    }

    file { '/home/jdoe/my_awesome_project/var':
        ensure  => 'directory',
        owner   => 'jdoe',
        group   => 'jdoe',
        mode    => 0755,
        require => Exec['git pull'],
    }

    file { '/home/jdoe/my_awesome_project/var/run':
        ensure  => 'directory',
        owner   => 'jdoe',
        group   => 'jdoe',
        mode    => 0755,
        require => Exec['git pull'],
    }

    file { '/home/jdoe/my_awesome_project/var/run/supervisor':
        ensure  => 'directory',
        owner   => 'jdoe',
        group   => 'jdoe',
        mode    => 0755,
        require => Exec['git pull'],
    }

    file { '/home/jdoe/my_awesome_project/var/run/redis':
        ensure  => 'directory',
        owner   => 'jdoe',
        group   => 'jdoe',
        mode    => 0755,
        require => Exec['git pull'],
    }

    file { '/home/jdoe/my_awesome_project/var/log':
        ensure  => 'directory',
        owner   => 'jdoe',
        group   => 'jdoe',
        mode    => 0755,
        require => Exec['git pull'],
    }

    file { '/var/cache':
        ensure  => 'directory',
    }



    package { 'postfix':
        ensure => present,
    }

    file { $config_file:
        ensure  => present,
        content => template('common/main.cf.erb'),
        require => Package['postfix'],
    }

    package { 'openssl':
        ensure => present,
    }

    package { 'rsync':
        ensure => present,
    }


    exec { 'download s3fs':
        command => '/usr/bin/wget http://s3fs.googlecode.com/files/s3fs-1.73.tar.gz',
        cwd     => '/tmp',
        creates => '/tmp/s3fs-1.73.tar.gz',
    }

    exec { 'untar s3fs':
        command => '/bin/tar xzf s3fs-1.73.tar.gz',
        cwd     => '/tmp',
        creates => '/tmp/s3fs-1.73',
        require => Exec['download s3fs'],
    }

    exec { 'configure s3fs':
        command => '/tmp/s3fs-1.73/configure',
        cwd     => '/tmp/s3fs-1.73',
        require => Exec['untar s3fs']
    }

    exec { 'make s3fs':
        command => '/usr/bin/make',
        cwd     => '/tmp/s3fs-1.73',
        require => Exec['configure s3fs'],
    }

    exec { 'make install s3fs':
        command => '/usr/bin/make install',
        cwd     => '/tmp/s3fs-1.73',
        require => Exec['make s3fs'],
    }

    file { $s3fs_config_file:
        ensure  => present,
        content => template('common/passwd-s3fs.erb'),
        mode    => 0600,
    }

    file { '/mnt/backups':
        ensure  => 'directory',
    }

    exec { 'wget nginx':
        command => '/usr/bin/wget http://nginx.org/download/nginx-1.4.3.tar.gz',
        cwd     => '/tmp',
        creates =>  '/tmp/nginx-1.4.3.tar.gz',
        require => File['/mnt/backups'],
    }

    exec { 'tar xvzf':
        command => '/bin/tar -xvzf nginx-1.4.3.tar.gz',
        cwd     => '/tmp',
        creates =>  '/tmp/nginx-1.4.3',
        require => Exec['wget nginx'],
    }

    exec { 'configure nginx':
        command => '/tmp/nginx-1.4.3/configure --with-http_ssl_module --with-http_spdy_module',
        cwd     => '/tmp/nginx-1.4.3',
        creates =>  '/tmp/nginx-1.4.3/Makefile',
        require => Exec['tar xvzf'],
    }

    exec { 'make nginx':
        command => '/usr/bin/make',
        cwd     => '/tmp/nginx-1.4.3',
        require => Exec['configure nginx'],
    }

    exec { 'make install nginx':
        command => '/usr/bin/make install',
        cwd     => '/tmp/nginx-1.4.3',
        creates =>  '/usr/local/nginx/sbin/nginx',
        require => Exec['make nginx'],
    }

    file { $nginx_config_file:
        ensure  => present,
        content => template('common/nginx.conf.erb'),
        mode    => 0600,
        require => Exec['make install nginx'],
    }

}
