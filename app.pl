use warnings;
use strict;

use lib 'lib';
use Mojolicious::Lite;
use constant MODE => app->mode;
use Docker;

get "/" => sub {
  my $self = shift;
  $self->render(
    template => 'index'
  );
};

get "/ps" => sub {
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
  my $ip = $self->req->headers->header('X-Real-IP') || $self->tx->remote_address;
  my $running = Docker->running($ip);
  my %container;

  if ($running) {
    %container = %$running;
  } else {
    %container = Docker->create($ip);
  }

  $self->render(
    json => \%container
  );
};

app->log->debug("Starting application in ".MODE);
app->start;
