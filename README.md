# NAME

netdisco-sshcollector - Collect ARP data for Netdisco from devices
without full SNMP support

# SYNOPSIS

    netdisco-sshcollector [-i inputfile] [-c netdisco_config] [-w workers]

# DESCRIPTION

This program collects ARP data for Netdisco from devices without
full SNMP support. Currently, ARP tables can be retrieved from the
following device classes:

- `Netdisco::SSHCollector::Devices::ACE` - Cisco ACE (Application Control Engine) 
- `Netdisco::SSHCollector::Devices::BigIP` - F5 Networks BigIP

The collected arp entries are then directly stored in the netdisco
database.

# USAGE

- `-i inputfile`

    Data is collected from the machines specified in this file. The
    format is five tab-separated columns: hostname, ipaddress,
    username, password, devicetpye. Blank lines and lines with a
    leading \# are ignored.

    Devicetype is the final part of the classname to be instantiated
    to query the host, e.g. devicetype __ACE__ will be queried using 
    `Netdisco::SSHCollector::Devices::ACE`.

    If the hostname is "-", the SSH session will be established using the
    ip address.
    If the password is "-", public key authentication will be attempted.

    Parameter defaults to ../etc/netdisco-sshcollector-hosts.csv.

- `-c netdisco_config`

    Used to find the database of the local netdisco installation.

    Parameter defaults to /usr/share/netdisco/netdisco.conf.



- `-w workers`

    Number of parallel processes launched. 

    Parameter defaults to 10.

# INPUT FILE EXAMPLE

    #hostname      ipaddress       user    password        devicetype
    host1  10.0.0.1        bob     $ecret77        BigIP
    -      10.0.1.5        alice   -       ACE

# ADDING DEVICES

Additional device classes can be easily integrated just by adding
and additonal class to the `Netdisco::SSHCollector::Devices` package. 
This class must implement an `arpnip($hostname, $ssh)` method which 
returns an array of hashrefs in the format

    @result = ({ ip => IPADDR, mac => MACADDR }, ...) 

The parameter `$ssh` is an active `Net::OpenSSH` connection to the 
host. Depending on the target system, it can be queried using simple
methods like

    my @data = $ssh->capture("show whatever")
 or automated via Expect - this is mostly useful for non-Linux 
 appliances which don't support command execution via ssh:

    my ($pty, $pid) = $ssh->open2pty or die "unable to run remote command";
    my $expect = Expect->init($pty);
    my $prompt = qr/#/;
    my ($pos, $error, $match, $before, $after) = $expect->expect(10, -re, $prompt);
    $expect->send("terminal length 0\n");

    # etc...

The returned IP and MAC addresses should be in a format that the 
respective __inetaddr__ and __macaddr__ datatypes in PostgreSQL can
handle.   





# DEPENDENCIES

- `Cache::Cache`
- `Net::OpenSSH`
- `Module::Load`
- `Parallel::ForkManager`
- `Sys::RunAlone`
- `netdisco`

The non-netdisco modules can be obtained from CPAN. Alternatively if you
can't use CPAN and your distro doesn't provide these packages, you can
add the `cpanlib` directory to `PERLLIB`, it contains fairly recent
versions of all dependencies. These are all pure Perl modules which
should work on any platform.

The module netdisco.pm comes with the netdisco installation.

It is likely necessary to add the netdisco base directory
(containing netdisco and netdisco.pm) to PERLLIB or the
__use lib__ statement.


***
# POD of module lib/Netdisco/SSHCollector/Devices/ACE.pm
***
# NAME

Netdisco::SSHCollector::Devices::ACE

# DESCRIPTION

Collect ARP entries from Cisco ACE load balancers. ACEs have multiple
virtual contexts with individual ARP tables. Contexts are enumerated
with `show context`, afterwards the commands `changeto CONTEXTNAME` and
`show arp` must be executed for every context.

The IOS shell does not permit to combine mulitple commands in a single
line, and Net::OpenSSH uses individual connections for individual commands,
so we need to use Expect to execute the changeto and show commands in
the same context.

# PUBLIC METHODS

- __arpnip($host, $ssh)__

    Retrieve ARP entries from device. `$host` is the hostname or IP address
    of the device. `$ssh` is a Net::OpenSSH connection to the device.

    Returns an array of hashrefs in the format { mac => MACADDR, ip => IPADDR }.


***
# POD of module lib/Netdisco/SSHCollector/Devices/BigIP.pm
***
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


