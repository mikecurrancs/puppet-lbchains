### LBchains Puppet Module ###

This module is being created to assist with the initial stand-up of an Adobe Connect account.

The lbchains during setup are usually written to the Load Balancer after the initial task of taking a server out of rotation and putting it back into rotation.

What is accomplished with this module is to write the initial rules to the Load Balancer via Puppet. This will includ HTTP, HTTPs and voice round-robin rules.

This module is not intended to take the place of Control Center writing rules, but to assist with quicker testing of the account and eliminate the initial build of the rules.

Rules can be 1 node or 1+n nodes 

A 1 node ruleset looks like this 

```
#/bin/bash

# rti-http chain

# flush and zero the chains
iptables -t nat -F rti-http
iptables -t nat -Z rti-http

# c-bl-rti-cp02
iptables -t nat -A rti-http -p tcp --dport 80 -m state --state NEW -j DNAT --to-destination 10.7.4.111:8080
# chain done

iptables -t nat -L rti-http
```


And a 1+n node ruleset looks like this


```
#/bin/bash

# rti-http chain

# flush and zero the chains
iptables -t nat -F rti-http
iptables -t nat -Z rti-http

# c-bl-rti-cp01
iptables -t nat -A rti-http -p tcp --dport 80 -m state --state NEW -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 10.7.4.109:8080
# c-bl-rti-cp02
iptables -t nat -A rti-http -p tcp --dport 80 -m state --state NEW -j DNAT --to-destination 10.7.4.111:8080
# chain done

iptables -t nat -L rti-http
```
