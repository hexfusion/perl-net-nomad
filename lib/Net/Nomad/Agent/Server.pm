use utf8;
package Net::Nomad::Agent::Server;

use strict;
use warnings;

use Moo;
use Types::Standard qw(Str Int Bool HashRef ArrayRef);
use Carp;
use Data::Dumper;

with 'Net::Etcd::Role::Base';
with 'Net::Etcd::Role::Actions';

use namespace::clean;

=head1 NAME

Net::Nomad::Agent::Server

=cut

our $VERSION = '0.0.1';

=head1 DESCRIPTION

The /agent endpoints are used to interact with the local Nomad agent.

=head1 ACCESSORS

=head2 node

Specifies the name of the node to force leave.

=cut

has node => (
    is      => 'ro',
    isa     => Str,
);

=head2 address

Specifies the address to join in the ip:port format. This is provided as a query
parameter and may be specified multiple times to join multiple servers.

=cut

has address => (
    is      => 'ro',
    isa     => Str,
    coerce   => sub { my $param; map { push @$param, {'address' => $_ } } return $param },
);

=head1 PUBLIC METHODS

=cut

=head2 list

List Servers:
This endpoint lists the known server nodes. The servers endpoint is used to query an agent
in client mode for its list of known servers. Client nodes register themselves with these
server addresses so that they may dequeue work. The servers endpoint can be used to keep
this configuration up to date if there are changes in the cluster.

    $nomad->agent->server()->list

=cut

sub list {
    my $self = shift;
    $self->{endpoint} = '/agent/servers';
    $self->{method} = 'GET';
    $self->{required_acl} = 'agent:write';
    $self->request;
    return $self;
}

=head2 join

    $nomad->server( address => [ '1.2.3.4:4647', '1.2.3.2:4647' ] )->join

=cut

sub join {
    my $self = shift;
    confess 'address required for ' . __PACKAGE__ . '->join'
	      unless $self->{address};
    $self->{endpoint} = '/agent/servers';
    $self->{method} = 'GET';
    $self->{required_acl} = 'agent:write';
    $self->request;
    return $self;
}

=head2 update

    $nomad->server( address => [ '1.2.3.4:4647', '1.2.3.2:4647' ] )->update

=cut

sub update {
    my $self = shift;
    confess 'address required for ' . __PACKAGE__ . '->update'
	      unless $self->{address};
    $self->{endpoint} = '/agent/servers';
    $self->{method} = 'POST';
    $self->{required_acl} = 'agent:write';
    $self->request;
    return $self;
}

=head2 force-leave

    $nomad->server( node => 'client-ab2e23dc' )->force-leave

=cut

sub force-leave {
    my $self = shift;
    confess 'node required for ' . __PACKAGE__ . '->force-leave'
	      unless $self->{node};
    $self->{endpoint} = '/agent/force-leave';
    $self->{method} = 'POST';
    $self->{required_acl} = 'agent:write';
    $self->request;
    return $self;
}

1;
