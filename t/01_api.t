use strict;
use warnings;

use Test::More;
my $tests;
plan tests => $tests;

use Log::Dispatch::Email::EmailSender;

BEGIN { $tests = 2; }

ok(defined $Log::Dispatch::Email::EmailSender::VERSION);
ok($Log::Dispatch::Email::EmailSender::VERSION =~ /^\d{1}.\d{6}$/);

BEGIN { $tests += 1; }

can_ok('Log::Dispatch::Email::EmailSender', qw(new send_email));
