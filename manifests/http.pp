define lbchains::http (
  $account_name = $name,
  $ip = {},
  $source_port = $lbchains::params::http_port,
  $dest_port = $lbchains::params::http_forward_port, 
  $every = {},

) inherits lbchains::params {

    file { "http-${account_name}":
      path => '/etc/lb-chains/${account_name}-http',
      mode => "0644",
      owner => "root",
      group => "root",
    }

    file_line { "http_single_server-${account_name}":
      path => '/etc/lb-chains/${account_name}-http',
      line => '#/bin/bash',
      line => '# ${account_name}-http',
      line => 'iptables -t nat -F ${account_name}-http',
      line => 'iptables -t nat -Z ${account_name}-http',
      line => '# hostname',
      line => 'iptables -t nat -A ${account_name}-http -p tcp --dport ${source_port} -m state --state NEW -j DNAT --to-destination ${ip}:${dest_port}',
      line => '# Chain done',
      line => 'iptables -t nat -L ${account_name}-http',
      require => File[http],
    }
}
