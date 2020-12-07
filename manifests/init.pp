# Class: dnscryptproxy 
class dnscryptproxyi (
  $download_url = 'dnscrypt-proxy-linux_x86_64-2.0.44.tar.gz',
  $install_path = '/opt',
){

  file { $install_path:
    ensure => directory,
  }

  # Hacky way to download the code 
  exec { "install_dnscrypt_proxy":
    command     => "/bin/curl -o dnscryptproxy.tgz ${download_url} && tar zxvf dnscryptproxy.tgz",
    cwd         => $install_path,
    creates     => "${install_path}/linux-x86_64",
    require     => File[$install_path]
  }

}
