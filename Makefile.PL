use inc::Module::Install;
 
name     'netdisco-sshcollector';
license  'artistic';
all_from 'bin/netdisco-sshcollector';

requires 'App::Netdisco' => 0;
requires 'Net::OpenSSH' => 0;
requires 'Sys::RunAlone' => 0;

install_script 'bin/netdisco-sshcollector';

resources
  homepage => 'https://github.com/ollyg/netdisco-sshcollector',
  bugtracker => 'https://github.com/ollyg/netdisco-sshcollector/issues',
  repository => 'git@github.com/netdisco-sshcollector.git';

WriteAll;
