
package Business::BR::IE;

use 5;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw( flatten_ie format_ie parse_ie random_ie );
our @EXPORT = qw( test_ie );

our $VERSION = '0.00_09';

use Business::BR::Ids::Common qw(_dot _flatten);

### AC ###

# http://www.sintegra.gov.br/Cad_Estados/cad_AC.html

sub flatten_ie_ac {
  return _flatten(shift, size => 13);
}
sub test_ie_ac {
  my $ie = flatten_ie_ac shift;
  return undef if length $ie != 13;
  return 0 unless $ie =~ /^01/;
  my @ie = split '', $ie;
  my $s1 = _dot([4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], \@ie) % 11;
  unless ($s1==0 || $s1==1 && $ie[11]==0) {
    return 0;
  }
  my $s2 = _dot([5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2, 1], \@ie) % 11;
  return ($s2==0 || $s2==1 && $ie[12]==0) ? 1 : 0;

}
sub format_ie_ac {
  my $ie = flatten_ie_ac shift;
  $ie =~ s|^(..)(...)(...)(...)(..).*|$1.$2.$3/$4-$5|; # 01.004.823/001-12
  return $ie;
}
sub _dv_ie_ac {
	my $base = shift; # expected to be flattened already ?!
	my $valid = @_ ? shift : 1;
	my $dev = $valid ? 0 : 2; # deviation (to make IE-PR invalid)
	my @base = split '', substr($base, 0, 11);
	my $dv1 = -_dot([4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2], \@base) % 11 % 10;
	my $dv2 = (-_dot([5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2], [ @base, $dv1 ]) + $dev) % 11 % 10;
	return ($dv1, $dv2) if wantarray;
	substr($base, 11, 2) = "$dv1$dv2";
	return $base;
}
sub random_ie_ac {
	my $valid = @_ ? shift : 1; # valid IE-SP by default
	my $base = sprintf "01%09s", int(rand(1E9)); # '01' and 9 digits
	return scalar _dv_ie_ac($base, $valid);
}
sub parse_ie_ac {
  my $ie = flatten_ie_ac shift;
  my ($base, $dv) = $ie =~ /(\d{11})(\d{2})/;
  if (wantarray) {
    return ($base, $dv);
  }
  return { base => $base, dv => $dv };
}


### PR ###

#PR - http://www.fazenda.pr.gov.br/icms/calc_dgv.asp
#     Formato da Inscrição: NNN NNN NN-DD (10 dígitos)
#     Cálculo do Primeiro Dígito: Módulo 11 com pesos de 2 a 7, aplicados da direita para esquerda, sobre as 8 primeiras posições.
#     Cálculo do Segundo Dígito: Módulo 11 com pesos de 2 a 7, aplicados da direita para esquerda, sobre as 9 primeiras posições (inclui o primeiro dígito).
#     Exemplo: CAD 123.45678-50

#PR - http://www.sintegra.gov.br/Cad_Estados/cad_PR.html
#     Formato da Inscrição NNN.NNNNN-DD (1o dígitos) [ NNN NNN NN-DD ]
#     Exemplo: 123.45678-50


sub flatten_ie_pr {
  return _flatten(shift, size => 10);
}
sub test_ie_pr {
  my $ie = flatten_ie_pr shift;
  return undef if length $ie != 10;
  my @ie = split '', $ie;
  my $s1 = _dot([3, 2, 7, 6, 5, 4, 3, 2, 1, 0], \@ie) % 11;
  my $s2 = _dot([4, 3, 2, 7, 6, 5, 4, 3, 2, 1], \@ie) % 11;
  unless ($s1==0 || $s1==1 && $ie[8]==0) {
    return 0;
  }
  return ($s2==0 || $s2==1 && $ie[9]==0) ? 1 : 0;

}
sub format_ie_pr {
  my $ie = flatten_ie_pr shift;
  $ie =~ s|^(...)(.....)(..).*|$1.$2-$4|;
  return $ie;
}
sub _dv_ie_pr {
	my $base = shift; # expected to be flattened already ?!
	my $valid = @_ ? shift : 1;
	my $dev = $valid ? 0 : 2; # deviation (to make IE-PR invalid)
	my @base = split '', substr($base, 0, 8);
	my $dv1 = -_dot([3, 2, 7, 6, 5, 4, 3, 2], \@base) % 11 % 10;
	my $dv2 = (-_dot([4, 3, 2, 7, 6, 5, 4, 3, 2], [ @base, $dv1 ]) + $dev) % 11 % 10;
	return ($dv1, $dv2) if wantarray;
	substr($base, 8, 2) = "$dv1$dv2";
	return $base;
}
sub random_ie_pr {
	my $valid = @_ ? shift : 1; # valid IE-SP by default
	my $base = sprintf "%08s", int(rand(1E8)); # 8 dígitos
	return scalar _dv_ie_pr($base, $valid);
}
sub parse_ie_pr {
  my $ie = flatten_ie_pr shift;
  my ($base, $dv) = $ie =~ /(\d{8})(\d{2})/;
  if (wantarray) {
    return ($base, $dv);
  }
  return { base => $base, dv => $dv };
}

