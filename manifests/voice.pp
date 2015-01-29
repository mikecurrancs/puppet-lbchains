define lbchains::voice (
  $account_name = $name,
  $node_one = hiera($ipaddress),
  $nodeandevery = [],
  $source_port = $lbchains::params::http_port,
  $dest_port = $lbchains::params::http_forward_port, 

) inherits lbchains::params {

    file { 'voice-${account_name}':
      path => '/etc/lb-chains/${account_name}-voice',
      mode => "0644",
      owner => "root",
      group => "root",
    }

    file_line { 'voice_single_server-${account_name}':
      path => '/etc/lb-chains/${account_name}-voice',
      line => '#/bin/bash',
      line => '# ${account_name}-voice',
      line => 'iptables -t nat -F ${account_name}-voice',
      line => 'iptables -t nat -Z ${account_name}-voice',
      line => '# hostname',
      line => 'iptables -t nat -A ${account_name}-voice -p tcp --dport ${port} -m state --state NEW -j DNAT --to-destination ${nodeandevery}:${port}',
      line => '# Chain done',
      line => 'iptables -t nat -L ${account_name}-voice',
      require => File[voice],
    }

    file_line { 'voice_multi_server-${account_name}':
      path => '/etc/lb-chains/${account_name}-voice',
      line => '#/bin/bash',
      line => '# ${account_name}-voice',
      line => 'iptables -t nat -F ${account_name}-voice',
      line => 'iptables -t nat -Z ${account_name}-voice',
      line => '# hostname',
      each ($nodeandevery) {
      line => 'iptables -t nat -A ${account_name}-voice -p tcp -m tcp --dport ${source_port} -m state --state NEW -m statistic --mode nth --every ($nodeandevery[2]) -j DNAT --to-destination ($nodeandevery[1]):${dest_port}
      }
      line => 'iptables -t nat -A ${account_name}-voice -p tcp --dport ${source_port} -m state --state NEW -j DNAT --to-destination ${node_one}:${dest_port}',
      line => '# Chain done',
      line => 'iptables -t nat -L ${account_name}-voice',
      require => File[voice], 
     }
}
