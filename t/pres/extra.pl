use Mojo::Base -strict;

my $conf = {
  last     => 1,
  extra_js => 'myjs.js',
};

__DATA__

@@ 1.html.ep
%= p 'Hi'

