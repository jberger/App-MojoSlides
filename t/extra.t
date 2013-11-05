use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

$ENV{MOJO_SLIDES_PRESENTATION} = 't/pres/extra.pl';

my $t = Test::Mojo->new('App::MojoSlides');

$t->get_ok('/1')
  ->text_is('p' => 'Hi')
  ->content_like(qr/myjs\.js/);

done_testing;

