class lbchains::https (
  $account_name = $name,
  $ip = {},
  $source_port = $lbchains::params::https_port,
  $dest_port = $lbchains::params::https_forward_port, 
  $every = {},

) inherits lbchains::params {

    file { 'https':
      path => '/etc/lb-chains/${account_name}-https',
      mode => "0644",
      owner => "root",
      group => "root",
    }

    file_line { 'https_single_server':
      path => '/etc/lb-chains/${account_name}-https',
      line => '#/bin/bash',
      line => '# ${account_name}-https',
      line => 'iptables -t nat -F ${account_name}-https',
      line => 'iptables -t nat -Z ${account_name}-https',
      line => '# hostname',
      line => 'iptables -t nat -A ${account_name}-https -p tcp --dport ${source_port} -m state --state NEW -j DNAT --to-destination ${ip}:${dest_port}',
      line => '# Chain done',
      line => 'iptables -t nat -L ${account_name}-https',
      require => File[https],
    }
}
