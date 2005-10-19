

use Test::More;
BEGIN { use_ok('Business::BR::PIS') };

my @valid_pis = (
    '121.51144.13-7',
    '12151144137',

);
my @invalid_pis = (
    '',
    '1',
    '121.51144.13-0',

);


plan tests => @valid_pis+@invalid_pis;

for (@valid_pis) {
  ok(test_pis($_), "'$_' is correct");
}

for (@invalid_pis) {
  ok(!test_pis($_), "'$_' is incorrect");
}

