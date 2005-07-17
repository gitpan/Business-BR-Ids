
use Test::More tests => 7;
BEGIN { use_ok('Business::BR::IE', 'canon_ie') };

is(canon_ie('ac', '00 000 000 000 99'), '0000000000099', 'discards formatting and extras');

is(canon_ie('al', '00:000:000:9'), '000000009', 'canon for IE-AL ok');

is(canon_ie('sp', 99), '000000000099', 'amenable to ints');
is(canon_ie('sp', '999.999.999.999'), '999999999999', 'discards formatting');

is(canon_ie('sp', 111_222_333_444_555), '111222333444555', 'too long ints pass through');
is(canon_ie('sp', '111_222_333_444_555'), '111222333444555', 'as well as other too long inputs');

