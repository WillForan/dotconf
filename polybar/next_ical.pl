#!/usr/bin/env perl
use v5.38;
use Date::ICal;
use DateTime;

my @events; my %event;
my $now = Date::ICal->new(epoch=>time);

# /home/foranw/.calendars/upmc/26cffd1a-f8fe-4516-8fd2-d2aae9eb44a0.ics
for my $ical_file (glob("/home/foranw/.calendars/{upmc,gcal_frc}/*.ics")) {
  open(my $ical, "<", $ical_file) or die "$!";
  while($_=<$ical>){
    %event=() if /BEGIN:VEVENT/;
    if(/DTSTART(;.*?)?:(.*)/){ #16010101T020000
	    ## from Date::ICal
            #( $year, $month, $day, $hour, $min, $sec, $zflag ) =
            #  $2 =~ /^(?:(\d{4})(\d\d)(\d\d))
            #          (?:T(\d\d)?(\d\d)?(\d\d)?)?
            #          (Z)?$/x;
	    $event{start} = Date::ICal->new(ical=>$2);
	    $event{sec_from_now} =  $event{start}->epoch - $now->epoch;
    }
    $event{summary}=$2 if /SUMMARY(;LANGUAGE=.*?)?:(.*)/;
    push(@events, {%event}) if(/END:VEVENT/ and $event{sec_from_now} > 0);
  }
  close $ical;
}

# did we read anything?
exit 1 if $#events < 0;

# sort by what's happening closest to now
my @sorted_events = sort {$a->{sec_from_now} <=> $b->{sec_from_now}} @events;

if("@ARGV"=~m/act/){
 system('notify-send "hi"');
 exit 0;
}

# minutes until the next 3 upcoming events
# also display time and summary of soonest
my $upcomming = join(",", map {sprintf("%.0f",$_->{sec_from_now}/60)} @sorted_events[0..2]);
my $e = $sorted_events[0];
my $start = DateTime->from_epoch($e->{start}->epoch)->strftime("%a %d %I:%M");

# for polybar: invert color and put a red underline if event is upcomming (15 min)
print "%{R}%{u#ff0000}%{+u}" if "@ARGV"=~m/polybar/ and $sorted_events[0]->{sec_from_now} < 15*60;
say "($upcomming) $start $e->{summary}";

