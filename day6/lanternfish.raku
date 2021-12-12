#!/usr/bin/env raku

sub nextDay(Int @fish) returns Array of Int {
    my Int @newList;
    my Int $newFish = 0;
    for @fish -> $fish {
        if $fish == 0 {
            @newList.push(6);
            $newFish++;
        } else {
            @newList.push($fish - 1);
        }
    }
    loop (my Int $i = $newFish; $i > 0; $i--) {
        @newList.push(8);
    }
    return @newList;
}

sub firstHalf($data) returns Int {
    my @rawFish = split(",", $data);
    my Int @allFish;
    for @rawFish -> $f {
        @allFish.push($f.Int);
    }
    loop (my Int $i = 0; $i < 80; $i++) {
        @allFish = nextDay(@allFish.clone);
    }
    return @allFish.elems;
}

sub nextDayImproved(Int %data) returns Hash of Int {
    my Int %newData;
    if %data{0}:exists { %newData{8} = %data{0} };
    if %data{8}:exists { %newData{7} = %data{8} };
    if %data{7}:exists and %data{0}:exists {
        %newData{6} = %data{7} + %data{0};
    } elsif %data{7}:exists and %data{0}:!exists {
        %newData{6} = %data{7};
    } elsif %data{7}:!exists and %data{0}:exists {
        %newData{6} = %data{0};
    } else {
        %newData{6} = 0;
    };
    loop (my Int $i = 6; $i > 0; $i--) {
        if %data{$i}:exists { %newData{$i - 1} = %data{$i}}
    }
    return %newData;
}

sub secondHalf($data) returns Int {
    my @rawFish = split(",", $data);
    my Int %allFish;
    for @rawFish -> $f {
        %allFish{$f.Int}++;
    }
    loop (my Int $i = 0; $i < 256; $i++) {
        %allFish = nextDayImproved(%allFish.clone);
    }
    my Int $sum = 0;
    for %allFish.kv -> $k, $v {
        $sum += $v;
    }
    return $sum;
}

sub MAIN(
    Str :f($file),
){
    my $data = slurp $file;
    say "first half: " ~ firstHalf($data);
    say "second half: " ~ secondHalf($data);
}
