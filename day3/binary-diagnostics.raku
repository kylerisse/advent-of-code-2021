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

sub bintonum($number) {
    return ("0b" ~ Str($number)).Int;
}

sub oxgenrating(@numbers) {
    my @results = @numbers;
    loop (my $i = 0; $i < @numbers[0].comb.elems; $i++) {
        my %current;
        for @results -> $number {
            my $val = $number.comb[$i];
            %current{$val}.push($number);
        }
        if %current{"0"}.elems > %current{"1"}.elems {
            @results = (%current{"0"}.split(" ", :skip-empty));
        } else {
            @results = (%current{"1"}.split(" ", :skip-empty));
        }
    }
    return bintonum(@results[0]);
}

sub co2scrubrating(@numbers) {
    my @results = @numbers;
    loop (my $i = 0; $i < @numbers[0].comb.elems; $i++) {
        my %current;
        for @results -> $number {
            my $val = $number.comb[$i];
            %current{$val}.push($number);
        }
        if %current{"0"}.elems > %current{"1"}.elems {
            @results = (%current{"1"}.split(" ", :skip-empty));
        } else {
            @results = (%current{"0"}.split(" ", :skip-empty));
        }
        if @results.elems == 1 {
            last;
        }
    }
    return bintonum(@results[0]);
}

sub MAIN(
    Str :f($file),
){
    my $data = slurp $file;
    my $result1 = scorelist($data.lines);
    say "first half: $result1";
    say "second half: " ~ (oxgenrating($data.lines) * co2scrubrating($data.lines));
}
