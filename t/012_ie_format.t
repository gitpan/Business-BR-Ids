
use Test::More tests => 6;
BEGIN { use_ok('Business::BR::IE', 'format_ie') };

is(format_ie('ac', '00 000 000 000 99'), '00.000.000/000-99', 'IE-AC formatting works');

is(format_ie('sp','000000000000'), '000.000.000.000', 'works ok');
is(format_ie('sp', 6688822200), '006.688.822.200', 'works even for short ints');

is(format_ie('sp', '000x000x000x000'), '000.000.000.000', 'argument is flattened before formatting');

is(format_ie('sp', '1234567890123'), '123.456.789.012', 'only 1st 12 digits matter for long inputs');


