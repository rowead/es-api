#!/bin/bash
if [[ ! -d /usr/local/wam-puppet/locks ]]; then
  mkdir -p /usr/local/wam-puppet/locks
fi

if [[ ! -f /usr/local/wam-puppet/locks/proxy-settings-update ]]; then
  if [[ -f /etc/puppet/shell/proxy-conf ]]; then
    if [[ ! -n "${http_proxy}" ]]; then
      echo 'Updating Proxy settings for WAM networks'
      cat /etc/puppet/shell/proxy-conf >> /etc/environment
      for line in $( cat /etc/puppet/shell/proxy-conf ) ; do export $line ; done

      #change following to /etc/apt/apt.conf.d/
      cat /etc/puppet/shell/apt-proxy-conf >> /etc/apt/apt.conf
      echo 'Finished Updating Proxy settings for WAM networks'
    fi

    touch /usr/local/wam-puppet/locks/proxy-settings-update
  fi
fi

if [[ ! -f /usr/local/wam-puppet/locks/ubuntu-required-packages ]]; then
  echo 'Updating Ubuntu packages'
  #apt-get update && apt-get upgrade -yq >/dev/null
  echo 'Finished Updating Ubuntu packages'
  echo 'Installing basic packages'
  apt-get install -y libcurl3 libcurl4-gnutls-dev git-core >/dev/null
  echo 'Finished installing basic packages'

  touch /usr/local/wam-puppet/locks/ubuntu-required-packages
fi

if [[ ! -f /usr/local/wam-puppet/locks/update-puppet ]]; then
  echo "Downloading https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb"
  mkdir -p /usr/local/wam-puppet/deb
  wget --quiet --tries=5 --timeout=10 https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb -O /usr/local/wam-puppet/deb/puppetlabs-release-pc1-trusty.deb
  echo "Finished downloading https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb"

  dpkg -i /usr/local/wam-puppet/deb/puppetlabs-release-pc1-trusty.deb >/dev/null

  echo "Running update-puppet apt-get update"
  apt-get update && apt-get upgrade -yq >/dev/null
  echo "Finished running update-puppet apt-get update"

  echo "Updating Puppet to latest version"
  apt-get -y install puppet-agent >/dev/null
  echo "Sym-linking puppet executables into /usr/local/bin"
  ln -s /opt/puppetlabs/bin/puppet /usr/local/bin/puppet
  ln -s /opt/puppetlabs/bin/hiera /usr/local/bin/hiera
  ln -s /opt/puppetlabs/bin/facter /usr/local/bin/facter
  ln -s /opt/puppetlabs/bin/mco /usr/local/bin/mco
  PUPPET_VERSION=$(puppet help | grep 'Puppet v')
  echo "Finished updating puppet to latest version: $PUPPET_VERSION"

  touch /usr/local/wam-puppet/locks/update-puppet
  echo "Created empty file /usr/local/wam_puppet/update-puppet"
fi

#echo "Running puppet apply"
puppet apply /etc/puppetlabs/code/environments/production/manifests/sites.pp