#!/usr/bin/env raku

class Point {
    has Int $.x;
    has Int $.y;
}

class LineSegment {
    has Point $.a;
    has Point $.b;
}

sub isHorizOrVert(LineSegment $p) returns Bool {
    return $p.a.x == $p.b.x || $p.a.y == $p.b.y;
}

sub parseInputLine($line) {
    my @parsed = split(" -> ", $line);
    my @aRaw = split(",", @parsed[0]);
    my @bRaw = split(",", @parsed[1]);
    return LineSegment.new(
        a => Point.new(
            x => @aRaw[0].Int,
            y => @aRaw[1].Int,
        ),
        b => Point.new(
            x => @bRaw[0].Int,
            y => @bRaw[1].Int,
        ),
    );
}

sub printMap(@map) {
    return True;
}

sub pointsInBetween(LineSegment @lss) {
    my Array of Int %points;
    for @lss -> $ls {
        if $ls.a.x == $ls.b.x {
            for [$ls.a.y .. $ls.b.y] -> $y {
                %points{$ls.a.x}.push($y);
            }
            for [$ls.b.y .. $ls.a.y] -> $y {
                %points{$ls.a.x}.push($y);
            }
        } elsif $ls.a.y == $ls.b.y {
            for [$ls.a.x .. $ls.b.x] -> $x {
                %points{$x}.push($ls.a.y);
            }
            for [$ls.b.x .. $ls.a.x] -> $x {
                %points{$x}.push($ls.a.y);
            }
        }
    }
    return %points;
}

sub firstHalf(@lines) returns Int {
    my LineSegment @inScope;
    for @lines -> $line {
        my LineSegment $ls = parseInputLine($line);
        if isHorizOrVert($ls) { @inScope.push($ls); }
    }
    my Array of Int %allInScope = pointsInBetween(@inScope);
    my Int $count;
    for %allInScope.kv -> $k, $v {
        for $v.List.Bag.kv -> $bk, $bv {
            if $bv > 1 {
                $count++;
            }
        }
    }
    return $count;
}

sub MAIN(
    Str :f($file),
){
    my $data = slurp $file;
    say "first half: " ~ firstHalf($data.lines);
}