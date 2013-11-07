use Mojolicious::Lite;

plugin 'App::MojoSlides::MoreTagHelpers';

any '/'  => 'index';
any '/s' => 'selector';
any '/i_parent' => 'incremental_parent';
any '/i_items'  => 'incremental_items';

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new;
$t->get_ok('/')
  ->text_is('h2' => 'Hello World')
  ->text_is('div.find #me' => 'Gotcha');

$t->get_ok('/s')
  ->text_is('#foo' => 'hi')
  ->text_is('.baz' => 'hi')
  ->text_is('.bat' => 'hi')
  ->text_is('#foo.baz.bat' => 'hi')
  ->element_exists_not('#bar');

$t->get_ok('/i_parent')
  ->text_is('li[ms_overlay="1-"]' => 'One')
  ->text_is('li[ms_overlay="2-"]' => 'Two');

$t->get_ok('/i_items')
  ->text_is('li[ms_overlay="1-"]' => 'First')
  ->text_is('li[ms_overlay="2-"]' => 'Second');

done_testing;

__DATA__

@@ index.html.ep

%= h2 'Hello World'

%= div class => 'find' => begin
  %= p id => 'me' => 'Gotcha'
% end

@@ selector.html.ep

%= div '#foo#bar.baz.bat' => 'hi'

@@ incremental_parent.html.ep

%= incremental ul begin
  %= li 'One'
  %= li 'Two'
% end

@@ incremental_items.html.ep

%= ul begin
  %= incremental begin
    %= li 'First'
    %= li 'Second'
  % end
% end
