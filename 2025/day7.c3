module aoc2025::day7;
import std::io;
import std::time;
import std::collections;

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
	
	bool[] row = mem::new_array(bool, data.[0].len);
	
	for(usz j = 0; j < data.len; j += 2){
		for(usz i = 0; i < data[0].len; ++i){
			if (data[j][i] == 'S') {row[i] = true; break;}
			if (data[j][i] == '^' && row[i]) {row[i - 1] = true; row[i] = false; row[i + 1] = true; total++;}
		}
	}

	return total;
}

fn long part2(String file){
	String[] data = ((String) file::load_temp(file)!!).tsplit("\n");
	
	long[] row = mem::new_array(long, data.[0].len);
	
	for(usz i = 0; i < data[0].len; i += 2){
		for(usz j = 0; j < data.len - 1; ++j){
			if (data[i][j] == 'S'){
				row[j] = 1;
				break;
			}
			if (data[i][j] == '^'){
				row[j - 1] += row[j];
				row[j + 1] += row[j];
				row[j] = 0;
				continue;
			}
		}
	}
	return array::@sum(row);
}