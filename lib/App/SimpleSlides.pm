package App::SimpleSlides;

use Mojo::Base 'Mojolicious';

use App::SimpleSlides::Slides;

has slides => sub {
  my $self = shift;
  return App::SimpleSlides::Slides->new( 
    $self->config->{slides} || ()
  );
};

sub startup {
  my $self = shift;

  $self->helper( presentation_file => sub {
    require File::Spec;
    require File::Basename;

    my $file = $ENV{SIMPLE_SLIDES_PRESENTATION} || 'presentation.pl';
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

  $self->helper( row    => sub { shift->tag( 'div', class => 'row', @_ ) } );
  $self->helper( column => sub { shift->tag( 'div', class => 'col-md-'.shift, @_ ) } );

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

