my (undef, $dir) = app->presentation_file;

my $conf = {
  slides => {
    list => ['hello', 'goodbye'],
  },
  bootstrap_theme => 1,
  templates => $dir,
};
