
                           Here is that same test written the fennec way

                                           t/MyModule.pm
package TEST::MyModule;
use strict;
use warnings;
use Fennec;

use_ok( 'MyModule' );

tests Sanity {
    ok( $self, "I'm a method!" );
    can_ok( 'MyModule', qw/a b/ );
    isa_ok( 'MyModule', 'OtherModule' );
}

tests 'Check defaults' {
    my $one = MyModule->new;
    is( MyModule->a, 'a', "default for a" );
    is( MyModule->b, 'b', "default for b" );
}

tests 'Set values' {
    my $one = MyModule->new( a => 'A', b => 'B' );
    is( MyModule->a, 'A', "construct value a" );
    is( MyModule->b, 'B', "construct value b" );
}

1;




