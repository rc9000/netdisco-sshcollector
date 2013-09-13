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

- `-i inputfile` 
 

    Data is collected from the machines specified in this file. The 
    format is five tab-separated columns: hostname, ipaddress, 
    username, password, devicetpye. Blank lines and lines with a 
    leading \# are ignored.

    Devicetype is the final part of the classname to be instantiated
    to query the host. 
    If the hostname is "-", the SSH session will be established using the
    ip address.
    If the password is "-", public key authentication will be attempted.

    Parameter defaults to ../etc/netdisco-sshcollector-hosts.csv. 

- `-c netdisco_config`

    Used to find the database of the local netdisco installation.

    Parameter defaults to /usr/share/netdisco/netdisco.conf. 



- `-w workers`

    Number of parallel processes launched by Net::OpenSSH::Parallel.

    Parameter defaults to 10.

# INPUT FILE EXAMPLE

    #hostname	ipaddress	user	password	devicetype
    host1	10.0.0.1	bob	$ecret77	BigIP
    -	10.0.1.5	alice	-	ACE

# ADDING DEVICES

Additional device classes can be easily integrated just by adding
and additonal Netdisco::SSHCollector::Devices class. This class 
must implement an `arpnip($hostname, $ssh)` method which returns
an array of hashrefs in the format

    { ip => IPADDR, mac => MACADDR }

# DEPENDENCIES

- `Cache::Cache`
- `Net::OpenSSH`
- `Net::OpenSSH::Parallel`
- `netdisco.pm`

The first three modules can be obtained from CPAN. Alternatively if you
can't use CPAN and your distro doesn't provide these packages, 

The module netdisco.pm comes with the netdisco installation.

It is likely necessary to add the netdisco base directory 
(containing netdisco and netdisco.pm) to PERLLIB or the
__use lib__ statement.


