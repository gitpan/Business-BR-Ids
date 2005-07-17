
package Business::BR::Ids;

use 5;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw( flatten parse format random );
our @EXPORT = qw( test );

our $VERSION = '0.00_09';

use Carp;

# a hash from entity types to packages
my %types = (
  cpf => 'Business::BR::CPF',
  cnpj => 'Business::BR::CNPJ',
  ie => 'Business::BR::IE',
);


# invoke($type, $subroot, @args)
sub _invoke {
	my $type = lc shift;
	my $subroot = shift;
	my $package = $types{$type}
		or croak "unknown '$type'\n";
	eval "require $package";
	no strict 'refs';
	return &{"${package}::${subroot}${type}"}(@_);
}

sub test {
	return _invoke(shift, 'test_', @_);
}

sub flatten {
	return _invoke(shift, 'flatten_', @_);
}

# PROBLEM: format is builtin - needs a work around
#sub format {
#	return _invoke(shift, 'format_', @_);
#}

sub parse {
	return _invoke(shift, 'parse_', @_);
}

sub random {
	return _invoke(shift, 'random_', @_);
}

1;

__END__

=head1 NAME

Business::BR::Ids - Modules for dealing with Brazilian identification codes (CPF, CNPJ, ...)

=head1 SYNOPSIS

  use Business::BR::Ids;
  my $cpf = '390.533.447-05';
  print "ok as CPF" if test('cpf', $cpf);
  my $cnpj = '90.117.749/7654-80';
  print "ok as CNPJ" if test('cnpj', $cnpj);

=head1 DESCRIPTION

This is a generic module for handling the various supported
operations on Brazilian identification numbers and codes.
For example, it is capable to test the correctness of CPF,
CNPJ and IE numbers without the need for explicitly 'requiring' or
'using' this modules (doing it automatically on demand).

=over 4

=item B<test>

  test($entity_type, @args); 
  test('cpf', $cpf); # the same as "require Business::BR::CPF; Business::BR::CPF::test_cpf($cpf)"

Tests for correct inputs of ids which have a corresponding Business::BR module.
For now, the supported id types are 'cpf', 'cnpj', and 'ie'.

=head2 EXPORT

C<test> is exported by default. C<flatten>, 
C<parse> and C<random> are exported on demand.

=begin comment

 =head1 OVERVIEW

 test_*
 flatten_*
 format_*
 parse_*
 random_*
 
 =head1 ETHICS

 The facilities provided here can be used for bad purposes,
 like generating correct codes for trying frauds.
 This is specially true of the C<random_*()> functions.
 But anyway with only C<test_*()> functions, it is also very
 easy to try typically 100 choices and find a correct
 code as well. 

 Unethical programmers (as any unethical people) should not be 
 a reason to conceal things (like code) that can benefit
 a community. And I felt that this kind of code sometimes
 is hidden by other wrong reasons: to keep such a knowledge
 restricted to a group of people wanting to make money of it.
 But this is (or should be) public information.

 If institutions were really worried about this, they
 should publish validation equations like the ones
 listed in the documentation here instead of computation
 algorithms for check digits. If one does not know enough
 math to solve the equations, probably
 they don't need the solutions anyway. 

 For modules on this distribution, only correctness is tested.
 For doing business, usually codes must be verified 
 against the databases of the information owners, usually
 government bodies. 


=end comment

=head1 SEE ALSO

Details on handling CPF, CNPJ and IE can be found in
the specific modules:

=over 4

=item *

CPF - Business::BR::CPF

=item *

CNPJ - Business::BR::CNPJ

=item *

IE - Business::BR::IE

=back

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
