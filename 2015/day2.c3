module aoc2015::part2;

import std::io;
import std::time;
import std::collections;
import std::sort;

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

	List{int} present;
	int surface;

	foreach (line : data.tsplit("\n"))
	{
		present.push(line.tsplit("x")[0].to_int()!!);
		present.push(line.tsplit("x")[1].to_int()!!);
		present.push(line.tsplit("x")[2].to_int()!!);

		sort::quicksort(&present);

		surface += (present[0] * present[1] +
					present[1] * present[2] +
					present[2] * present[0]) * 2 + present[0] * present[1];

		present.clear();
	}
	return surface;
}

fn int part2(String file){
	String data = (String) file::load_temp(file)!!;

	List{int} present;
	int length;

	foreach (line : data.tsplit("\n"))
	{
		present.push(line.tsplit("x")[0].to_int()!!);
		present.push(line.tsplit("x")[1].to_int()!!);
		present.push(line.tsplit("x")[2].to_int()!!);

		sort::quicksort(&present);

		length += (present[0] + present[1]) * 2 + present[0] * present[1] * present[2];

		present.clear();
	}
	return length;
}