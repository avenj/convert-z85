use Test::More;
use strict; use warnings FATAL => 'all';

use Capture::Tiny 'capture';

my ($out, $err, $status) = capture {
  system( $^X, 'bin/z85_convert', '--help' )
};

like $out, qr/z85_convert/, '--help output looks ok';
ok !$err, 'no stderr on --help';

## FIXME better tests, roundtrip some input on stdio

done_testing
