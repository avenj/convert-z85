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

my @multiples = reverse map {; 85 ** $_ } 0 .. 4;

sub encode_z85 {
  my ($bin, %param) = @_;

  my $len = bytes::length($bin);
  if ($param{pad}) {
    $bin .= "\0" x (-$len % 4);
    $len = bytes::length($bin);
  }
  croak "Expected data padded to 4-byte chunks; got length $len" if $len % 4;

  my $chunks = $len / 4;
  my @values = unpack "(N)$chunks", $bin;
  
  my $str;
  for my $val (@values) {
    $str .= $chrs[ ( int($val / $_) ) % 85 ] for @multiples;
  }
  
  $str
}

sub decode_z85 {
  my ($txt, %param) = @_;
  my $len = length $txt;

  croak "Expected Z85 text in 5 byte chunks; got length $len" if $len % 5;

  my @values;
  for my $idx (grep {; not($_ % 5) } 0 .. $len) {
    my ($val, $cnt) = (0, 0);

    for my $mult (@multiples) {
      my $chr = substr $txt, ($idx + $cnt), 1;
      last unless length $chr;
      croak "Invalid Z85 input; '$chr' not recognized"
        unless exists $intforchr{$chr};
      $val += $intforchr{$chr} * $mult;
      ++$cnt;
    }

    push @values, $val;
  }

  my $chunks = $len / 5;
  my $ret = pack "(N)$chunks", @values;
  $ret =~ s/\0{0,3}$// if $param{pad};
  $ret
}


1;

=pod

=head1 NAME

Convert::Z85 - Encode and decode Z85 strings

=head1 SYNOPSIS

  use Convert::Z85;

  my $encoded = encode_z85($binarydata);
  my $decoded = decode_z85($encoded);

=head1 DESCRIPTION

An implementation of the I<Z85> encoding scheme (as described in
L<ZeroMQ spec 32|http://rfc.zeromq.org/spec:32>) for encoding binary data as
plain text.

Modelled on the L<PyZMQ|http://zeromq.github.io/pyzmq/> implementation.

This module uses L<Exporter::Tiny> to export two functions by default:
L</encode_z85> and L</decode_z85>. L<Exporter::Tiny> provides flexible import
options; look there for details.

=head2 encode_z85

  my $z85 = encode_z85($data);

Takes binary data in 4-byte chunks and returns a Z85-encoded text string.

Per the spec, padding is not performed automatically; the B<pad> option can be
specified to pad data with trailing zero bytes:

  my $z85 = encode_z85($data, pad => 1);

=head2 decode_z85

  my $bin = decode_z85($encoded);

Takes a Z85 text string and returns the original binary data.

Throws a stack trace if invalid data is encountered.

Per the spec, removing padding is not performed automatically; the B<pad>
option can be specified to remove trailing zero bytes:

  my $bin = decode_z85($encoded, pad => 1);

=head1 SEE ALSO

L<Convert::Ascii85>

L<POEx::ZMQ>

L<ZMQ::FFI>

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
