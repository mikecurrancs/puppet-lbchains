class lbchains::https (
  $name = $account_name,
  $ip = {},
  $source_port = $lbchains::params::https_port,
  $dest_port = $lbchains::params::https_forward_port, 
  $every = {},

) inherits lbchains::params {

    file { 'https':
      path => '/etc/lb-chains/${name}-https',
      mode => "0644",
      owner => "root",
      group => "root",
    }

    file_line { 'https_single_server':
      path => '/etc/lb-chains/${name}-https',
      line => '#/bin/bash',
      line => '# ${name}-https',
      line => 'iptables -t nat -F ${name}-https',
      line => 'iptables -t nat -Z ${name}-https',
      line => '# hostname',
      line => 'iptables -t nat -A ${name}-https -p tcp --dport ${source_port} -m state --state NEW -j DNAT --to-destination ${ip}:${dest_port}',
      line => '# Chain done',
      line => 'iptables -t nat -L ${name}-https',
      require => File[https],
    }
}
