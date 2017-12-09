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
    plan tests => 8;
}
else {
    plan skip_all => "Please set environment variable NOMAD_TEST_HOST and NOMAD_TEST_PORT.";
}

my $nomad = Net::Nomad->new( $config );

my $resp;

## agent self
lives_ok(
    sub {
        $resp = $nomad->agent()->self;
    },
    "agent self"
);

#print STDERR Dumper($resp);

cmp_ok( $resp->is_success, '==', 1, "agent self success" );

## agent health
lives_ok(
    sub {
        $resp = $nomad->agent()->health;
    },
    "agent health"
);

#print STDERR Dumper($resp);

cmp_ok( $resp->is_success, '==', 1, "agent health success" );

# agent members
lives_ok(
    sub {
        $resp = $nomad->agent()->members;
    },
    "agent members"
);

#print STDERR Dumper($resp);

cmp_ok( $resp->is_success, '==', 1, "agent members success" );

# agent server list
lives_ok(
    sub {
        $resp = $nomad->agent->server()->list;
    },
    "agent server list"
);

#print STDERR Dumper($resp);

cmp_ok( $resp->is_success, '==', 1, "agent server list success" );

1;
