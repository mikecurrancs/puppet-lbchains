define lbchains::voice (
  $account_name = $name,
  $base_ipaddress = undef,
  $ipaddress = heira($ipaddress),
  $port = $lbchains::params::voice_port, 
  $every = {},

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
      line => 'iptables -t nat -A ${account_name}-voice -p tcp --dport ${port} -m state --state NEW -j DNAT --to-destination ${ip}:${port}',
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
      line => 'iptables -t nat -A ${account_name}-voice -p tcp -m tcp --dport ${source_port} -m state --state NEW -m statistic --mode nth --every ($host[2]) -j DNAT --to-destination ($host[1]):${dest_port}
      }
      line => 'iptables -t nat -A ${account_name}-voice -p tcp --dport ${source_port} -m state --state NEW -j DNAT --to-destination ${ip}:${dest_port}',
      line => '# Chain done',
      line => 'iptables -t nat -L ${account_name}-voice',
      require => File[voice], 
     }
}
