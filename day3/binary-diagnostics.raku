#!/usr/bin/env raku

sub scoresingle(@tally, @value) {
    loop (my $i = 0; $i < @value.elems; $i++) {
        if @value[$i] == 0 { @tally[$i]--}
        if @value[$i] == 1 { @tally[$i]++}
    }
}

sub scorelist(@values) {
    my @tally of Int;
    for @values -> $val {
        scoresingle(@tally, $val.split("", :skip-empty));
    }
    my ($gamma, $epsilon) = scoretobinary(@tally);
    return $gamma * $epsilon;
}

sub scoretobinary(@values) {
    my $gamma of Str = "0b";
    my $epsilon of Str = "0b";
    for @values -> $val {
        if $val < 0 {
            $gamma = $gamma ~ "0";
            $epsilon = $epsilon ~ "1";
        } else {
            $gamma = $gamma ~ "1";
            $epsilon = $epsilon ~ "0";
        }
    }
    return ($gamma, $epsilon);
}

sub MAIN(
    Str :f($file),
){
    my $data = slurp $file;
    my $result1 = scorelist($data.lines);
    say "first half: $result1";
}
