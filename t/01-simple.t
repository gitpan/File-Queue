#!perl -T

use strict;
use Storable qw/freeze/;
use File::Queue;

use Test::Simple tests => 3;

my $queue_file = "test_queue_$$";

my $struct =
[
  'text element 0, text element 0, text element 0, text element 0',
  'text element 1, text element 1, text element 1, text element 1',
  'text element 2, text element 2, text element 2, text element 2',
  'text element 3, text element 3, text element 3, text element 3',
  'text element 4, text element 4, text element 4, text element 4',
  'text element 5, text element 5, text element 5, text element 5',
  'text element 6, text element 6, text element 6, text element 6',
  'text element 7, text element 7, text element 7, text element 7',
  'text element 8, text element 8, text element 8, text element 8',
  'text element 9, text element 9, text element 9, text element 9',
];

my $q = File::Queue->new(File => $queue_file);

foreach my $elem (@$struct)
{
  $q->enq($elem);
}

$q->close;

$q = File::Queue->new(File => $queue_file);

my $peeked = $q->peek(scalar @$struct);

ok(freeze($struct) eq freeze($peeked), 'Checking struct vs peeked');

$q->close;

$q = File::Queue->new(File => $queue_file);

my $deqed;
while(my $elem = $q->deq())
{
  push @$deqed, $elem;
}

ok(freeze($struct) eq freeze($deqed), 'Checking struct vs deqed');

my $delete_success = 1;
eval
{
  $q->delete();
};
if($@)
{
  $delete_success = 0;
}

ok($delete_success, 'Checking delete function');
