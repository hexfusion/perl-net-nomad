# NAME

Net::Nomad - Nomad REST API client.

# SYNOPSIS

# DESCRIPTION

[Net::Nomad](https://metacpan.org/pod/Net::Nomad) is object oriented interface to the [Nomad REST API](https://www.nomadproject.io/api/index.html).

# ACCESSORS

## host

Defaults to 127.0.0.1

## port

Default 4646.

## name

Username for authentication

## password

Authentication credentials

## cacert

Path to cacert

## ssl

To enable set to 1

## api\_version

defaults to /v1

## api\_path

The full api path. Defaults to http://127.0.0.1:4646/v1

# PUBLIC METHODS

## agent

See [Net::Nomad::Agent](https://metacpan.org/pod/Net::Nomad::Agent)

    # query self
    $nomad->agent()->self;

    # check agent health
    $nomad->agent()->health;

## allocation

See [Net::Nomad::Allocation](https://metacpan.org/pod/Net::Nomad::Allocation)

    $nomad->allocation({ prefix=> 'a8198d79' })->list;
    $nomad->allocation( { alloc_id => '5456bd7a-9fc0-c0dd-6131-cbee77f57577' } )->read

# AUTHOR

Sam Batschelet (hexfusion)

# ACKNOWLEDGEMENTS

The [Nomad](https://github.com/hashicorp/nomad) developers and community.

# CAVEATS

# LICENSE AND COPYRIGHT

Copyright 2017 Sam Batschelet (hexfusion).

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
