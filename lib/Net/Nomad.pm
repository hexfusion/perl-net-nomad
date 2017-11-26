use utf8;
package Net::Nomad;
# ABSTRACT: Provide access to the Nomad API.

use strict;
use warnings;

use Moo;
use Types::Standard qw(Str Int Bool HashRef);
use Net::Nomad::Agent;

use namespace::clean;

=encoding utf8

=head1 NAME

Net::Nomad - Nomad REST API client.

=cut

our $VERSION = '0.0.1';

=head1 SYNOPSIS

=head1 DESCRIPTION

L<Net::Nomad> is object oriented interface to the L<Nomad REST API|https://www.nomadproject.io/api/index.html>.

=head1 ACCESSORS

=head2 host

Defaults to 127.0.0.1

=cut

has host => (
    is      => 'ro',
    isa     => Str,
    default => '127.0.0.1'
);

=head2 port

Default 2379.

=cut

has port => (
    is      => 'ro',
    isa     => Int,
    default => '2379'
);

=head2 name

Username for authentication

=cut

has name => (
    is  => 'ro',
    isa => Str
);

=head2 password

Authentication credentials

=cut

has password => (
    is  => 'ro',
    isa => Str
);

=head2 cacert

Path to cacert

=cut

has cacert => (
    is  => 'ro',
    isa => Str,
);

=head2 ssl

To enable set to 1

=cut

has ssl => (
    is  => 'ro',
    isa => Bool,
);

=head2 api_version

defaults to /v1

=cut

has api_version => (
    is      => 'ro',
    isa     => Str,
    default => '/v1'
);

=head2 api_path

The full api path. Defaults to http://127.0.0.1:2379/v1

=cut

has api_path => ( is => 'lazy' );

sub _build_api_path {
    my ($self) = @_;
    return ( $self->ssl || $self->cacert ? 'https' : 'http' ) . '://'
      . $self->host . ':'. $self->port . $self->api_version;
}

=head1 PUBLIC METHODS

=head2 agent

See L<Net::Nomad::Agent>

    # query self
    $nomad->agent()->self;

    # check agent health
    $nomad->agent()->health;

=cut

sub agent {
    my ( $self, $options ) = @_;
    my $cb = pop if ref $_[-1] eq 'CODE';
    return Net::Nomad::Agent->new(
        nomad => $self,
        cb   => $cb,
        ( $options ? %$options : () ),
    );
}

=head1 AUTHOR

Sam Batschelet (hexfusion)

=head1 ACKNOWLEDGEMENTS

The L<Nomad|https://github.com/hashicorp/nomad> developers and community.

=head1 CAVEATS

=head1 LICENSE AND COPYRIGHT

Copyright 2017 Sam Batschelet (hexfusion).

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;
