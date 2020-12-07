# Class: dnscryptproxy 
class dnscryptproxy (
  $download_url = 'https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/2.0.44/dnscrypt-proxy-linux_x86_64-2.0.44.tar.gz',
  $install_path = '/opt',
){

  file { $install_path:
    ensure => directory,
  }

  # Hacky way to download the code 
  exec { "install_dnscrypt_proxy":
    command     => "/bin/curl -L -o dnscryptproxy.tgz ${download_url} && tar zxvf dnscryptproxy.tgz",
    cwd         => $install_path,
    creates     => "${install_path}/linux-x86_64",
    require     => File[$install_path]
  }

}
