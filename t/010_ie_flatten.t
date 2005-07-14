
use Test::More tests => 5;
BEGIN { use_ok('Business::BR::IE', 'flatten_ie') };

is(flatten_ie('sp', 99), '000000000099', 'amenable to ints');
is(flatten_ie('sp', '999.999.999.999'), '999999999999', 'discards formatting');

is(flatten_ie('sp', 111_222_333_444_555), '111222333444555', 'too long ints pass through');
is(flatten_ie('sp', '111_222_333_444_555'), '111222333444555', 'as well as other too long inputs');

