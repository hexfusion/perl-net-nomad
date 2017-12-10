use utf8;
package Net::Nomad::Allocation;

use strict;
use warnings;

use Moo;
use Types::Standard qw(Str Int Bool HashRef ArrayRef);
use Carp;
use Data::Dumper;

with 'Net::Nomad::Role::Base';
with 'Net::Nomad::Role::Actions';


use namespace::clean;

=head1 NAME

Net::Nomad::Allocation

=cut

our $VERSION = '0.0.1';

=head1 DESCRIPTION

=head1 ACCESSORS

=head2 prefix

Specifies a string to filter allocations on based on an index prefix.
This is specified as a querystring parameter.

=cut

has prefix => (
    is      => 'ro',
    isa     => Str,
);

=head2 alloc_id 

Specifies the UUID of the allocation. This must be the full UUID, not the
short 8-character one. This is specified as part of the path.

=cut

has alloc_id  => (
    is      => 'ro',
    isa     => Str,
);

=head1 PUBLIC METHODS

=head2 list

This endpoint lists all allocations.

    $nomad->allocations( prefix => 'a8198d79' )->list

=cut

sub list {
    my $self = shift;
    $self->{endpoint} = '/allocations';
    $self->{method} = 'GET';
    $self->{param_type} = 'form';
    $self->{required_acl} = 'namespace:read-job';
    $self->request;
    return $self;
}

=head2 read

This endpoint reads information about a specific allocation. Requires alloc_id

   $nomad->allocations( alloc_id => '5456bd7a-9fc0-c0dd-6131-cbee77f57577' )->read

=cut

sub read {
    my $self = shift;
    $self->{endpoint} = '/allocation';
	confess 'alloc_id required for ' . __PACKAGE__ . '->read'
      unless $self->{alloc_id};
    $self->{method} = 'GET';
    $self->{param_type} = 'route';
    $self->{required_acl} = 'namespace:read-job';
    $self->request;
    return $self;
}

1;
