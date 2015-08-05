my $string = "0.0.0.0:8080->11211/tcp";
$string =~ /\:([0-9]+)/;

print "$1";
