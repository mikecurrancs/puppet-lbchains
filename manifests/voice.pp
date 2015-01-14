class lbchains::voice (
  $name = $account_name,
  $ip = {},
  $port = $lbchains::params::voice_port, 
  $every = {},

) inherits lbchains::params {

    file { 'voice':
      path => '/etc/lb-chains/${name}-voice',
      mode => "0644",
      owner => "root",
      group => "root",
    }

    file_line { 'voice_single_server':
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
