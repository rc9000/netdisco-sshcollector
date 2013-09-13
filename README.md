# Documentation generated from POD in bin/netdisco-sshcollector
# NAME

netdisco-sshcollector - Collect ARP data for Netdisco from devices 
without full SNMP support

# SYNOPSIS

    netdisco-sshcollector [-i inputfile] [-c netdisco_config] [-w workers]

# DESCRIPTION

This program collects ARP data for Netdisco from devices without 
full SNMP support. Currently, ARP tables can be retrieved from the 
following device classes: 

- Cisco ACE using Netdisco::SSHCollector::Devices::ACE
- F5 BigIP using Netdisco::SSHCollector::Devices::BigIP

The collected arp entries are then directly stored in the netdisco 
database.

# USAGE

- __\-i inputfile__ 
 

    Data is collected from the machines specified in this file. The 
    format is five tab-separated columns, e.g.

        #hostname	ipaddress	user	password	devicetype
        host1	10.0.0.1	bob	$ecret77	BigIP
        -	        10.0.1.5	alice	-	        ACE



    Devicetype is the final part of the classname to be instantiated
    to query the host. 
    If the hostname is "-", the SSH session will be established using the
    ip address.
    If the password is "-", public key authentication will be attempted.

    Parameter defaults to ../etc/netdisco-sshcollector-hosts.csv. 

- __\-c netdisco\_config__

    Used to find the database of the local netdisco installation.

    Parameter defaults to /usr/share/netdisco/netdisco.conf. 



- __\-w workers__

    Number of parallel processes launched by Net::OpenSSH::Parallel.

    Parameter defaults to 10.

# ADDING DEVICES

Additional device classes can be easily integrated just by adding
and additonal Netdisco::SSHCollector::Devices class. This class 
must implement an `arpnip($hostname, $ssh)` method which returns
an array of hashrefs in the format

    { ip => IPADDR, mac => MACADDR }

# DEPENDENCIES

- __Cache::Cache__
- __Net::OpenSSH__
- __Net::OpenSSH::Parallel__
- __netdisco.pm__

The first three modules can be obtained from CPAN, while 
netdisco.pm comes with the netdisco installation.

It is likely necessary to add the netdisco base directory 
(containing netdisco and netdisco.pm) to PERLLIB or the
__use lib__ statement.


# Documentation generated from POD in lib/Netdisco/SSHCollector/Devices/BigIP.pm
# NAME

Netdisco::SSHCollector::Devices::BigIP

# DESCRIPTION

Collect ARP entries from F5 BigIP load balancers. These are Linux boxes, 
but feature an additional, proprietary IP stack which does not show 
up in the standard SNMP ipNetToMediaTable.

These devices also feature a CLI interface similar to IOS, which can
either be set as the login shell of the user, or be called from an 
ordinary shell. This module assumes the former, and if "show net arp"
can't be executed, falls back to the latter.   

# PUBLIC METHODS

- __arpnip($host, $ssh)__

    Retrieve ARP entries from device. `$host` is the hostname or IP address
    of the device. `$ssh` is a Net::OpenSSH connection to the device.

    Returns an array of hashrefs in the format { mac => MACADDR, ip => IPADDR }.
