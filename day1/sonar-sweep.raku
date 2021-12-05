#!/usr/bin/env raku

sub first(@lines){
    my $count = 0;
    my $first = True;
    my $last = False;
    for @lines -> $line {
        if not $first and $line > $last {
            $count++;
        }
        $first = False;
        $last = $line;
    }
    say "first half: $count";
}

sub second(@lines){
    my $count = 0;
    loop (my $i = 0; $i < @lines.elems - 2; $i++) {
        if $i == 0 {
            next;
        }
        my $last = @lines[$i-1] + @lines[$i] + @lines[$i+1];
        my $current = @lines[$i] + @lines[$i+1] + @lines[$i+2];
        if $current > $last {
            $count++;
        }
    }
    say "second half: $count";
}

sub MAIN(
    Str :f($file), #= input file
){
    my $data = slurp $file;
    first($data.lines);
    second($data.lines);
}