### SP ###

sub flatten_ie_sp {
  return _flatten(shift, size => 12);
}   
#    META:   _flatten($ie_sp, size => 12 )

#SP - http://www.csharpbr.com.br/arquivos/csharp_mostra_materias.asp?escolha=0021
#     Exemplo: Inscrição Estadual 110.042.490.114
#     12 dígitos, 9o. e 12o. são DVs
#     dv[1] = (1, 3, 4, 5, 6, 7, 8, 10) .* (c[1] c[2] c[3] c[4] c[5] c[6] c[7] c[8]) (mod 11)
#     dv[2] = (3 2 10 9 8 7 6 5 4 3 2 1) .* (c[1] ... c[11]) (mod 11)

sub test_ie_sp {
	my $ie = flatten_ie_sp shift;
	return undef if length $ie != 12;
	my @ie = split '', $ie;
	my $s1 = _dot([1, 3, 4, 5, 6, 7, 8, 10, -1, 0, 0, 0], \@ie) % 11;
	unless ($s1==0 || $s1==10 && $ie[8]==0) {
	  return 0;
	}
	my $s2 = _dot([3, 2, 10, 9, 8, 7, 6, 5, 4, 3, 2, -1], \@ie) % 11;
	return ($s2==0 || $s2==10 && $ie[11]==0) ? 1 : 0;

}

sub format_ie_sp {
  my $ie = flatten_ie_sp shift;
  $ie =~ s|^(...)(...)(...)(...).*|$1.$2.$3.$4|;
  return $ie;
}

# my ($dv1, $dv2) = _dv_ie_sp('') # => $dv1 = ?, $dv2 = ?
# my ($dv1, $dv2) = _dv_ie_sp('', 0) # computes non-valid check digits
#
# computes the check digits of the candidate IE-SP number given as argument
# (only the first 12 digits enter the computation) (9th and 12nd are ignored)
#
# In list context, it returns the check digits.
# In scalar context, it returns the complete IE-SP (base and check digits)
sub _dv_ie_sp {
	my $base = shift; # expected to be flattened already ?!
	my $valid = @_ ? shift : 1;
	my $dev = $valid ? 0 : 2; # deviation (to make IE-SP invalid)
	my @base = split '', substr($base, 0, 12);
	my $dv1 = _dot([1, 3, 4, 5, 6, 7, 8, 10, 0, 0, 0, 0], \@base) % 11 % 10;
	my $dv2 = (_dot([3, 2, 10, 9, 8, 7, 6, 5, 0, 3, 2, 0], \@base) + 4*$dv1 + $dev) % 11 % 10;
	return ($dv1, $dv2) if wantarray;
	substr($base, 8, 1) = $dv1;
	substr($base, 11, 1) = $dv2;
	return $base
}

# generates a random (correct or incorrect) IE-SP
# $ie = rand_ie_sp();
# $ie = rand_ie_sp($valid);
#
# if $valid==0, produces an invalid IE-SP
sub random_ie_sp {
	my $valid = @_ ? shift : 1; # correct IE-SP by default
	my $ie = sprintf "%08s0%02s0", int(rand(1E8)), int(rand(1E2)); # 10 dígitos aleatórios
	return scalar _dv_ie_sp($ie, $valid);
}

sub parse_ie_sp {
  my $ie = flatten_ie_sp shift;
  my ($base, $dv) = $ie =~ /(\d{8})(\d{2})/;
  if (wantarray) {
    return ($base, $dv);
  }
  return { base => $base, dv => $dv };
}


# a dispatch table is used here, because we know beforehand 
# the list of Brazilian states. I am not sure it is
# better than using symbolic references.

