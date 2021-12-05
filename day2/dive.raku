#!/usr/bin/env raku

class Location {
    has $.x = 0;
    has $.depth = 0;
    has $.aim = 0;
}

sub move(Location $loc, Str $command, Int $value) {
    given $command {
        when "forward" {
            return Location.new(x => $loc.x + $value, depth => $loc.depth);
        }
        when "down" {
            return Location.new(depth => $loc.depth + $value, x => $loc.x);
        }
        when "up" {
            return Location.new(depth => $loc.depth - $value, x => $loc.x);
        }
    }
}

sub movewithaim(Location $loc, Str $command, Int $value) {
    given $command {
        when "forward" {
            return Location.new(
                x => $loc.x + $value,
                depth => $loc.depth + ($loc.aim * $value),
                aim => $loc.aim,
            );
        }
        when "down" {
            return Location.new(
                depth => $loc.depth,
                x => $loc.x,
                aim => $loc.aim + $value,
            );
        }
        when "up" {
            return Location.new(
                depth => $loc.depth,
                x => $loc.x,
                aim => $loc.aim - $value
            );
        }
    }
}

sub multposdepth(Location $loc) {
    return $loc.x * $loc.depth;
}

sub movesub(@commands) {
    my $sub = Location.new();
    for @commands -> $command {
        my @parsed = split(" ", $command);
        $sub = move($sub, @parsed[0], Int(@parsed[1]));
    }
    return multposdepth($sub);
}

sub movesubwithaim(@commands) {
    my $sub = Location.new();
    for @commands -> $command {
        my @parsed = split(" ", $command);
        $sub = movewithaim($sub, @parsed[0], Int(@parsed[1]));
    }
    return multposdepth($sub);
}

sub MAIN(
    Str :f($file), #= input file
){
    my $data = slurp $file;
    my $result1 = movesub($data.lines);
    say "first half: $result1";
    my $result2 = movesubwithaim($data.lines);
    say "second half: $result2";
}
