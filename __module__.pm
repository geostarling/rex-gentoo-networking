package Rex::Gentoo::Networking;

use Rex -base;
use Rex::Template::TT;

use Term::ANSIColor;

desc 'Setup networking';

task 'setup', sub {
  setup_interfaces();
  setup_hostname();
};

task 'setup_interfaces', sub {
  my $interfaces = param_lookup "interfaces", [];
  file "/etc/conf.d/net",
    content => template("templates/net.tt", interfaces => $interfaces);

  foreach (@$interfaces) {
    my $iface_name = $_->{name};
    if ( !($iface_name eq "lo") ) {
      symlink("net.lo", "/etc/init.d/net.$iface_name");
      if ( !exists($_->{enabled}) || $_->{enabled} ) {
        service "net.$iface_name",
        ensure => "enabled";
      }
    }
  }
};

task 'setup_hostname', sub {
  my $hostname = param_lookup "hostname", 'localhost';
  file "/etc/conf.d/hostname",
  content => "hostname=\"$hostname\"";
};


1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Rex::Gentoo::Install/;

 task yourtask => sub {
    Rex::Gentoo::Install::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
