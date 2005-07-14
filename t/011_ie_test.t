
use Test::More tests => 12;
BEGIN { use_ok('Business::BR::IE', 'test_ie') };

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

