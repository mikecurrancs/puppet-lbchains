define lbchains::https (
  $account_name = $name,
  $node_one = hiera($ipaddress),
  $nodeandevery = [],
  $source_port = $lbchains::params::http_port,
  $dest_port = $lbchains::params::http_forward_port, 

) inherits lbchains::params {

    file { 'https-${account_name}':
      path => '/etc/lb-chains/${account_name}-https',
      mode => "0644",
      owner => "root",
      group => "root",
    }

    file_line { 'https_single_server-${account_name}':
      path => '/etc/lb-chains/${account_name}-https',
      line => '#/bin/bash',
      line => '# ${account_name}-https',
      line => 'iptables -t nat -F ${account_name}-https',
      line => 'iptables -t nat -Z ${account_name}-https',
      line => '# hostname',
      line => 'iptables -t nat -A ${account_name}-https -p tcp --dport ${source_port} -m state --state NEW -j DNAT --to-destination ${node_one}:${dest_port}',
      line => '# Chain done',
      line => 'iptables -t nat -L ${account_name}-https',
      require => File[https],
    }

    file_line { 'https_multi_server-${account_name}':
      path => '/etc/lb-chains/${account_name}-https',
      line => '#/bin/bash',
      line => '# ${account_name}-https',
      line => 'iptables -t nat -F ${account_name}-https',
      line => 'iptables -t nat -Z ${account_name}-https',
      line => '# hostname',
      each ($nodeandevery) {
      line => 'iptables -t nat -A ${account_name}-https -p tcp -m tcp --dport ${source_port} -m state --state NEW -m statistic --mode nth --every ($nodeandevery[2]) -j DNAT --to-destination ($nodeandevery[1]):${dest_port}
      }
      line => 'iptables -t nat -A ${account_name}-https -p tcp --dport ${source_port} -m state --state NEW -j DNAT --to-destination ${node_one}:${dest_port}',
      line => '# Chain done',
      line => 'iptables -t nat -L ${account_name}-https',
      require => File[https], 
     }
}
