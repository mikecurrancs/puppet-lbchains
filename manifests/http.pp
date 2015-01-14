class lbchains::http (
  $name = $account_name,
  $ip = {},
  $source_port = $lbchains::params::http_port,
  $dest_port = $lbchains::params::http_forward_port, 
  $every = {},

) inherits lbchains::params {

    file { 'http':
      path => '/etc/lb-chains/${name}-http',
      mode => "0644",
      owner => "root",
      group => "root",
    }

    file_line { 'http_single_server':
      path => '/etc/lb-chains/${name}-http',
      line => '#/bin/bash',
      line => '# ${name}-http',
      line => 'iptables -t nat -F ${name}-http',
      line => 'iptables -t nat -Z ${name}-http',
      line => '# hostname',
      line => 'iptables -t nat -A ${name}-http -p tcp --dport ${source_port} -m state --state NEW -j DNAT --to-destination ${ip}:${dest_port}',
      line => '# Chain done',
      line => 'iptables -t nat -L ${name}-http',
      require => File[http],
    }
}
