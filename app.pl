use warnings;
use strict;

use lib 'lib';
use Docker;
use Mojolicious::Lite;

get "/" => sub {
  my $self = shift;
  $self->render(
    template => 'index'
  );
};

get "/ds" => sub {
  my $self = shift;
  my @containers = Docker->ps();

  $self->render(
    json => \@containers
  );
};

get "/removable" => sub {
  my $self = shift;
  my @removable = Docker->removable();

  $self->render(
    json => \@removable
  );
};

post "/create" => sub {
  my $self = shift;
  my %container = Docker->create();

  $self->render(
    json => \%container
  );
};

app->start;
