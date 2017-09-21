# Repositories with binary Java packages
class java_binary::repo(
  $release,
  $repository = 'webupd8team',
  ) {

  case $::osfamily {
    'Debian': {
      case $repository {
        'webupd8team' :{
          case $::operatingsystem {
            'Debian': {
              $dist_name = 'trusty'
            }

            'Ubuntu': {
              $dist_name = $::lsbdistcodename
            }

            default: {
              fail "Unsupported operatingsystem ${::operatingsystem}"
            }
          }

          include apt
          apt::source { 'webupd8team-java':
            location => 'http://ppa.launchpad.net/webupd8team/java/ubuntu',
            release  => $dist_name,
            repos    => 'main',
            include  => {
              'src' => true
            },
            key      => {
              'id'     => '7B2C3B0889BF5709A105D03AC2518248EEA14886',
              'server' => 'keyserver.ubuntu.com',
            },
          }
          -> Class['apt::update']

          exec{'oracle-license':
            command =>
            "/bin/echo 'oracle-${release}-installer shared/accepted-oracle-license-v1-1 select true' | /usr/bin/debconf-set-selections",
            unless  => '/bin/echo "get shared/accepted-oracle-license-v1-1" | /usr/bin/debconf-communicate | /bin/grep "true"',
          }
        }
        default: {}
      }
    }
    default: {}
  }
}
