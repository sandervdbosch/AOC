module aoc2025::day8;
import std::io;
import std::time;
import std::collections;
import std::sort;

fn void main(String[] args){
	@pool(){
		Clock c = clock::now();
		io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
		io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
	};
}

alias Circuits = List{List{usz}};

fn int part1(String file){
	String[] data = ((String) file::load_temp(file)!!).tsplit("\n");
	
	HashMap{usz, double[<3>]} cache;
	cache.tinit(data.len);
	HashMap{ulong, usz[2]} distances;
	distances.tinit(data.len * data.len / 2);
	for(usz i = 0; i < data.len; ++i){
		if(!cache.has_key(i)){
			String[] parts = data[i].tsplit(",");
			cache.set(i, {parts[0].to_double()!!, parts[1].to_double()!!, parts[2].to_double()!!});
		}
		double[<3>] from = cache.get(i)!!;
		for(usz j = i + 1; j < data.len; ++j){
			if(!cache.has_key(j)){
				String[] parts = data[j].tsplit(",");
				cache.set(j, {parts[0].to_double()!!, parts[1].to_double()!!, parts[2].to_double()!!});
			}
			double[<3>] to = cache.get(j)!!;
			
			double distance = from.distance(to);
			if (distances.has_key(bitcast((distance), ulong))) unreachable();
			distances.set(bitcast((distance), ulong), {i, j});
		}
	}

	Circuits circuits;
	circuits.tinit();
	
	double[] distance_list = bitcast(distances.tkeys(), double[]);
	quicksort(distance_list);
	
	bool merged;

	for(usz i = 0; i < (file.contains("example") ? 10 : 1000); ++i){
		merged = false;
		usz[2] connection = distances.get(bitcast(distance_list[i], ulong))!!;
		for(usz j = 0; j < circuits.len(); ++j){
			if (circuits[j].contains(connection[0]) && circuits[j].contains(connection[1])) {merged = true; break;}
			if (circuits[j].contains(connection[0])){
				for(usz k = j; k < circuits.len(); ++k){
					if (circuits[k].contains(connection[1])){
						circuits[k].remove_item(connection[1]);
						circuits[j].add_all(&circuits[k]);
						circuits.remove_at(k);
						merged = true;
						break;
					}
				}
				circuits[j].push(connection[1]);
				merged = true;
				break;
			}
			if (circuits[j].contains(connection[1])){
				for(usz k = j; k < circuits.len(); ++k){
					if (circuits[k].contains(connection[0])){
						circuits[k].remove_item(connection[0]);
						circuits[j].add_all(&circuits[k]);
						circuits.remove_at(k);
						merged = true;
						break;
					}
				}
				circuits[j].push(connection[0]);
				merged = true;
				break;
			}
		}
		if (merged) continue;
		List{usz} new;
		new.tinit_with_array({connection[0], connection[1]});
		circuits.push(new);
	}
	
	List{int} circuit_sizes;
	circuit_sizes.tinit(circuits.len());
	
	for(usz i = 0; i < circuits.len(); ++i) circuit_sizes.push((int)circuits[i].len());
	
	int[] sorted_circuit_sizes = circuit_sizes.to_tarray();
	quicksort(sorted_circuit_sizes);
	
	int total = 1;
	
	for(usz i = 0; i < 3; ++i) total *= sorted_circuit_sizes[^(i + 1)];
	
	return total;
}

fn long part2(String file){
	String[] data = ((String) file::load_temp(file)!!).tsplit("\n");
	
	HashMap{usz, double[<3>]} cache;
	cache.tinit(data.len);
	HashMap{ulong, usz[2]} distances;
	distances.tinit(data.len * data.len / 2);
	
	for(usz i = 0; i < data.len; ++i){
		if(!cache.has_key(i)){
			String[] parts = data[i].tsplit(",");
			cache.set(i, {parts[0].to_double()!!, parts[1].to_double()!!, parts[2].to_double()!!});
		}
		double[<3>] from = cache.get(i)!!;
		for(usz j = i + 1; j < data.len; ++j){
			if(!cache.has_key(j)){
				String[] parts = data[j].tsplit(",");
				cache.set(j, {parts[0].to_double()!!, parts[1].to_double()!!, parts[2].to_double()!!});
			}
			double[<3>] to = cache.get(j)!!;
			double distance = from.distance(to);
			if (distances.has_key(bitcast((distance), ulong))) unreachable();
			distances.set(bitcast((distance), ulong), {i, j});
		}
	}

	Circuits circuits;
	circuits.tinit();
	
	foreach(junction : cache.tkeys()){
		List{usz} new;
		new.tinit_with_array({junction});
		circuits.push(new);
	}
	
	double[] distance_list = bitcast(distances.tkeys(), double[]);
	quicksort(distance_list);

	for(usz i = 0; i < distance_list.len; ++i){
		usz[2] connection = distances.get(bitcast(distance_list[i], ulong))!!;
		for(usz j = 0; j < circuits.len(); ++j){
			if (circuits[j].contains(connection[0]) && circuits[j].contains(connection[1])) break;
			if (circuits[j].contains(connection[0])){
				for(usz k = j; k < circuits.len(); ++k){
					if (circuits[k].contains(connection[1])){
						circuits[k].remove_item(connection[1]);
						circuits[j].add_all(&circuits[k]);
						circuits.remove_at(k);
						break;
					}
				}
				circuits[j].push(connection[1]);
				break;
			}
			if (circuits[j].contains(connection[1])){
				for(usz k = j; k < circuits.len(); ++k){
					if (circuits[k].contains(connection[0])){
						circuits[k].remove_item(connection[0]);
						circuits[j].add_all(&circuits[k]);
						circuits.remove_at(k);
						break;
					}
				}
				circuits[j].push(connection[0]);
				break;
			}
		}
		if (circuits.len() == 1) return (long)cache.get(connection[0])!!.x * (long)cache.get(connection[1])!!.x;
	}
	unreachable();
}