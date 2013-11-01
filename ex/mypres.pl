use Mojo::Base -strict;

my (undef, $dir) = app->presentation_file;

my $conf = {
  slides => {
    list => ['hello', 'goodbye'],
  },
  templates => $dir,
};
