module aoc2025::day4;
import std::io;
import std::time;

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

	foreach(int i , row : data){
		foreach(int j, roll : row){
			if (data[i][j] != '@') continue;
			char neighbours = 0;
			for(int k = i - 1; k <= i + 1; ++k){
				for(int l = j - 1; l <= j + 1; ++l){
					if (k < 0 || k > data.len - 1 || l < 0 || l > row.len - 1) continue;
					if (data[k][l] == '@') neighbours++;
				}
			}
			if (neighbours <= 4) total++;
		}
	}

	return total;
}

fn int part2(String file){
	String[] data = ((String) file::load_temp(file)!!).tsplit("\n");
	String[] copy = *@clone(data);

	int total;
	int result = 1;

	while(result != 0){
		result = 0;
		foreach(int i , row : data){
			foreach(int j, roll : row){
				if (data[i][j] != '@') continue;
				char neighbours = 0;
				for(int k = i - 1; k <= i + 1; ++k){
					for(int l = j - 1; l <= j + 1; ++l){
						if (k < 0 || k > data.len - 1 || l < 0 || l > row.len - 1) continue;
						if (data[k][l] == '@') neighbours++;
					}
				}
				if (neighbours <= 4){
					copy[i][j] = '.';
					result++;
				}
			}
		}
		data = *@clone(copy);
		total += result;
	}
	return total;
}