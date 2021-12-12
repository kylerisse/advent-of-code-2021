#!/usr/bin/env raku

sub parseInstructions(@lines) returns Array of Int {
    my Int @instructions;
    for @lines[0].split(",", :skip-empty) -> $item {
        @instructions.push($item.Int);
    }
    return @instructions;
}

sub parseBoards(@lines) returns Array of Array of Int {
    my Array of Int @boards;
    my Int @sq;
    for @lines[1 .. @lines.elems - 1] -> $line {
        for $line.split(" ", :skip-empty) -> $item {
            @sq.append($item.Int)
        }
        if @sq.elems == 25 {
            @boards.push(@sq.clone);
            @sq = [];
        }
    }
    return @boards;
}

sub mark(Int $pick, Int @board) {
    loop (my $i = 0; $i < @board.elems; $i++) {
        if @board[$i] == $pick {
            @board[$i] = -1;
            last;
        }
    }
}

sub winner(Int @board) returns Bool {
    return check(@board[0..4]) ||
        check(@board[5..9]) ||
        check(@board[10..14]) ||
        check(@board[15..19]) ||
        check(@board[20..24]) ||
        check(@board[0, 5, 10, 15, 20]) ||
        check(@board[1, 6, 11, 16, 21]) ||
        check(@board[2, 7, 12, 17, 22]) ||
        check(@board[3, 8, 13, 18, 23]) ||
        check(@board[4, 9, 14, 19, 24]);
}

sub lastWinner(Array of Int @boards) returns Bool {
    my Int $counter = 0;
    for @boards -> @board {
        if winner(@board) { $counter++ }
    }
    return $counter == @boards.elems;
}

sub check(@squares) returns Bool {
    return @squares.sum == -5;
}

sub score(@board) returns Int {
    my Int $sum;
    for @board -> $square {
        if $square > 0 {
            $sum += $square;
        }
    }
    return $sum;
}

sub solve1($input) returns Int {
    my @lines = $input.lines;
    my Int @instructions = parseInstructions(@lines);
    my Array of Int @boards = parseBoards(@lines);
    for @instructions -> $instruction {
        for @boards -> @board {
            mark($instruction, @board);
            if winner(@board) {
                return score(@board) * $instruction;
            }
        }
    }
}

sub solve2($input) returns Int {
    my @lines = $input.lines;
    my Int @instructions = parseInstructions(@lines);
    my Array of Int @boards = parseBoards(@lines);
    for @instructions -> $instruction {
        for @boards -> @board {
            mark($instruction, @board);
            if lastWinner(@boards) {
                return score(@board) * $instruction;
            }
        }
    }
}

sub debug(@board) {
    say @board[0..4] ~ "\n" ~
        @board[5..9] ~ "\n" ~
        @board[10..14] ~ "\n" ~
        @board[15..19] ~ "\n" ~
        @board[20..24] ~ "\n";
}

sub MAIN(
    Str :f($file),
){
    my $data = slurp $file;
    say "first half: " ~ solve1($data);
    say "second half: " ~ solve2($data);
}
