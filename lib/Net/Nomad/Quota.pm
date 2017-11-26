use utf8;
package Net::Nomad::Ouota;

use strict;
use warnings;

use Moo;
use Types::Standard qw(Str Int Bool HashRef ArrayRef);
use Data::Dumper;

use namespace::clean;

=head1 NAME

Net::Nomad::Ouota

=cut

our $VERSION = '0.0.1';

=head1 DESCRIPTION

=head1 ACCESSORS

=head2 endpoint

=cut

has endpoint => (
    is      => 'rwp',
    isa     => Str,
);

=head1 PUBLIC METHODS

=cut

1;
