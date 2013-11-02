#!/usr/bin/env perl

use strict;
use warnings;

use Module::Build::Mojolicious;

my $build = Module::Build::Mojolicious->new(
  module_name        => 'App::SimpleSlides',
  dist_author        => 'Joel Berger <joel.a.berger@gmail.com>',
  license            => 'perl',
  configure_requires => { 
    'Module::Build' => 0.36,
    'Module::Build::Mojolicious' => 0,
  },
  requires => {
    'Mojolicious' => '3.0',
  },
  meta_merge => {
    resources  => {
      repository => "http://github.com/jberger/App-SimpleSlides",
      bugtracker => "http://github.com/jberger/App-SimpleSlides/issues",
    },
    no_index => {
      file      => [ 'README.pod' ],
    },
  },
);

$build->create_build_script;
