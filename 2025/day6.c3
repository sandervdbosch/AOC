module aoc2025::day6;
import std::io;
import std::time;
import std::collections;
import std::math;

fn void main(String[] args){
	@pool(){
		Clock c = clock::now();
		io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
		io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
	};
}

fn long part1(String file){
	String[] data = ((String) file::load_temp(file)!!).tsplit("\n");

	List{String[]} worksheet;
	worksheet.tinit();

	foreach(row : data){
		worksheet.push(row.tsplit(" ", skip_empty : true));
	}

	long total;

	List{int} equation;
	equation.tinit(worksheet.len());

	for(usz i = 0; i < worksheet[0].len; ++i){
		long result;
		equation.clear();
		for(usz j = 0; j < worksheet.len() - 1; ++j){
			equation.push(worksheet[j][i].to_int()!!);
		}
		switch(worksheet[worksheet.len() - 1][i]){
			case "+": result = array::@sum(equation);
			case "*": result = array::@product(equation);
			default: unreachable();
		}
		total += result;
	}

	return total;
}

fn long part2(String file){
	String[] data = ((String) file::load_temp(file)!!).tsplit("\n");

	List{String[]} worksheet;
	worksheet.tinit();
	List{String} row;
	row.tinit();
	DString accumulator;
	accumulator.tinit();

	for(usz i = 0; i < data[0].len; ++i){
		for(usz j = 0; j < data.len - 1; ++j){
			if(row.len() == 0) row.push(string::tformat("%c", data[data.len - 1][i]));
			accumulator.append_char(data[j][i]);
		}
		if(accumulator.str_view().trim().len == 0){
			worksheet.push(row.to_tarray());
			row.clear();
			accumulator.clear();
			continue;
		};
		row.push(accumulator.tcopy_str());
		accumulator.clear();
	}
	worksheet.push(row.to_tarray());
	
	long total;
	
	foreach(equation : worksheet){
		long result;
		switch(equation[0]){
			case "+": for(usz i = 1; i < equation.len; ++i) result += equation[i].trim().to_int()!!;
			case "*": {result++; for(usz i = 1; i < equation.len; ++i) result *= equation[i].trim().to_int()!!;}
			default: unreachable();
		}
		total += result;
	}

	return total;
}