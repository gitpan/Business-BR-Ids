
use Test::More tests => 7;
BEGIN { use_ok('Business::BR::IE', 'parse_ie') };

my ($base, $dv);
my $info;

($base, $dv) = parse_ie('ac', "01.004.823/001-12");
is($base, '01004823001', 'parsing IE-AC works (list context)...');
is($dv, '12', 'parsing IE-AC works (indeed)');

$info = parse_ie('ac', "01.004.823/001-12");
is_deeply($info, { base => '01004823001', dv => '12' }, 
          'parsing IE-AC works (scalar context)');

($base, $dv) = parse_ie('pr', "123.45678-50");
is($base, '12345678', 'parsing IE-PR works (list context)...');
is($dv, '50', 'parsing IE-PR works (indeed)');

$info = parse_ie('pr', "123.45678-50");
is_deeply($info, { base => '12345678', dv => '50' }, 
          'parsing IE-PR works (scalar context)');

# SP ?
