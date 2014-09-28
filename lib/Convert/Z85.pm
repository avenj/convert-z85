package Convert::Z85;

use Carp;
use strictures 1;

use parent 'Exporter::Tiny';
our @EXPORT = our @EXPORT_OK = qw/
  encode_z85
  decode_z85
/;

require bytes;

my @chrs = split '',
  '0123456789abcdefghijklmnopqrstuvwxyz'
 .'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 .'.-:+=^!/*?&<>()[]{}@%$#'
;

my %intforchr = map {; $chrs[$_] => $_ } 0 .. $#chrs;

my @offsets = reverse map {; 85 ** $_ } 0 .. 4;

sub encode_z85 {
  my $bin = shift;
  my $len = bytes::length($bin);
  croak "Expected data padded to 4-byte chunks; got length $len" if $len % 4;

  my $chunks = $len / 4;
  my @values = unpack "(N)$chunks", $bin;
  
  my $str;
  for my $val (@values) {
    for my $offset (@offsets) {
      $str .= $chrs[ ( int($val / $offset) ) % 85 ]
    }
  }
  
  $str
}

sub decode_z85 {
  my $txt = shift;
  my $len = length $txt;
  croak "Expected Z85 text in 5 char chunks; got length $len" if $len % 5;

  my $chunks = $len / 5;
  my @values;

  for my $idx (grep {; not($_ % 5) } 0 .. $len) {
    my $val = 0;
    my $cnt = 0;
    for my $offset (@offsets) {
      my $chr = substr $txt, ($idx + $cnt), 1;
      last if ord($chr) == 0;
      $val += $intforchr{$chr} * $offset;
      ++$cnt;
    }
    push @values, $val;
  }

  pack "(N)$chunks", @values
}


1;

=pod


=cut
