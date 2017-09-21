# On Debian systems, if alternatives are set, manually assign them.
class java_binary::config ( ) {
  case $::osfamily {
    'Debian': {
      if $java_binary::use_java_alternative != undef and $java_binary::use_java_alternative_path != undef {
        exec { 'update-java-alternatives':
          path    => '/usr/bin:/usr/sbin:/bin:/sbin',
          command => "update-java-alternatives --set ${java_binary::use_java_alternative} ${java_binary::jre_flag}",
          unless  => "test /etc/alternatives/java -ef '${java_binary::use_java_alternative_path}'",
        }
      }
    }
    'RedHat': {
      if $java_binary::use_java_alternative != undef and $java_binary::use_java_alternative_path != undef {
        # The standard packages install alternatives, custom packages do not
        # For the stanard packages java::params needs these added.
        if $java_binary::use_java_package_name != $java_binary::default_package_name {
          exec { 'create-java-alternatives':
            path    => '/usr/bin:/usr/sbin:/bin:/sbin',
            command => "alternatives --install /usr/bin/java java ${$java_binary::use_java_alternative_path} 20000" ,
            unless  => "alternatives --display java | grep -q ${$java_binary::use_java_alternative_path}",
            before  => Exec['update-java-alternatives']
          }
        }

        exec { 'update-java-alternatives':
          path    => '/usr/bin:/usr/sbin',
          command => "alternatives --set java ${$java_binary::use_java_alternative_path}" ,
          unless  => "test /etc/alternatives/java -ef '${java_binary::use_java_alternative_path}'",
        }
      }
    }
    default: {
      # Do nothing.
    }
  }
}
