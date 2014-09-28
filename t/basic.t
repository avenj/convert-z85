use Test::More;
use strict; use warnings FATAL => 'all';

use Convert::Z85;

{
  my $bin = "\x86\x4F\xD2\x6F\xB5\x59\xF7\x5B";
  my $str = "HelloWorld";

  cmp_ok encode_z85($bin), 'eq', $str, 'encode_z85 1 ok';
  cmp_ok decode_z85($str), 'eq', $bin, 'decode_z85 1 ok';
}

{
  my $bin =
     "\xBB\x88\x47\x1D\x65\xE2\x65\x9B\x30\xC5\x5A\x53\x21\xCE\xBB\x5A"
    ."\xAB\x2B\x70\xA3\x98\x64\x5C\x26\xDC\xA2\xB2\xFC\xB4\x3F\xC5\x18"
  ;
  my $str = 'Yne@$w-vo<fVvi]a<NY6T1ed:M$fCG*[IaLV{hID';

  cmp_ok encode_z85($bin), 'eq', $str, 'encode_z85 2 ok';
  cmp_ok decode_z85($str), 'eq', $bin, 'decode_z85 2 ok';
}

{
  my $bin =
    "\x8E\x0B\xDD\x69\x76\x28\xB9\x1D\x8F\x24\x55\x87\xEE\x95\xC5\xB0"
    ."\x4D\x48\x96\x3F\x79\x25\x98\x77\xB4\x9C\xD9\x06\x3A\xEA\xD3\xB7"
  ;
  my $str = 'JTKVSB%%)wK0E.X)V>+}o?pNmC{O&4W4b!Ni{Lh6';

  cmp_ok encode_z85($bin), 'eq', $str, 'encode_z85 3 ok';
  cmp_ok decode_z85($str), 'eq', $bin, 'decode_z85 3 ok';
}

done_testing
