package App::MojoSlides::Slides;

use Mojo::Base -base;

has first => 1;

has last  => sub {
  my $self = shift;
  my $slides = $self->list or return 1;
  return @$slides;
};

has 'list';

sub prev {
  my ($self, $current) = @_;
  return $current == $self->first ? $current : $current - 1;
}

sub next {
  my ($self, $current) = @_;
  return $current == $self->last ? $current : $current + 1;
}

sub template_for {
  my ($self, $num) = @_;
  return "$num" unless my $list = $self->list;
  return $list->[$num-1];
}

1;

