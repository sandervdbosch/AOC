module aoc2025::day5;
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

fn int part1(String file){
    String data = (String) file::load_temp(file)!!;
    String[] sections = data.tsplit("\n\n");
    String fresh = sections[0];
    String products = sections[1];

    int total;
    bool valid;

    foreach(product : products.tsplit("\n")){
        valid = false;
        foreach(range : fresh.tsplit("\n")){
            String[] edges = range.tsplit("-");
            if (product.to_long()!! >= edges[0].to_long()!! && product.to_long()!! <= edges[1].to_long()!!) {valid = true; break;}
        }
        if(valid) total++;
    }

    return total;
}

fn long part2(String file){
    String data = ((String) file::load_temp(file)!!).tsplit("\n\n")[0];

    List{long[<2>]} ranges;
    ranges.tinit();

    foreach(original_range : data.tsplit("\n")){
        long begin = original_range.tsplit("-")[0].to_long()!!;
        long end = original_range.tsplit("-")[1].to_long()!!;
        ranges.push({begin, end});
    }

    List{long[<2>]} merger;
    merger.tinit_with_array(ranges.to_tarray());

    usz previous_length;

    while(merger.len() != previous_length){
        previous_length = merger.len();
        ranges.clear();
        ranges.add_all(&merger);
        merger.clear();
        foreach(entry : ranges){
            long begin = entry[0];
            long end = entry[1];
            if (merger.len() == 0) {merger.push({begin, end}); continue;}
            foreach(i, range : merger){
                if((begin <= range[0] && end >= range[0]) || (begin <= range[1] && end >= range[1]) || (begin >= range[0] && end <= range[1])){
                    merger[i][0] = math::min(begin, range[0]);
                    merger[i][1] = math::max(end, range[1]);
                    break;
                }
                if (i == merger.len() - 1) merger.push({begin, end});
            }
        }
    }

    long total;
    foreach(range : merger){
        total += range[1] + 1 - range[0];
    }

    return total;
}