


                             Here is a typical Test::Builder based test

                                            t/MyModule.t
#!/usr/bin/perl

use strict;
use warnings;
use Test::More;

use_ok( 'MyModule' );

# Sanity
can_ok( 'MyModule', qw/a b/ );
isa_ok( 'MyModule', 'OtherModule' );

#Check defaults
my $one = MyModule->new;
is( MyModule->a, 'a', "default for a" );
is( MyModule->b, 'b', "default for b" );

#Set values
my $two = MyModule->new( a => 'A', b => 'B' );
is( MyModule->a, 'A', "construct value a" );
is( MyModule->b, 'B', "construct value b" );

done_testing;





