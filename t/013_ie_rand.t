
use constant N => 100;
use constant N_STATES => 4; # AC, AL, SP and PR by now

use Test::More tests => 1+2*N*N_STATES;
BEGIN { use_ok('Business::BR::IE', 'random_ie', 'test_ie') };

# the seed is set so that the test is reproducible
srand(161803398874989);

my @states = qw(AC AL PR SP);

for my $s (@states) {

	for ( my $i=0; $i<N; $i++ ) {
		my $ie = random_ie($s);
		ok(test_ie($s, $ie), "random IE-$s '$ie' is correct");
	}
	for ( my $i=0; $i<N; $i++ ) {
		my $ie = random_ie($s, 0);
		ok(!test_ie($s, $ie), "random invalid IE-$s '$ie' is incorrect");
	}

}

