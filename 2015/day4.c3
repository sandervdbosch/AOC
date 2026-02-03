module aoc2015::day4;

import std::io;
import std::time;
import libc;
import std::hash;
import std::encoding;

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
	String input;
	uint guess = 0;

	while(true){
		input = data.tconcat(guess.itoa());
		if (hex::tencode(&&md5::hash(input))[..4] == "00000") return guess;
		++guess;
	}
}

fn int part2(String file){
	String data = (String) file::load_temp(file)!!;
	String input;
	uint guess = 0;

	while(true){
		input = data.tconcat(guess.itoa());
		if (hex::tencode(&&md5::hash(input))[..5] == "000000") return guess;
		++guess;
	}
}

fn String uint.itoa(uint self){
	if (self == 0) return "0";
	DString b;
	while (self > 0){
		b.append_char((char)(self % 10 + '0'));
		self /= 10;
	}
	b.reverse();
	return b.str_view();
}