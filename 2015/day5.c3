module aoc2015::day5;

import std::io;
import std::time;
import std::collections;

fn void! main(String[] args){
    //Check if input file has been provided. Chrashes will occur when providing input types not consistant with the puzzle.
    if (args.len == 1){
        io::eprintfn("No input was provided.\nUsage: %s <file>", args[0]);
        return IoError.FILE_NOT_FOUND?;
    }

    @pool(){
        Clock c = clock::now();
        io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
        io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
    };
}

fn int part1(String file){
    String data = (String) file::load_new(file)!!;

    String[] forbidden = {"ab", "cd", "pq", "xy"};
    bool contains_forbidden;
    String vouwels = "aeiou";
    int vouwel_count;
    bool double_char;

    char previous_char;

    int nice;

    foreach (line : data.tsplit("\n"))
    {
        foreach (rule : forbidden)
        {
            if (line.contains(rule)) contains_forbidden = true;
        }
        if (contains_forbidden) {
            contains_forbidden = false;
            continue;
        }

        vouwel_count = 0;
        double_char = false;
        foreach (letter : line)
        {
            if (string::char_in_set(letter, vouwels)) ++vouwel_count;
            if (previous_char == letter) double_char = true;
            previous_char = letter;
        }
        previous_char = 0;
        if (vouwel_count > 2 && double_char) ++nice;
    }
    return nice;
}

fn int part2(String file){
    String data = (String) file::load_new(file)!!;

    int nice;

    List(<String>) pairs;
    String previous_pair;
    DString collector;
    bool repeat;
    bool mirror;

    foreach (line : data.tsplit("\n"))
    {
        repeat = false;
        mirror = false;
        previous_pair = "";
        foreach (letter : line)
        {
            collector.append(letter);
            if(collector.len() < 2) continue;
            
            if(pairs.contains(collector.str_view()[^2..])) repeat = true;
            if(previous_pair.len > 0 && (String {previous_pair[1], previous_pair[0]} == collector.str_view()[^2..])) mirror = true;

            if (previous_pair.len == 2) pairs.push(previous_pair);
            previous_pair = collector.str_view()[^2..];
        }

        if (repeat && mirror) ++nice;
        pairs.clear();
        collector.clear();
    }
    return nice;
}