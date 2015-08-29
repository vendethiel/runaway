unit module Runaway;
use GTK::Simple;
use CapturingOutput;

sub start-program(&code) {
  my $capturing-out = CapturingOutput.new;
  start {
    my $*OUT = $capturing-out;
    code();
    CATCH { !!! "Restart, resume, crash, yada yada yada" }
  };
  $capturing-out
}

sub runaway-with(&code) is export {
  my GTK::Simple::App $app .= new(:title<Runaway>);
  $app.set_content(
    GTK::Simple::VBox.new(
      GTK::Simple::Label.new(text => 'Enter REPL code'),
      my $repl-input = GTK::Simple::TextView.new(),
      GTK::Simple::Label.new(text => 'REPL Output'),
      my $repl-output = GTK::Simple::TextView.new(),
      GTK::Simple::Label.new(text => 'Program Output'),
      my $program-output = GTK::Simple::TextView.new(),
    )
  );

  # tie in the user's program
  start-program(&code).supply.schedule_on(GTK::Simple::Scheduler).tap({
  #start-program(&code).supply.tap({
      $program-output.text ~= $_;
  });

  # read REPL input, tie it to the output
#  Supply.from-list($repl-input).tap(-> $line {
#    
#  }).migrate.schedule_on(
#    GTK::Simple::Scheduler
#  ).tap({
#    $repl-output.text ~= $_;
#  });

  # off we go! weeeeh!
  $app.run
}
