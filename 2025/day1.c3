module aoc2025::day1;
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

	int current_value = 50;
	int password = 0;

	foreach(instruction : data){
		if(instruction[0] == 'L') current_value -= instruction[1..].to_int()!!;
		if(instruction[0] == 'R') current_value += instruction[1..].to_int()!!;
		current_value = current_value % 100;
		if(current_value == 0) password++;
		if(current_value < 0) current_value += 100;
	}
	return password;
}

fn int part2(String file){
	String[] data = ((String) file::load_temp(file)!!).tsplit("\n");

	int current_value = 50;
	int password = 0;

	foreach(instruction : data){
		io::printn(instruction);
		if(instruction[0] == 'L') current_value -= instruction[1..].to_int()!!;
		if(instruction[0] == 'R') current_value += instruction[1..].to_int()!!;

		if(current_value == 0) password++;
		if(current_value < 0) {
			if(instruction[1..].to_int()!! != math::abs(current_value)) password++;
		}
		if(math::abs(current_value) > 99) {
			password += math::abs(current_value) / 100;
			current_value %= 100;
		}
		if(current_value < 0) current_value += 100;
	}
	return password;
}