use utf8;
package Net::Nomad::Role::Actions;

use strict;
use warnings;

use Moo::Role;
use AE;
use JSON;
use MIME::Base64;
use Types::Standard qw(InstanceOf);
use AnyEvent::HTTP;
use Carp;
use Data::Dumper;

use namespace::clean;

=encoding utf8

=head1 NAME

Net::Nomad::Role::Actions

=cut

our $VERSION = '0.017';

has nomad => (
    is  => 'ro',
    isa => InstanceOf ['Net::Nomad'],
);

=head2 json_args

arguments that will be sent to the api

=cut

has json_args => ( is => 'lazy', );

sub _build_json_args {
    my ($self) = @_;
    my $args = {};
    for my $key ( keys %{$self} ) {
        unless ( $key =~ /(?:nomad|method|required_acl|cb|cv|hold|json_args|endpoint)$/ ) {
            $args->{$key} = $self->{$key};
        }
    }
    return to_json($args);
}

=head2 cb

AnyEvent callback must be a CodeRef

=cut

has cb => (
    is  => 'ro',
    isa => sub {
        die "$_[0] is not a CodeRef!" if ( $_[0] && ref($_[0]) ne 'CODE')
    },
);

=head2 cv

=cut

has cv => (
    is  => 'ro',
);

=head2 init

=cut

sub init {
    my ($self)  = @_;
    my $init = $self->json_args;
    $init or return;
    return $self;
}

=head2 headers

=cut

has headers => (
    is      => 'lazy',
    clearer => 1
);

sub _build_headers {
    my ($self) = @_;
    my $headers;
    $headers->{'Content-Type'} = 'application/json';
    return $headers;
}

has tls_ctx => ( is  => 'lazy', );

sub _build_tls_ctx {
    my ($self) = @_;
    my $cacert = $self->nomad->cacert;
    if ($cacert) {
        my $tls =({
            verify  => 0,
            ca_path => $cacert,
		});
        return $tls;
    }
    return 'low'; #default
}

=head2 hold

When set will not fire request.

=cut

has hold => ( is => 'ro' );

=head2 response

=cut

has response => ( is => 'ro' );

=head2 request

=cut

has request => ( is => 'lazy', );

sub _build_request {
    my ($self) = @_;
    $self->init;
    my $cb = $self->cb;
    my $cv = $self->cv ? $self->cv : AE::cv;
    $cv->begin;

    http_request(
        $self->method,
        $self->nomad->api_path . $self->{endpoint},
        headers => $self->headers,
        body => $self->json_args,
        tls_ctx => $self->tls_ctx,
        on_header => sub {
            my($headers) = @_;
            $self->{response}{headers} = $headers;
        },
        on_body   => sub {
            my ($data, $hdr) = @_;
            $self->{response}{content} = $data;
            $cb->($data, $hdr) if $cb;
            my $status = $hdr->{Status};
            $self->check_hdr($status);
            $cv->end;
            1
        },
        sub {
            my (undef, $hdr) = @_;
            #print STDERR Dumper($hdr);
            my $status = $hdr->{Status};
            $self->check_hdr($status);
            $cv->end;
        }
    );
    $cv->recv;
    $self->clear_headers;

    return $self;
}

=head2 is_success

Success is returned if the response is a 200

=cut

sub is_success {
    my ($self)   = @_;
    my $response = $self->response;
    if ( defined $response->{success} ) {
        return $response->{success};
    }
    return;
}

=head2 content

returns JSON decoded content hash

=cut

sub content {
    my ($self)   = @_;
    my $response = $self->response;
    my $content  = from_json( $response->{content} );
    return $content if $content;
    return;
}

=head2 check_hdr

check response header then define success and retry_auth.

=cut

sub check_hdr {
    my ($self, $status)   = @_;
    my $success = $status == 200 ? 1 : 0;
    $self->{response}{success} = $success;
    return;
}

1;
