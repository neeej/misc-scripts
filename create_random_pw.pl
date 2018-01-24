#!/usr/bin/perl
# -------------------------------------------------------------
#
# Description: Create random password
#
#
# Revision History
# ================
#
# Date       By   Change
# ---------- ---- ---------------------------------------------
# 2013-06-13 mlsd Created
# -------------------------------------------------------------

use warnings;
use strict;
use List::Util 'shuffle';
use Getopt::Std;

my %s = (
  # standard length of password
  "std_length" => "12",

  # Help message
  "help_msg" =>
"usage: $0 [-h] [-l <number>] [-n <number>] [-s] [-d]

-h\t\t\t\thelp
-l <number>\tlenght of password (12 is default)
-s\t\t\t\tuse special characters (!, % or #)
-n <number>\tgenerate this many passwords
-d\t\t\t\tdescribe password

Examples:
  $0
  $0 -l 14
  $0 -l 10 -d -s -n 10
  $0 -l 9 -s\n",
);

# Input options
getopts('l:shdn:');
our ($opt_l, $opt_s, $opt_h, $opt_d, $opt_n);

# Print help message
if ( $opt_h ){
  print $s{"help_msg"};
  exit 2;
}

$opt_n = 1 if !$opt_n or ( $opt_n and $opt_n < 0 );

# all characters
my %characters = (
  numbers => { 
    0 => "zero",
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
  },
  words => { 
    a => "alfa",
    b => "bravo",
    c => "charlie",
    d => "delta",
    e => "echo",
    f => "foxtrot",
    g => "golf",
    h => "hotel",
    i => "india",
    j => "juliett",
    k => "kilo",
    l => "lima",
    m => "mike",
    n => "november",
    o => "oscar",
    p => "pappa",
    q => "quebec",
    r => "romeo",
    s => "sierra",
    t => "tango",
    u => "uniform",
    v => "victor",
    x => "xray",
    y => "yankee",
    z => "zulu",
  },
  WORDS => {
  },
  chars => {
    "_" => "underscore",
    "=" => "equivalent",
  },
  spec => {
    "%" => "procent",
    "!" => "exclamation",
    "#" => "hashtag",
  },
);

my (%newpw,%expl,$count);

my $length = $s{"std_length"};
$length = $opt_l if $opt_l;

# Generate passwords
map {
  %newpw = ();
  %expl = ();
  $count = 0;
  foreach (1..$length){
    $count++;
    my $do;
    if ( $opt_s ){
      $do = shuffle keys %characters;
    } else {
      $do = shuffle ("WORDS", "words", "numbers", "chars");
    }
    &gen_one_string($do);
  }

  &pw_print();
} 1..$opt_n;


sub gen_one_string {
  my $do = shift;
  my $is_uc = 1 if $do eq uc($do);
  $do = lc($do) if $is_uc;
  $newpw{$count} = "".shuffle keys %{$characters{$do}};
  $expl{$count} = $characters{$do}{$newpw{$count}};
  $newpw{$count} = uc($newpw{$count}) if $is_uc;
}

sub pw_print {
  # print password
  print map { $newpw{$_} } sort keys %newpw;
  # print description, if wanted
  if ( $opt_d ){
    print "\t\t[ ";
    my $string = "";
    foreach my $e (sort keys %expl) {
      # check for uppercase words
      if ( $newpw{$e} =~ /[a-z]/i and $newpw{$e} eq uc($newpw{$e}) ){
        $string .= uc($expl{$e})." - ";
      }
      else {
        $string .= $expl{$e}." - ";
      }
    }
    $string =~ s/- $//;
    print "$string]\n";
  }
  else {
    print "\n";
  }
}

