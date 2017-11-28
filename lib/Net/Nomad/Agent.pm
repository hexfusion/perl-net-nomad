use utf8;
package Net::Nomad::Agent;

use strict;
use warnings;

use Moo;
use Types::Standard qw(Str Int Bool HashRef ArrayRef);
use Net::Nomad::Agent::Server;
use Data::Dumper;

use namespace::clean;

=head1 NAME

Net::Nomad::Agent

=cut

our $VERSION = '0.0.1';

=head1 DESCRIPTION

The /agent endpoints are used to interact with the local Nomad agent.

=head1 ACCESSORS

=head2 endpoint

API endpoint

=cut

has endpoint => (
    is      => 'rwp',
    isa     => Str,
);

=head2 method

HTTP method called against API

=cut

has method => (
    is      => 'rwp',
    isa     => Str,
);

=head1 PUBLIC METHODS

=cut

=head2 members

List Members:
This endpoint queries the agent for the known peers in the gossip pool. This
endpoint is only applicable to servers. Due to the nature of gossip,
this is eventually consistent.

    $nomad->agent()->members

=cut

sub members {
    my $self = shift;
    $self->{endpoint} = '/agent/members';
    $self->{method} = 'GET';
    $self->{required_acl} = 'node:read';
    $self->request;
    return $self;
}

=head2 server

Helper method to access L<Net::Nomad::Agent::Server>

=cut

sub server {
    my ( $self, $options ) = @_;
    my $cb = pop if ref $_[-1] eq 'CODE';
    return Net::Nomad::Agent::Server->new(
        %$self,
        ( $options ? %$options : () ),
    );
}

=head2 self

This endpoint queries the state of the target agent (self).

    $nomad->agent()->self

=cut

sub self {
    my $self = shift;
    $self->{endpoint} = '/agent/self';
    $self->{method} = 'POST';
    $self->{required_acl} = 'agent:read';
    $self->request;
    return $self;
}

=head2 health

This endpoint returns whether or not the agent is healthy. When using Consul
it is the endpoint Nomad will register for its own health checks.

When the agent is unhealthy 500 will be returned along with JSON response
containing an error message.

    $nomad->agent()->health

=cut

sub self {
    my $self = shift;
    $self->{endpoint} = '/agent/health';
    $self->{method} = 'GET';
    $self->{required_acl} = '';
    $self->request;
    return $self;
}

1;
