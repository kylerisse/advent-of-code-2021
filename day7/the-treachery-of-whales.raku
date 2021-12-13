#!/usr/bin/env raku

use experimental :cached;

sub fuelCost(Int @values, Int $target) returns Int {
    return sum(map(-> $x {max($target, $x) - min($target, $x)}, @values));
}

sub firstHalf($data) returns Int {
    my @rawData = split(",", $data);
    my Int @locations;
    map(-> $x {@locations.push($x.Int)}, @rawData);
    my Int $bestResult = -1;
    for @locations -> $num {
        my $fc = fuelCost(@locations, $num);
        if $bestResult > $fc || $bestResult == -1 {
            $bestResult = $fc;
        }
    }
    return $bestResult;
}

sub fuelCostExp(Int @values, Int $target) returns Int {
    return sum(map(-> $x {expCost(max($target, $x) - min($target, $x))}, @values));
}

sub expCost(Int $n) returns Int is cached {
    if $n == 0 {
        return 0;
    }
    if $n == 1 {
        return 1;
    }
    return $n + expCost($n - 1);
}

sub secondHalf($data) returns Int {
    my @rawData = split(",", $data);
    my Int @locations;
    map(-> $x {@locations.push($x.Int)}, @rawData);
    my Int $bestResult = -1;
    for [0 .. max(@locations)] -> $num {
        my $fc = fuelCostExp(@locations, $num);
        if $bestResult > $fc || $bestResult == -1 {
            $bestResult = $fc;
        }
    }
    return $bestResult;
}

sub MAIN(
    Str :f($file),
){
    my $data = slurp $file;
    say "first half: " ~ firstHalf($data);
    say "second half: { secondHalf($data) }"
}
