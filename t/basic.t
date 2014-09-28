use Test::More;
use strict; use warnings FATAL => 'all';

use Convert::Z85;

{
  my $bin = "\x86\x4F\xD2\x6F\xB5\x59\xF7\x5B";
  my $str = "HelloWorld";

  cmp_ok encode_z85($bin), 'eq', $str, 'encode_z85 ok';
  cmp_ok decode_z85($str), 'eq', $bin, 'decode_z85 ok';
}

done_testing
