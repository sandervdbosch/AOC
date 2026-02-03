module aoc2015::day1;

import std::io;
import std::time;

fn void main(String[] args){
	//Check if input file has been provided. Chrashes will occur when providing input types not consistant with the puzzle.
	if (args.len == 1){
		io::eprintfn("No input was provided.\nUsage: %s <file>", args[0]);
		return;
	}

	@pool(){
		Clock c = clock::now();
		io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
		io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
	};
}

fn int part1(String file){
	String data = (String) file::load_temp(file)!!;

	int depth;
	for (usz i = 0; i < data.len; ++i)
	{
		if(data[i] == '(') ++depth;
		if(data[i] == ')') --depth;
	}
	return depth;
}

fn int part2(String file){
	String data = (String) file::load_temp(file)!!;

	int depth;
	for (usz i = 0; i < data.len; ++i)
	{
		if(data[i] == '(') ++depth;
		if(data[i] == ')') --depth;
		if(depth < 0) return (int) i + 1;
	}
	unreachable();
}