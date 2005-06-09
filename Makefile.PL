
use 5;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Business-BR-Ids',
    VERSION_FROM      => 'lib/Business/BR/Ids.pm', # finds $VERSION
    PREREQ_PM         => {
		Scalar::Util => 0, 
		Test::More   => 0, 
	}, 
    ($] >= 5.005 ?     
      (#ABSTRACT  => 'Modules for dealing with Brazilian identification codes (CPF, CNPJ, ...)',
	   ABSTRACT_FROM => 'lib/Business/BR/Ids.pm',
       AUTHOR         => 'A. R. Ferreira <ferreira@cpan.org>') : ()),
	NO_META => 1,
);
