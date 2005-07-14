
use constant N => 100;

use Test::More tests => 1+2*N;
BEGIN { use_ok('Business::BR::IE', 'random_ie', 'test_ie') };

# the seed is set so that the test is reproducible
srand(161803398874989);

for ( my $i=0; $i<N; $i++ ) {
	my $ie = random_ie('sp');
	ok(test_ie('sp', $ie), "random IE-SP '$ie' is correct");
}
for ( my $i=0; $i<N; $i++ ) {
	my $ie = random_ie('sp', 0);
	ok(!test_ie('sp', $ie), "random invalid IE-SP '$ie' is incorrect");
}

