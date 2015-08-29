unit module Main;
use Runaway;

our $a = 5;

runaway-with {
  loop {
    say "\$a is currently $a";
    sleep 2;
  }
};