my %dispatch_table = (
  # AC
  test_ie_ac => \&test_ie_ac, 
  flatten_ie_ac => \&flatten_ie_ac, 
  format_ie_ac => \&format_ie_ac,
  random_ie_ac => \&random_ie_ac,
  parse_ie_ac => \&parse_ie_ac,

  # AL
  # AM
  # AP
  # BA
  # CE
  # DF
  # ES
  # GO
  # MA
  #test_ie_mg => \&test_ie_mg,  # MG
  # MT
  # MS
  # PE
  # PA
  # PB 
  # PI

  # PR
  test_ie_pr => \&test_ie_pr, 
  flatten_ie_pr => \&flatten_ie_pr, 
  format_ie_pr => \&format_ie_pr,
  random_ie_pr => \&random_ie_pr,
  parse_ie_pr => \&parse_ie_pr,

  # RJ
  # RN
  # RO
  # RR
  # RS
  # SC
  # SE

  # SP
  test_ie_sp => \&test_ie_sp, 
  flatten_ie_sp => \&flatten_ie_sp, 
  format_ie_sp => \&format_ie_sp,
  random_ie_sp => \&random_ie_sp,
  #parse_ie_sp

  # TO

);

sub _invoke {
	my $subname = shift;
	my $sub = $dispatch_table{$subname};
    die "$subname not implemented" unless $sub;
	return &$sub(@_);
}

sub test_ie {
	my $uf = lc shift;
	return _invoke("test_ie_$uf", @_);
}
sub flatten_ie {
	my $uf = lc shift;
	return _invoke("flatten_ie_$uf", @_);
}
sub format_ie {
	my $uf = lc shift;
	return _invoke("format_ie_$uf", @_);
}
sub random_ie {
	my $uf = lc shift;
	return _invoke("random_ie_$uf", @_);
}

sub parse_ie {
	my $uf = lc shift;
	return _invoke("parse_ie_$uf", @_);
}



1;

__END__

=head1 NAME

Business::BR::IE - Perl module to test for correct IE numbers

=head1 SYNOPSIS

  use Business::BR::IE qw(test_ie flatten_ie format_ie random_ie); 

  test_ie('sp', '110.042.490.114') # 1
  test_ie('pr', '123.45678-50') # 1
  test_ie('ac', '01.004.823/001-12') # 1


=head1 DESCRIPTION

YET TO COME. Handles IE for the states of Acre (AC),
Sao Paulo (SP) and Paraná (PR) by now.

=back

=head2 EXPORT

C<test_ie> is exported by default. C<flatten_ie>, C<format_ie>,
C<random_ie> and C<parse_ie> can be exported on demand.

=head1 DETAILS

Each state has its own rules for IE numbers. In this section,
we gloss over each one of these

=head2 AC

The state of Acre uses:

=over 4

=item *

13-digits number

=item *

the last two are check digits

=item *

the usual formatting is like C<'01.004.823/001-12'>

=item *

if the IE-AC number is decomposed into digits like this

  a_1 a_2 a_3 a_4 a_5 a_6 a_7 a_8 a_9 a_10 a_11 d_1 d_2

it is correct if

  a_1 a_2 = 0 1

(that is, it always begin with "01") and if it satisfies
the check equations:

  4 a_1 + 3 a_2 + 2 a_3 + 9 a_4  + 8 a_5  + 7 a_6 + 6 a_7 +
                  5 a_8 + 4 a_9 + 3 a_10 + 2 a_11 +   d_1   = 0 or
		                                                    = 1 (if d_1 = 0)

  5 a_1 + 4 a_2 + 3 a_3 + 2 a_4  + 9 a_5  + 8 a_6 + 7 a_7 +
          6 a_8 + 5 a_9 + 4 a_10 + 3 a_11 + 2 d_1 +   d_2  = 0 or
		                                                   = 1 (if d_2 = 0)

=back


=head2 PR

The state of Paraná uses:

  * 10-digits number
  * the 9th and 10th are check digits
  * the usual formatting is like C<'123.45678-50'>

=head2 SP

The state of São Paulo uses:

  * 12-digits number
  * the 9th and 12nd are check digits
  * the usual formatting is like C<'110.042.490.114'>



=head1 BUGS

=over 4

=item *

This documentation is faulty

=item *

If you want handling more than AC, SP and PR, you'll
have to wait for the next releases

=item *

The handling of IE-SP does not include yet 
the special rule for testing correctness of
registrations of rural producers.

=back

=head1 SEE ALSO



Please reports bugs via CPAN RT, 
http://rt.cpan.org/NoAuth/Bugs.html?Dist=Business-BR-Ids
By doing so, the author will receive your reports and patches, 
as well as the problem and solutions will be documented.

=head1 AUTHOR

A. R. Ferreira, E<lt>ferreira@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by A. R. Ferreira

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.


=cut
