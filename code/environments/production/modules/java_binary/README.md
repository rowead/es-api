# puppet-java_binary

[![Puppet Forge](http://img.shields.io/puppetforge/v/deric/java_binary.svg)](https://forge.puppetlabs.com/deric/java_binary)
[![Build Status](https://travis-ci.org/deric/puppet-java.png?branch=master)](https://travis-ci.org/deric/puppet-java)


Puppet module for managing binary packages of Java with support of Java 8/9 on Debian based distribution. Unlike [the official
Java module](https://github.com/puppetlabs/puppetlabs-java) this module installs binary packages from webupd8team (only for Java 8/9 on Debian).

Usage:
```puppet
class{'java_binary':
  repository            => 'webupd8team',
  distribution          => 'oracle',
  release               => 'java8',
  accept_oracle_license => true,
}
```
