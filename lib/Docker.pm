use warnings;
use strict;
package Docker;

use constant LINE_BREAK => qr/\n/;
use constant SEPARATOR => qr/[\s]{2,}/;

sub ps {
  my $command = `docker ps`;
  my @lines = split LINE_BREAK, $command;
  my $line_number = 1;
  my @headers = split(SEPARATOR, shift(@lines));
  my @containers = ();

  while (my $container_line = shift(@lines)) {
    my @container = split(SEPARATOR, $container_line);
    my %container = ();
    my $index = 0;

    for my $column (@headers) {
      my $value = $container[$index];
      my $column_key = underscore($column);
      $value = parse_port($value) if ($column_key eq "ports");
      $container{$column_key} = $value;
      $index++;
    }

    push @containers, \%container;
  }

  @containers;
}

sub create {
  my $name = container_name();
  my $command = `docker run --name $name -c 10 -m 5MB -d -P memcached`;
  # `sudo ufw allow $port`;
  Docker->find($name);
}

sub find {
  shift;
  my $name = shift;
  my @containers = ps();
  my ($container_ref) = grep { $_->{'names'} eq $name } @containers;

  %$container_ref;
}

sub removable {
  shift;
  my @containers = ps();
  my @removable_containers = grep {
    my $status = $_->{'created'};
    $status =~ /week/ or $status =~ /day/ or $status =~ /1[0-9]+ hours/
  } @containers;

  @removable_containers;
}

sub ip {
  $ENV{'IP'};
}

sub underscore {
  my $string = shift;
  $string =~ s/\s/\_/;
  lc $string;
}

sub container_name {
  time();
}

sub parse_port {
  my $string = shift;
  $string =~ /\:([0-9]+)/;
  $1;
}

1;
