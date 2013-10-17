


This is an example of a serverless puppet manifest
more details at http://docs.puppetlabs.com/learning/index.html

This manifest can be used to install the packages you require to bring a AWS base AMI up to your specs. Then save the AMI and reuse.

steps to run:
 1. get some base AMI from aws marketplace. I chose a base ubuntu server Ubuntu 13.04 raring
 2. login to this new server: ssh -i ~/.ssh/<ur private key>.pem ubuntu@<machine name>
 3. install puppet e.g. sudo apt-get install puppet-common
 4. copy this folder over: scp -r -i ~/.ssh/<ur private key>.pem infra/ ubuntu@<machine name>:/tmp
 5. sudo puppet apply --modulepath=/tmp/infra/puppet/modules --verbose infra/puppet/manifests/site.pp


NOTE: Before you can use this, be sure to replace all values in CAPS accordingly e.g.

main.cf.erb
----------------
SENDGRID_USERNAME:SENDGRID_PASSWORD

nginx.conf.erb
--------------------
YOUR_DOMAIN.crt YOUR_DOMAIN.key
server_name YOUR_DOMAIN.com www.YOUR_DOMAIN.com;

passwd-s3fs.erb
---------------------
S3FS_PASSWORD

ssh.config.erb
-------------------
REMOTE_GIT_REPO_DOMAIN_NAME

This puppet manifest will install:

make
gcc
fuse (for s3fs)
nginx (with spdy support)
git
wget
python
g++
nodejs
postfix
openssl
rsync
s3fs
monit
redis
virtualenv


This gives you a good sample and starting point. Use this manifest, update/tweak it and automate your deployment !

Have fun...






