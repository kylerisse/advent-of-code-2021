#!/usr/bin/env raku

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

sub MAIN(
    Str :f($file),
){
    my $data = slurp $file;
    say "first half: " ~ firstHalf($data);
}
