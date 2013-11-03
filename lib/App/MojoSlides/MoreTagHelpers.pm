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
dl
dt
em
embed
fieldset
figcaption
figure
footer
form
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
input
label
legend
li
meta
nav
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

