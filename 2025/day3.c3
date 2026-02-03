module aoc2025::day3;
import std::io;
import std::time;
import std::math;

fn void main(String[] args){
	@pool(){
		Clock c = clock::now();
		io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
		io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
	};
}

fn int part1(String file){
	String[] data = ((String) file::load_temp(file)!!).tsplit("\n");

	int total;

	char highest;
	usz first_digit;

	foreach(bank : data){
		highest = '0';
		for(usz i = 0; i < bank.len - 1; ++i){
			if(bank[i] > highest) {highest = bank[i]; first_digit = i;}
		}
		total += (highest - '0') * 10;
		highest = '0';
		for(usz i = first_digit + 1; i < bank.len; ++i){
			if(bank[i] > highest) highest = bank[i];
		}
		total += (highest - '0');
	}

	return total;
}

fn long part2(String file){
	String[] data = ((String) file::load_temp(file)!!).tsplit("\n");

	long total;

	char highest;
	int best_digit = -1;

	foreach(bank : data){
		best_digit = -1;
		for(int i = 0; i < 12; ++i){
			highest = '0';
			for(int j = (best_digit + 1); j < bank.len - 11 + i; ++j){
				if(bank[j] > highest) {highest = bank[j]; best_digit = j;}
			}
			total += (long)(highest - '0') * (long)math::pow(10, 12 - i - 1);
		}
	}

	return total;
}