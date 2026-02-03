module aoc2025::day9;
import std::io;
import std::time;
import std::collections;
import std::sort;
import std::math;

fn void main(String[] args){
	@pool(){
		Clock c = clock::now();
		// io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
		io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
	};
}

fn long part1(String file){
	String[] data = ((String) file::load_temp(file)!!).tsplit("\n");

	List{long[<2>]} cache;
	cache.tinit(data.len);

	for(usz i = 0; i < data.len; ++i){
		String[] parts = data[i].tsplit(",");
		cache.push({parts[0].to_long()!!, parts[1].to_long()!!});
	}

	long max_space;

	for(usz i = 0; i < cache.len(); ++i){
		long[<2>] from = cache[i];
		for(usz j = 0; j < cache.len(); ++j){
			long[<2>] to = cache[j];
			if ((math::abs(from.x - to.x) + 1) * (math::abs(from.y - to.y) + 1) > max_space){
				max_space = (math::abs(from.x - to.x) + 1) * (math::abs(from.y - to.y) + 1);
			}
		}
	}

	return max_space;
}

fn long part2(String file){
	String[] data = ((String) file::load_temp(file)!!).tsplit("\n");
	
	HashSet{int[2]} edges;
	edges.tinit();
	HashSet{int[2]} corners;
	corners.tinit();
	HashSet{int[2]} begin;
	begin.tinit();
	HashSet{int} coordinates;
	coordinates.tinit();
	
	int[2] previous_pair;
	
	int[2] biggest_size;
	int[2] smallest_size = {int.max, int.max};
	int shrinking_factor = 1;
	
	for(usz i = 0; i <= data.len; ++i){
		String[] parts = data[i % data.len].tsplit(",");
		int[2] pair = {parts[0].to_int()!! / shrinking_factor, parts[1].to_int()!! / shrinking_factor};
		if(i == 0) {previous_pair = pair; edges.add(pair); begin.add(pair); continue;}
		for(int j = math::min(previous_pair[0], pair[0]); j <= math::max(previous_pair[0], pair[0]); ++j){
			for(int k = math::min(previous_pair[1], pair[1]); k <= math::max(previous_pair[1], pair[1]); ++k) edges.add({j, k});
		}
		if (pair[0] + 1 > biggest_size[0]) biggest_size[0] = pair[0] + 1;
		if (pair[1] + 1 > biggest_size[1]) biggest_size[1] = pair[1] + 1;
		if (pair[0] < smallest_size[0]) smallest_size[0] = pair[0];
		if (pair[1] < smallest_size[1]) smallest_size[1] = pair[1];
		corners.add(pair);
		coordinates.add(pair[0]);
		coordinates.add(pair[1]);
		previous_pair = pair;
	}
	
	io::printfn("%s", coordinates);
	io::printfn("%s", coordinates.tvalues()[0..1]);
	io::printfn("%d", math::gcd(...coordinates.tvalues()[0..1]));
	
	return 0;
	
	File? picture = file::open("picture.ppm", "wb");
	defer(picture.close()!!);
	
	int[<2>] picture_size = {(file.contains("example") ? 15 : 100000), (file.contains("example") ? 15 : 100000)};
	picture_size /= shrinking_factor;
	
	picture.write(string::format(tmem, "P6 %d %d 255 ", picture_size[0], picture_size[1]))!!;
	// picture.write("P4\n6 10\n")!!;
	
	// picture.write({8, 8, 8, 8, 8, 8, 136, 112, 0, 0})!!;
	
	// BitWriter stream;
	// stream.init(&picture)!!;
	
	// io::printn(edges);
	char byte;
	char[3] red = {0xFF, 0x00, 0x00};
	char[3] green = {0x00, 0xFF, 0x00};
	char[3] blue = {0x00, 0x00, 0xFF};
	char[3] black = {0x00, 0x00, 0x00};
	
	for(int i = 0; i < picture_size[1]; ++i){
		io::printf("\rWrote line %d of %d, %f%%\t\t", i, picture_size[1], (float)i * 100 / picture_size[1]);
		for(int j = 0; j < picture_size[0]; ++j){
			if(begin.contains({j, i})) {picture.write(&blue)!!; continue;}
			if(corners.contains({j, i})) {picture.write(&red)!!; continue;}
			if(edges.contains({j, i})) {picture.write(&green)!!; continue;}
			if(i == smallest_size[0] + (biggest_size[0] - smallest_size[0]) / 2) {picture.write(&blue)!!; continue;}
			picture.write(&black)!!;
			// picture.write_byte((edges.contains({j, i}) ? '1' : '0'))!!;
			// if(byte_index == 8) {picture.write_byte(byte)!!; byte_index -= 8;}
			// byte <<= 1;
			// byte |= (edges.contains({j, i}) ? 0 : 1);
			// byte_index++;
			// stream.write_bits((edges.contains({j, i}) ? 1 : 0), 1)!!;
		}
		// if (byte_index != 8);
		// for(usz j = 0; j < 8 - byte_index; ++j){
		//     byte <<= 1;
		//     byte |= 1;
		// }
		// picture.write_byte(byte)!!;
		// byte_index = 0;
	}
	
	return 0;
}