
package Business::BR::Ids::Common;

use 5;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

#our %EXPORT_TAGS = ( 'all' => [ qw() ] );
#our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
#our @EXPORT = qw();

our @EXPORT_OK = qw( _dot _canon_i );

our $VERSION = '0.00_10';

sub _dot {
  my $a = shift;
  my $b = shift;
  warn "arguments a and b should have the same length"
	unless (@$a==@$b);
  my $s = 0;
  for ( my $i=0; $i<@$a; $i++ ) {
	my ($x, $y) = ($a->[$i], $b->[$i]);
	if ($x && $y) {
	   $s += $x*$y;
	}
  }
  return $s;
}

use Scalar::Util qw(looks_like_number); 

# usage: _canon_i($piece, size => 12)
sub _canon_i {
  my $piece = shift;
  my %options = @_;
  if (looks_like_number($piece) && int($piece)==$piece) {
	  return sprintf('%0*s', $options{size}, $piece)
  } else {
	  $piece =~ s/\D//g;
	  return $piece;
  }
}   


1;

__END__

=head1 NAME

Business::BR::Ids::Common - Common code used in Business-BR-Ids modules

=head1 SYNOPSIS

  use Business::BR::Ids::Common qw(_dot _canon_i);
  my @digits = (1, 2, 3, 3);
  my @weights = (2, 3, 2, 2);
  my $dot = _dot(\@weights, \@digits); # computes 2*1+3*2+3*2+2*3

  _canon_i(342222, size => 7); # returns '0342222'
  _canon_i('12.28.8', size => 5); # returns '12288'



=head1 DESCRIPTION

This module is meant to be private for Business-BR-Ids distributions.
It is a common placeholder for code which is shared among
other modules of the distribution.

Actually, the only code here is the computation of the
scalar product between two array refs. In the future,
this module can disappear being more aptly named and
even leave the Business::BR namespace.

=over 4

=item B<_dot>

  $s = _dot(\@a, \@b);

Computes the scalar (or dot) product of two array refs:

   sum( a[i]*b[i], i = 0..$#a )

Note that due to this definition, the second argument 
should be at least as long as the first argument.

=item B<_canon_i>

  $qs = _canon_i($s, size => 8)

If the argument is a number, formats it to the specified
size. Then, strips any non-digit character. If the
argument is a string, it just strips non-digit characters.

=back

=head2 EXPORT

None by default. 

You can explicitly ask for C<_dot()> which
is a sub to compute the dot product between two array refs
(used for computing check digits). There is also
C<_canon_i> to be exported on demand.


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
