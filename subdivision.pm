package subdivision;
use strict;
use warnings;
use LWP::Simple;  # get(url)


#  ~~~~~~~ VERSIONS~~~~~~~~
#  01.03.2013 : Création.
#  ~~~~~~~ VERSIONS~~~~~~~~
#
#  romain.vanel@gmail.com
#  rugbis@ujf-grenoble.fr



=head1 NAME

subdivision.pm
=cut

=head1 DESCRIPTION
A partir d'IdRef, vérifie si une vedette Rameau (suposée tête de vedette) n'est pas utilisable seulement en subdivision 
Vérification à partir du PPN de la vedette Rameau.


=cut

=head1 UTILISATION

my $resultat_subdivision = subdivision::autorite($ppn_autorite);

Deux résultats possibles :
"OK" : la vedette peut être employée en tête de vedette
"Ne peut pas être employé en tête de vedette"

=cut

=head1 LICENCE

GNU/GPL

=cut


my $url_abes = "http://www.idref.fr/";
my $extension = ".xml";

#------------------------------------------------------------------------------
sub autorite {
  my ($auto_a_chercher) = @_ ;
  my $auto = $auto_a_chercher;
    chomp($auto) ;
my $url_creee = $url_abes . $auto . $extension;
my $page_idref = &downloader_de_page($url_creee);
my $subdiv = chercheur_subdiv($page_idref);
  if ($subdiv) {
    return "Ne peut pas être employé en tête de vedette"
    }
  else {
    return "OK"
    }
}

#------------------------------------------------------------------------------
sub downloader_de_page {
  my ($url) = @_ ;
  if (my $page = get($url)) {
    return $page;
	  }
  else {
    return 0;
    };
} 


#------------------------------------------------------------------------------
sub chercheur_subdiv {
  my ($brut) = @_ ;
  $brut =~ s/\n//g ;
  $brut =~ s/\/datafield>/\/datafield>\n/g;
  my @brit = split /\n/, $brut;
  my @res = grep { $_ =~ /106/} @brit;

for my $ligne_res (@res) {
  if ($ligne_res =~ /"b">2</) {
    return 1
     }
  else {
    return 0
   }
  }
}