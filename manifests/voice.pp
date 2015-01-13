class puppet-lbchains::voice (
  $account_name = $name,
  $ip = {},
  $voice_port = $port 

) inherits puppet-lbchains::params {

    file { 'voice':
      path => '/etc/lb-chains/${name}-voice',
      mode => "0644",
      owner => "root",
      group => "root",
    }

    file_line { 'rule 1':
      path => '/etc/lb-chains/${name}-voice',
      line => '#/bin/bash',
      line => '# ${name}-voice',
      line => 'iptables -t nat -F ${name}-voice',
      line => 'iptables -t nat -Z ${name}-voice',
      line => '# hostname',
      line => 'iptables -t nat -A ${name}-voice -p tcp --dport ${port} -m state --state NEW -j DNAT --to-destination ${ip}:${port}',
      line => '# Chain done',
      line => 'iptables -t nat -L ${name}-voice',
      require => File[voice],
    }
}
