
use Test::More tests => 28;
BEGIN { use_ok('Business::BR::IE', 'test_ie') };

ok(test_ie('ac', '01.004.823/001-12'), '"01.004.823/001-12" is a correct IE-AC');

ok(!test_ie('ac', '01.004.823/001-02'), '"01.004.823/001-02" is an incorrect IE-AC');
ok(!test_ie('ac', '01.004.823/001-13'), '"01.004.823/001-13" is an incorrect IE-AC');

ok(test_ie('al', '24.000.004-8'), '"24.000.004-8" is a correct IE-AL');

ok(test_ie('ma', '12.000.038-5'), '"12.000.038-5" is a correct IE-MA');

ok(test_ie('rr', '24006628-1'), '"24006628-1" is a correct IE-RR');
ok(test_ie('rr', '24001755-6'), '"24001755-6" is a correct IE-RR');
ok(test_ie('rr', '24003429-0'), '"24003429-0" is a correct IE-RR');
ok(test_ie('rr', '24001360-3'), '"24001360-3" is a correct IE-RR');
ok(test_ie('rr', '24008266-8'), '"24008266-8" is a correct IE-RR');
ok(test_ie('rr', '24006153-6'), '"24006153-6" is a correct IE-RR');
ok(test_ie('rr', '24007356-2'), '"24007356-2" is a correct IE-RR');
ok(test_ie('rr', '24005467-4'), '"24005467-4" is a correct IE-RR');
ok(test_ie('rr', '24004145-5'), '"24004145-5" is a correct IE-RR');
ok(test_ie('rr', '24001340-7'), '"24001340-7" is a correct IE-RR');

ok(test_ie('pr', '123.45678-50'), '"123.45678-50" is a correct IE-PR');

ok(test_ie('sp', '110.042.490.114'), '"110.042.490.114" is a correct IE-SP');
ok(test_ie('sp', '645.095.752.110'), '"645.095.752.110" is a correct IE-SP');

ok(!test_ie('sp', '110.042.490.110'), '"110.042.490.110" is an incorrect IE-SP');
ok(!test_ie('sp', '110.042.490.111'), '"110.042.490.111" is an incorrect IE-SP');
ok(!test_ie('sp', '110.042.490.112'), '"110.042.490.112" is an incorrect IE-SP');
ok(!test_ie('sp', '110.042.490.113'), '"110.042.490.113" is an incorrect IE-SP');
ok(!test_ie('sp', '110.042.490.115'), '"110.042.490.115" is an incorrect IE-SP');
ok(!test_ie('sp', '110.042.490.116'), '"110.042.490.116" is an incorrect IE-SP');
ok(!test_ie('sp', '110.042.490.117'), '"110.042.490.117" is an incorrect IE-SP');
ok(!test_ie('sp', '110.042.490.118'), '"110.042.490.118" is an incorrect IE-SP');
ok(!test_ie('sp', '110.042.490.119'), '"110.042.490.119" is an incorrect IE-SP');


