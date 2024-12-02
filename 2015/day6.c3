module aoc2015::day6;

import std::io;
import std::time;
import std::collections;

def Instruction = Triple(<int, int[2], int[2]>);

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

    bool[1000][1000] lights;
    int result;

    Instruction instruction;
    String intermediate;

    foreach (rule : data.split("\n")){
        if (rule.strip("toggle ").len < rule.len) {
            instruction.first = 0;
            intermediate = rule.strip("toggle ");
        }
        if (rule.strip("turn on ").len < rule.len) {
            instruction.first = 1;
            intermediate = rule.strip("turn on ");
        }
        if (rule.strip("turn off ").len < rule.len) {
            instruction.first = 2;
            intermediate = rule.strip("turn off ");
        }

        instruction.second[0] = intermediate.split(" through ")[0].split(",")[0].to_int()!!;
        instruction.second[1] = intermediate.split(" through ")[0].split(",")[1].to_int()!!;
        instruction.third[0] = intermediate.split(" through ")[1].split(",")[0].to_int()!!;
        instruction.third[1] = intermediate.split(" through ")[1].split(",")[1].to_int()!!;

        for(usz i = instruction.second[0]; i <= instruction.third[0]; ++i){
            for(usz j = instruction.second[1]; j <= instruction.third[1]; ++j){
                if (instruction.first == 1) lights[i][j] = true;
                if (instruction.first == 2) lights[i][j] = false;
                if (instruction.first == 0) lights[i][j] = !lights[i][j];
            }
        }
    }

    for(usz i = 0; i < lights.len; ++i){
        for (usz j = 0; j < lights[i].len; ++j){
            if (lights[j][i] == true) ++result;
        }
    }

    return result;
}

fn int part2(String file){
    String data = (String) file::load_new(file)!!;

    int[1000][1000] lights;
    int result;

    Instruction instruction;
    String intermediate;

    foreach (rule : data.split("\n")){
        if (rule.strip("toggle ").len < rule.len) {
            instruction.first = 0;
            intermediate = rule.strip("toggle ");
        }
        if (rule.strip("turn on ").len < rule.len) {
            instruction.first = 1;
            intermediate = rule.strip("turn on ");
        }
        if (rule.strip("turn off ").len < rule.len) {
            instruction.first = 2;
            intermediate = rule.strip("turn off ");
        }

        instruction.second[0] = intermediate.split(" through ")[0].split(",")[0].to_int()!!;
        instruction.second[1] = intermediate.split(" through ")[0].split(",")[1].to_int()!!;
        instruction.third[0] = intermediate.split(" through ")[1].split(",")[0].to_int()!!;
        instruction.third[1] = intermediate.split(" through ")[1].split(",")[1].to_int()!!;

        for(usz i = instruction.second[0]; i <= instruction.third[0]; ++i){
            for(usz j = instruction.second[1]; j <= instruction.third[1]; ++j){
                if (instruction.first == 1) ++lights[i][j];
                if (instruction.first == 2) if (--lights[i][j] < 0) lights[i][j] = 0;
                if (instruction.first == 0) lights[i][j] += 2;
            }
        }
    }

    for(usz i = 0; i < lights.len; ++i){
        for (usz j = 0; j < lights[i].len; ++j){
            result += lights[i][j];
        }
    }

    return result;
}
