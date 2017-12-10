use utf8;
package Net::Nomad::Role::Base;

use strict;
use warnings;

use Moo::Role;
use Types::Standard qw(InstanceOf ArrayRef Str);
use Data::Dumper;

use namespace::clean;

=encoding utf8

=head1 NAME

Net::Nomad::Role::Base

=cut

our $VERSION = '0.0.1';

=head2 endpoint

API endpoint

=cut

has endpoint => (
    is      => 'rwp',
	isa     => Str
);

=head2 method

HTTP method called against API

=cut

has method => (
    is      => 'rwp',
    isa     => Str,
);

=head2 required_acl

=cut

has required_acl => (
    is      => 'rwp',
    isa     => ArrayRef,
);

=head2 parameter_type

=cut

has param_type => (
    is      => 'ro',
    isa     => Str,
);



1;
