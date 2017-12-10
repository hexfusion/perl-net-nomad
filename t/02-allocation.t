#!perl

use strict;
use warnings;

use Net::Nomad;
use Test::More;
use Test::Exception;
use Data::Dumper;

my $config;

if ( $ENV{NOMAD_TEST_HOST} and $ENV{NOMAD_TEST_PORT}) {
    $config->{host}   = $ENV{NOMAD_TEST_HOST};
    $config->{port}   = $ENV{NOMAD_TEST_PORT};
    plan tests => 4;
}
else {
    plan skip_all => "Please set environment variable NOMAD_TEST_HOST and NOMAD_TEST_PORT.";
}

my $nomad = Net::Nomad->new( $config );

my $resp;

## allocation list
lives_ok(
    sub {
        $resp = $nomad->allocation({ prefix=> 'a8198d79' })->list;
    },
    "allocations list"
);

#print STDERR Dumper($resp);

cmp_ok( $resp->is_success, '==', 1, "allocations list success" );

## allocation read
lives_ok(
    sub {
        $resp = $nomad->allocation( { alloc_id => '5456bd7a-9fc0-c0dd-6131-cbee77f57577' } )->read;
    },
    "allocation read"
);

#print STDERR Dumper($resp);

cmp_ok( $resp->{response}{content}, 'eq', 'alloc not found', "allocations read success" );

1;
