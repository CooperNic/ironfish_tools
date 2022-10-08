#!/usr/bin/perl

use warnings;

$FLAG_RUNNING = "$ENV{HOME}/script_running.lock";
if ( -f $FLAG_RUNNING ) {
  die "Previous script is running!\n";
}
open(F,'>',$FLAG_RUNNING) or die "Cannot open $FLAG_RUNNING: $!";
print F "$$\n";
close(F);

my $s = "";
my $deposit_result = "";
my $transactions_amount = 0;
my $dt = "";
my $DELAY = 120;

$s = `/usr/bin/docker run --rm --tty --network host --volume $ENV{HOME}/.ironfish:/root/.ironfish ghcr.io/iron-fish/ironfish:latest accounts:balance`;
$s =~ s/^.*Balance\: \$IRON\s+(.*?)\s.*$/$1/sm;

$transactions_amount = int($s/(0.1+0.00000001));

$dt = `date --rfc-3339=seconds`;
$dt =~ s/\n$//;

print $dt . " Balance=". $s . " | " . "Transactions=". $transactions_amount . "\n";
# the temporary block of code because ironfish deposit command taking a long time 
if ($transactions_amount>1) { $transactions_amount= 1;}
for($i=1; $i<=$transactions_amount; $i++)
{
    $deposit_result = `docker run --rm --tty --network host --volume $ENV{HOME}/.ironfish:/root/.ironfish ghcr.io/iron-fish/ironfish:latest deposit --confirm`;
    $deposit_result =~ s/^.*Transaction Hash\:\s+(.*?)\n.*$/$1/sm;
    $dt = `date --rfc-3339=seconds`;
    $dt =~ s/\n$//;

    print "$dt $i: " . " Hash - " . $deposit_result . "\n";
    sleep($DELAY);
}

if ($transactions_amount > 0)
{
    sleep($DELAY);
    $s = `docker run --rm --tty --network host --volume $ENV{HOME}/.ironfish:/root/.ironfish ghcr.io/iron-fish/ironfish:latest accounts:balance`;
    $s =~ s/^.*Balance\: \$IRON\s+(.*?)\s.*$/$1/sm;
    $dt = `date --rfc-3339=seconds`;
    $dt =~ s/\n$//;
    print $dt . " Balance=". $s . "\n";
}
unlink $FLAG_RUNNING;
