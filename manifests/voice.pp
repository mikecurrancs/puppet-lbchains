class lbchains::voice (
  $account_name = $name,
  $ip = {},
  $port = $lbchains::params::voice_port, 
  $every = {},

) inherits lbchains::params {

    file { 'voice':
      path => '/etc/lb-chains/${account_name}-voice',
      mode => "0644",
      owner => "root",
      group => "root",
    }

    file_line { 'voice_single_server':
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
}
