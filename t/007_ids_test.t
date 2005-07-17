
use Test::More tests => 6;
BEGIN { use_ok('Business::BR::Ids') };

ok(test('cpf', '56451416010'), "works for good CPF");
ok(!test('cpf', '231.002.999-00'), "works for bad CPF");

ok(test('cnpj', '90.117.749/7654-80'), "works for good CNPJ");
ok(!test('cnpj', '88.222.111/0001-10'), "works for bad CNPJ");

ok(test('ie', 'pr', '123.45678-50'), "works for good IE");

