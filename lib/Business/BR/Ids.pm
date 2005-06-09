
package Business::BR::Ids;

use 5;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
#our %EXPORT_TAGS = ( 'all' => [ qw() ] );
#our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw( test );

our $VERSION = '0.00_04';

use Carp;

# a hash from entity types to packages
my %types = (
  cpf => 'Business::BR::CPF',
  cnpj => 'Business::BR::CNPJ',
);

sub test {
	my $type = lc shift;
	my $package = $types{$type} 
		or croak "unknown '$type'\n";
	eval "require $package";
	no strict 'refs';
	return &{"${package}::test_${type}"}(@_);
}

1;

__END__

=head1 NAME

Business::BR::Ids - Modules for dealing with Brazilian identification codes (CPF, CNPJ, ...)

=head1 SYNOPSIS

  use Business::BR::Ids;
  my $cpf = '';
  print "$cpf as CPF is ", (test('cpf', '') ? "ok" : "not ok"), "\n";
  my $cnpj = '';
  print "$cnpj as CNPJ is ", (test('cnpj', '') ? "ok" : "not ok"), "\n";

=head1 DESCRIPTION

This is a generic module for handling the various supported
operations on Brazilian identification numbers and codes.
For example, it is capable to test the correctness of CPF
and CNPJ numbers without the need for explicitly 'requiring' or
'using' this modules (doing it automatically on demand).

=over 4

=item B<test>

  test($entity_type, @args); 
  test('cpf', $cpf); # the same as "require Business::BR::CPF; Business::BR::CPF::test_cpf($cpf)"

Tests for correct inputs of ids which have a corresponding Business::BR module.
For now, the supported id types are 'cpf' and 'cnpj'.

=head2 EXPORT

C<test> is exported by default. 

=begin comment

 =head1 OVERVIEW

 test_*
 flatten_*
 format_*
 parse_*
 rand_*
 
 =head1 ETHICS



=end comment

=head1 SEE ALSO

Please reports bugs via CPAN RT, 
http://rt.cpan.org/NoAuth/Bugs.html?Dist=Business-BR-Ids

=head1 AUTHOR

A. R. Ferreira, E<lt>ferreira@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by A. R. Ferreira

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.


=cut
