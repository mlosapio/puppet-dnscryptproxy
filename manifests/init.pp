# Class: dnscryptproxy 
class dnscryptproxy (
  $download_url = 'https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/2.0.44/dnscrypt-proxy-linux_x86_64-2.0.44.tar.gz',
  $install_path = '/opt',
  $server_name = '',
  $stamp = '',
){

  # hack for systemctl
  exec { 'dnscrypt-systemd-reload':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }

  file { $install_path:
    ensure => directory,
  }

  # service
  service { 'dnscryptproxy':
    ensure    => running,
    provider  => systemd,
    enable    => true,
    hasstatus => true,
    require   => File['/etc/systemd/system/dnscryptproxy.service'],
  }

  # Systemd file
  file {'/etc/systemd/system/dnscryptproxy.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    source  => 'puppet:///modules/dnscryptproxy/dnscryptproxy.service',
    require => Exec['install_dnscryptproxy'],
    notify  => [
        Exec['dnscryptproxy-systemd-reload'],
        Service['dnscryptproxy'],
    ],
  }

  # Hacky way to download the code 
  exec { "install_dnscrypt_proxy":
    command     => "/bin/curl -L -o dnscryptproxy.tgz ${download_url} && tar zxvf dnscryptproxy.tgz",
    cwd         => $install_path,
    creates     => "${install_path}/linux-x86_64",
    require     => File[$install_path]
  }

}
