#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

$SIG{INT} = $SIG{TERM} = sub { exit 0 };

use EventReactor;

EventReactor->new(
    port       => 843,
    on_connect => sub {
        my ($self, $atom) = @_;

        $atom->write(<<'EOF' => sub { $self->drop($atom) });
<?xml version="1.0"?>
<!DOCTYPE cross-domain-policy SYSTEM "/xml/dtds/cross-domain-policy.dtd">
<cross-domain-policy>
<site-control permitted-cross-domain-policies="master-only"/>
<allow-access-from domain="*" to-ports="*" secure="false"/>
</cross-domain-policy>
EOF
    }
)->listen;

1;
