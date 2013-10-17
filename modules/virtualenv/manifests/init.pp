
class virtualenv {

    #ensure that the resources in common are created first

    require common

    exec { 'virtualenv download':
        command =>  '/usr/bin/curl -O https://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.9.1.tar.gz',
        cwd     =>  '/tmp',
        creates =>  '/tmp/virtualenv-1.9.1.tar.gz'
    }

    exec { 'virtualenv untar':
        command =>  '/bin/tar xzf virtualenv-1.9.1.tar.gz',
        cwd     =>  '/tmp',
        creates =>  '/tmp/virtualenv-1.9.1',
        require =>  Exec['virtualenv download']
    }

}
