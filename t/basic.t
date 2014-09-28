use Test::More;
use strict; use warnings FATAL => 'all';

use Convert::Z85;

{
  my $bin = "\x86\x4F\xD2\x6F\xB5\x59\xF7\x5B";
  my $str = "HelloWorld";

  cmp_ok encode_z85($bin), 'eq', $str, 'encode_z85 ok';
  cmp_ok decode_z85($str), 'eq', $bin, 'decode_z85 ok';
}

{
  my $bin =
     "\xBB\x88\x47\x1D\x65\xE2\x65\x9B"
    ."\x30\xC5\x5A\x53\x21\xCE\xBB\x5A"
    ."\xAB\x2B\x70\xA3\x98\x64\x5C\x26"
    ."\xDC\xA2\xB2\xFC\xB4\x3F\xC5\x18"
  ;
  my $str = 'Yne@$w-vo<fVvi]a<NY6T1ed:M$fCG*[IaLV{hID';

  cmp_ok encode_z85($bin), 'eq', $str, 'encode_z85 on key ok';
  cmp_ok decode_z85($str), 'eq', $bin, 'decode_z85 on key ok';
}

done_testing
