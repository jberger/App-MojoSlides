use Mojo::Base -strict;

my $conf = {
  last      => 1,
  extra_js  => 'myjs.js',
  extra_css => ['mycss1.css', 'mycss2.css'],
};

__DATA__

@@ 1.html.ep
%= p 'Hi'

