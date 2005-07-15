
package Business::BR::IE;

use 5;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw( flatten_ie format_ie parse_ie random_ie );
our @EXPORT = qw( test_ie );

our $VERSION = '0.00_07';

use Business::BR::Ids::Common qw(_dot _flatten);

#sub test_ie_mg {
#	my $ie = shift;
#	return 1;
#}

### PR ###

#PR - http://www.fazenda.pr.gov.br/icms/calc_dgv.asp
#     Formato da Inscri��o: NNN NNN NN-DD (10 d�gitos)
#     C�lculo do Primeiro D�gito: M�dulo 11 com pesos de 2 a 7, aplicados da direita para esquerda, sobre as 8 primeiras posi��es.
#     C�lculo do Segundo D�gito: M�dulo 11 com pesos de 2 a 7, aplicados da direita para esquerda, sobre as 9 primeiras posi��es (inclui o primeiro d�gito).
#     Exemplo: CAD 123.45678-50

#PR - http://www.sintegra.gov.br/Cad_Estados/cad_PR.html
#     Formato da Inscri��o NNN.NNNNN-DD (1o d�gitos) [ NNN NNN NN-DD ]
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
	my $base = sprintf "%08s", int(rand(1E8)); # 8 d�gitos
	return _dv_ie_pr($base, $valid);
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
  #my $ie_sp = shift;
  #if (looks_like_number($ie_sp) && int($ie_sp)==$ie_sp) {
  #	  return sprintf('%012s', $ie_sp)
  #}
  #$ie_sp =~ s/\D//g;
  #return $ie_sp;
  return _flatten(shift, size => 12);
}   
#    META:   _flatten($ie_sp, size => 12 )

#SP - http://www.csharpbr.com.br/arquivos/csharp_mostra_materias.asp?escolha=0021
#     Exemplo: Inscri��o Estadual 110.042.490.114
#     12 d�gitos, 9o. e 12o. s�o DVs
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
	#return "$dv1$dv2";
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
	my $ie = sprintf "%08s0%02s0", int(rand(1E8)), int(rand(1E2)); # 10 d�gitos aleat�rios
	#print "# IE-SP: $ie\n";
	#my ($dv1, $dv2) = _dv_ie_sp($ie, $valid);
	#substr($ie, 8, 1) = $dv1;
	#substr($ie, 11, 1) = $dv2;
	#return $ie;
	return _dv_ie_sp($ie, $valid);
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

sub parse_ie;



1;

__END__

=head1 NAME

Business::BR::IE - Perl module to test for correct IE numbers

=head1 SYNOPSIS

  use Business::BR::IE qw(test_ie flatten_ie format_ie random_ie); 

  test_ie('sp', '110.042.490.114') # 1
  test_ie('pr', '123.45678-50') # 1


=head1 DESCRIPTION

YET TO COME. Handles IE for the states of Sao Paulo (SP) 
and Paran� (PR) by now.

=back

=head2 EXPORT

C<test_ie> is exported by default. C<flatten_ie>, C<format_ie>,
C<random_ie> and C<parse_ie> can be exported on demand.

=head1 DETAILS

Each state has its own rules for IE numbers. In this section,
we gloss over each one of these

=head2 PR

The state of Paran� uses:

  * 10-digits number
  * the 9th and 10th are check digits
  * the usual formatting is like C<'123.45678-50'>

=head2 SP

The state of S�o Paulo uses:

  * 12-digits number
  * the 9th and 12nd are check digits
  * the usual formatting is like C<'110.042.490.114'>



=head1 BUGS

dunno

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