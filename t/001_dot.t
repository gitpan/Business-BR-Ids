
use Test::More tests => 5;
BEGIN { use_ok('Business::BR::Ids::Common', '_dot') };

my @a = (1,1,1,1);
my @b = (1,1,1,1);

is(_dot(\@a, \@b), 4, "_dot works");

my @c = (1,1,1,1,1);
is(_dot(\@a, \@c), 4, "_dot works for \@a < \@b");

# the following test is expected to emit a warning
# to test this, the STDERR is captured and checked to be non-empty

SKIP: {
  skip "for \$PERL_VERSION < 5.8", 2 if $] < 5.008;

my @d = (1,1,1);
{ 
  local *STDERR; my $stderr;
  open STDERR, ">", \$stderr or die;
  is(_dot(\@a, \@d), 3, "_dot works for \@a > \@b");
  ok($stderr, "but it does complain");
}

}
