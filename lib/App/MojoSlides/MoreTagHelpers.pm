package App::MojoSlides::MoreTagHelpers;

use Mojo::Base 'Mojolicious::Plugin';

# list stolen from HTML::Tags (Web::Simple)
my @HTML_TAGS = qw(
a
aside
audio
blockquote
body
br
button
canvas
caption
cite
code
col
colgroup
div
dd
del
dl
dt
em
embed
fieldset
figcaption
figure
footer
h1
h2
h3
h4
h5
h6
head
header
hr
html
i
iframe
img
label
legend
li
noscript
object
ol
optgroup
option
output
p
pre
rp
rt
ruby
script
span
strong
style
table
tbody
td
textarea
tfoot
th
thead
tr
ul
video
);

sub register {
  my ($plugin, $app) = @_;
  foreach my $tag (@HTML_TAGS) {
    $app->helper( $tag => _tag($tag) );
  }
}

sub _tag {
  my $tag = shift;
  return sub {
    my $self = shift;
    my $id;
    my @class;
    if ($_[0] =~ /^[#.]/) {
      my $sel = shift;
      ($id)  = $sel =~ /\#([^#. ]+)/;
      @class = $sel =~ /\.([^#. ]+)/g;
    }
    return $self->tag( 
      $tag,
      $id ? ( id => $id ) : (),
      @class ? ( class => join(' ', @class) ) : (),
      @_
    );
  };
}

sub _gen_pod_list {
  my @list = map { "=item $_" } @HTML_TAGS;
  return '=over', @list, '=back';
}
  
1;

__END__

=head1 NAME

App::MojoSlides::MoreTagHelpers - More tag helpers for your slides

=head1 SYNOPSIS

 %= div '#mydiv.myclass' => begin
   %= p '.myp.myq' => 'Text'
   %= p 'Other Text'
 % end

 <div id="mydiv" class="myclass">
  <p class="myp myq">Text</p>
  <p>Other Text</p>
 </div>

=head1 DESCRIPTION

Wraps lots of HTML tags (though not all) into helpers.
If the helper gets a first argument that starts with C<#> or C<.>, that argument is parsed like a selector.
Note that only one id (the first) will be used if multiple are given.
Note that if C<id> or C<class> or attributes are passed by name, they will overwrite these.

=head1 ELEMENTS

While this module wraps a large number of HTML tags some have not been included.
Some elements are not included because of conflicts with existing keywords or helpers.
Others are not likely to be useful and are not included.
This list may change in the future, but common tags which meet the above critera are likely stable.


=over

=item a

=item aside

=item audio

=item blockquote

=item body

=item br

=item button

=item canvas

=item caption

=item cite

=item code

=item col

=item colgroup

=item div

=item dd

=item del

=item dl

=item dt

=item em

=item embed

=item fieldset

=item figcaption

=item figure

=item footer

=item h1

=item h2

=item h3

=item h4

=item h5

=item h6

=item head

=item header

=item hr

=item html

=item i

=item iframe

=item img

=item label

=item legend

=item li

=item noscript

=item object

=item ol

=item optgroup

=item option

=item output

=item p

=item pre

=item rp

=item rt

=item ruby

=item script

=item span

=item strong

=item style

=item table

=item tbody

=item td

=item textarea

=item tfoot

=item th

=item thead

=item tr

=item ul

=item video

=back
