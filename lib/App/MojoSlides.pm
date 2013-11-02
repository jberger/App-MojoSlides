package App::MojoSlides;

use Mojo::Base 'Mojolicious';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

use App::MojoSlides::Slides;

has slides => sub {
  my $self = shift;
  return App::MojoSlides::Slides->new( 
    $self->config->{slides} || ()
  );
};

sub startup {
  my $self = shift;

  $self->plugin( 'InstallablePaths' );

  $self->helper( presentation_file => sub {
    require File::Spec;
    require File::Basename;

    my $file = $ENV{MOJO_SLIDES_PRESENTATION} || 'presentation.pl';
    return $file unless -e $file; # return early if not found

    my $abs = File::Spec->rel2abs($file);
    return File::Basename::fileparse($abs) if wantarray;
    return $abs;
  });

  $self->plugin( Config => {
    file => scalar $self->presentation_file, 
    default => {
      slides    => undef,
      ppi       => undef,
      templates => undef,
      static    => undef,
      bootstrap_theme => undef,
    },
  });

  if (my $path = $self->config->{templates}) {
    unshift @{ $self->renderer->paths }, ref $path ? @$path : $path;
  }

  if (my $path = $self->config->{static}) {
    unshift @{ $self->static->paths }, ref $path ? @$path : $path;
  }

  if (my $ppi = $self->config->{ppi}) {
    my $args = {};
    $args->{src_folder} = $ppi if -d $ppi;
    $self->plugin(PPI => $args);
  }

  $self->helper( prev_slide => sub {
    my $c = shift;
    return $c->app->slides->prev($c->stash('slide'));
  });

  $self->helper( next_slide => sub {
    my $c = shift;
    return $c->app->slides->next($c->stash('slide'));
  });

  $self->helper( last_slide => sub { shift->app->slides->last } );

  $self->helper( row     => sub { shift->tag( 'div', class => 'row', @_ ) } );
  $self->helper( column  => sub { shift->tag( 'div', class => 'col-md-'.shift, @_ ) } );
  $self->helper( overlay => sub { shift->tag( 'div', msOverlay => shift, @_ ) } );

  my $r = $self->routes;
  $r->any(
    '/:slide',
    { slide => $self->slides->first },
    [ slide => qr/\b\d+\b/ ],
    \&_action,
  );
}

sub _action {
  my $c = shift;
  my $slides = $c->app->slides;
  my $slide = $slides->template_for($c->stash('slide'))
    or return $c->render_not_found;
  $c->render($slide, layout => 'basic') || $c->render_not_found;
}

1;

__END__

=head1 NAME

App::MojoSlides - Write your presentations in Perl and Mojolicious!

=head1 SYNOPSIS

 $ mojo_slides mypresentation.pl daemon

=head1 DESCRIPTION

This application lets you write presentations using the simple Perlish syntax that
L<Mojo::Template> provides for L<Mojolicious>. It follows a similar model to LaTeX Beamer
in structure and usage, though it is not nearly as full featured.

=head1 WARNING

This software is in alpha form at best. It may eat baby kittens at any moment.

=head1 TECHNOLOGIES USED

=over 

=item L<Mojolicious|http://mojolicio.us>

=item L<Bootstrap|http://getbootstrap.com>

=item L<jQuery|http://jquery.com>

=item L<PPI>

- if desired for Perl code highlighting

=item L<Mousetrap|http://craig.is/killing/mice>

- simple javascript keybinding library

=back

=head1 SOURCE REPOSITORY

L<http://github.com/jberger/App-MojoSlides> 

=head1 AUTHOR

Joel Berger, E<lt>joel.a.berger@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Joel Berger

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

