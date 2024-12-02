module aoc2015::day3;

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

    int[<2>] pos;
    List(<int[<2>]>) houses;
    houses.temp_init(2^14);

    houses.push(pos);
    foreach (direction : data)
    {
        if (direction == '^') ++pos.x;
        if (direction == '>') ++pos.y;
        if (direction == 'v') --pos.x;
        if (direction == '<') --pos.y;
        houses.push(pos);
    }

    List(<int[<2>]>) unique_houses;
    unique_houses.temp_init(2^13);

    unique_houses.push(houses[0]);
    foreach (house : houses)
    {
        for (usz i = 0; i < unique_houses.len(); ++i)
        {
            if (unique_houses[i] == house) {
                break;
            }
            if(i == unique_houses.len() - 1) {
                unique_houses.push(house);
                break;
            }
        }
    }

    return (int)unique_houses.len();
}

fn int part2(String file){
    String data = (String) file::load_new(file)!!;

    int[<2>] pos;
    List(<int[<2>]>) santa;
    List(<int[<2>]>) robot;
    santa.temp_init(2^13);
    robot.temp_init(2^13);

    santa.push(pos);
    robot.push(pos);

    List(<int[<2>]>)*[2] sleigh;
    sleigh[0] = &santa;
    sleigh[1] = &robot;

    for(usz i = 0; i < data.len; ++i)
    {
        if (data[i] == '^') ++pos.x;
        if (data[i] == '>') ++pos.y;
        if (data[i] == 'v') --pos.x;
        if (data[i] == '<') --pos.y;
        sleigh[i % 2].push(pos);
        pos = sleigh[(i + 1) % 2].last()!!;
    }

    List(<int[<2>]>) unique_houses;
    unique_houses.temp_init(2^13);

    List(<int[<2>]>) all_houses;
    all_houses.temp_init(2^14);
    all_houses.add_all(&santa);
    all_houses.add_all(&robot);

    unique_houses.push(santa[0]);
    foreach (house : all_houses)
    {
        for (usz i = 0; i < unique_houses.len(); ++i)
        {
            if (unique_houses[i] == house) {
                break;
            }
            if(i == unique_houses.len() - 1) {
                unique_houses.push(house);
                break;
            }
        }
    }

    return (int)unique_houses.len();
}